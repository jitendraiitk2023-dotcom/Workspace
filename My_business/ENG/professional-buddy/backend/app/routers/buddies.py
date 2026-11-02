from typing import List

from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import or_, and_
from sqlalchemy.orm import Session

from app import models, schemas
from app.auth import get_current_user
from app.database import get_db
from app.ws_manager import manager

router = APIRouter(prefix="/buddies", tags=["buddies"])


def _relationship_between(db: Session, user_a: str, user_b: str):
    return (
        db.query(models.BuddyRequest)
        .filter(
            or_(
                and_(models.BuddyRequest.sender_id == user_a, models.BuddyRequest.receiver_id == user_b),
                and_(models.BuddyRequest.sender_id == user_b, models.BuddyRequest.receiver_id == user_a),
            )
        )
        .first()
    )


@router.get("/search", response_model=List[schemas.UserOut])
def search_users(q: str, db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    if not q or len(q.strip()) == 0:
        return []
    results = (
        db.query(models.User)
        .filter(models.User.id != current_user.id)
        .filter(models.User.name.ilike(f"%{q}%"))
        .limit(20)
        .all()
    )
    return results


@router.post("/request/{user_id}", response_model=schemas.BuddyRequestOut, status_code=201)
def send_buddy_request(user_id: str, db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    if user_id == current_user.id:
        raise HTTPException(400, "Cannot add yourself")

    target = db.query(models.User).filter(models.User.id == user_id).first()
    if not target:
        raise HTTPException(404, "User not found")

    existing = _relationship_between(db, current_user.id, user_id)
    if existing:
        raise HTTPException(400, f"Relationship already exists with status '{existing.status.value}'")

    req = models.BuddyRequest(sender_id=current_user.id, receiver_id=user_id)
    db.add(req)
    db.commit()
    db.refresh(req)
    return req


@router.get("/pending", response_model=List[schemas.BuddyRequestOut])
def list_pending_requests(db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    """Requests sent TO the current user, awaiting response."""
    return (
        db.query(models.BuddyRequest)
        .filter(
            models.BuddyRequest.receiver_id == current_user.id,
            models.BuddyRequest.status == models.BuddyStatus.pending,
        )
        .all()
    )


@router.post("/respond/{request_id}", response_model=schemas.BuddyRequestOut)
def respond_to_request(
    request_id: str,
    accept: bool,
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    req = db.query(models.BuddyRequest).filter(models.BuddyRequest.id == request_id).first()
    if not req:
        raise HTTPException(404, "Request not found")
    if req.receiver_id != current_user.id:
        raise HTTPException(403, "Not your request to respond to")
    if req.status != models.BuddyStatus.pending:
        raise HTTPException(400, "Request already responded to")

    from datetime import datetime
    req.status = models.BuddyStatus.accepted if accept else models.BuddyStatus.rejected
    req.responded_at = datetime.utcnow()
    db.commit()
    db.refresh(req)
    return req


@router.get("/", response_model=List[schemas.BuddyOut])
def list_my_buddies(db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    accepted = (
        db.query(models.BuddyRequest)
        .filter(
            models.BuddyRequest.status == models.BuddyStatus.accepted,
            or_(
                models.BuddyRequest.sender_id == current_user.id,
                models.BuddyRequest.receiver_id == current_user.id,
            ),
        )
        .all()
    )

    result = []
    for rel in accepted:
        other = rel.receiver if rel.sender_id == current_user.id else rel.sender

        last_msg = (
            db.query(models.Message)
            .filter(
                or_(
                    and_(models.Message.sender_id == current_user.id, models.Message.receiver_id == other.id),
                    and_(models.Message.sender_id == other.id, models.Message.receiver_id == current_user.id),
                )
            )
            .order_by(models.Message.created_at.desc())
            .first()
        )

        unread = (
            db.query(models.Message)
            .filter(
                models.Message.sender_id == other.id,
                models.Message.receiver_id == current_user.id,
                models.Message.is_read == False,  # noqa: E712
            )
            .count()
        )

        other.is_online = manager.is_online(other.id)

        result.append(
            schemas.BuddyOut(
                user=schemas.UserOut.model_validate(other),
                last_message=last_msg.content if last_msg else None,
                last_message_at=last_msg.created_at if last_msg else None,
                unread_count=unread,
            )
        )

    # most recent conversation first
    result.sort(key=lambda b: b.last_message_at or b.user.last_seen, reverse=True)
    return result


@router.delete("/{buddy_user_id}")
def remove_buddy(buddy_user_id: str, db: Session = Depends(get_db), current_user: models.User = Depends(get_current_user)):
    rel = _relationship_between(db, current_user.id, buddy_user_id)
    if not rel:
        raise HTTPException(404, "No relationship found")
    db.delete(rel)
    db.commit()
    return {"detail": "Buddy removed"}
