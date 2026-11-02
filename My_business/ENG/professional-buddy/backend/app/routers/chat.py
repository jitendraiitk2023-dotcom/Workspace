from datetime import datetime
from typing import List

from fastapi import APIRouter, Depends, HTTPException, WebSocket, WebSocketDisconnect, Query
from sqlalchemy import or_, and_
from sqlalchemy.orm import Session

from app import models, schemas
from app.auth import get_current_user, decode_token
from app.database import get_db, SessionLocal
from app.ws_manager import manager

router = APIRouter(prefix="/chat", tags=["chat"])


@router.get("/{buddy_id}/messages", response_model=List[schemas.MessageOut])
def get_message_history(
    buddy_id: str,
    limit: int = 50,
    before: str | None = Query(default=None, description="ISO timestamp - fetch messages older than this (pagination)"),
    db: Session = Depends(get_db),
    current_user: models.User = Depends(get_current_user),
):
    query = db.query(models.Message).filter(
        or_(
            and_(models.Message.sender_id == current_user.id, models.Message.receiver_id == buddy_id),
            and_(models.Message.sender_id == buddy_id, models.Message.receiver_id == current_user.id),
        )
    )
    if before:
        query = query.filter(models.Message.created_at < datetime.fromisoformat(before))

    messages = query.order_by(models.Message.created_at.desc()).limit(limit).all()

    # mark incoming messages as read
    db.query(models.Message).filter(
        models.Message.sender_id == buddy_id,
        models.Message.receiver_id == current_user.id,
        models.Message.is_read == False,  # noqa: E712
    ).update({"is_read": True})
    db.commit()

    return list(reversed(messages))  # oldest first


@router.websocket("/ws")
async def chat_websocket(websocket: WebSocket, token: str = Query(...)):
    """
    Connect with:  wss://<host>/chat/ws?token=<JWT>
    Send JSON:      {"receiver_id": "...", "content": "..."}
    Receive JSON:   {"type": "message", "id", "sender_id", "receiver_id", "content", "created_at"}
                    {"type": "read_receipt", "by_user_id": "...", "up_to": "<iso timestamp>"}
    """
    user_id = decode_token(token)
    if not user_id:
        await websocket.close(code=4001)
        return

    db: Session = SessionLocal()
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        await websocket.close(code=4001)
        db.close()
        return

    await manager.connect(user_id, websocket)
    user.is_online = True
    db.commit()

    try:
        while True:
            data = await websocket.receive_json()
            receiver_id = data.get("receiver_id")
            content = (data.get("content") or "").strip()
            if not receiver_id or not content:
                continue

            msg = models.Message(sender_id=user_id, receiver_id=receiver_id, content=content)
            db.add(msg)
            db.commit()
            db.refresh(msg)

            payload = {
                "type": "message",
                "id": msg.id,
                "sender_id": msg.sender_id,
                "receiver_id": msg.receiver_id,
                "content": msg.content,
                "created_at": msg.created_at.isoformat(),
            }
            # echo back to sender (so their UI can reconcile) and push to receiver if online
            await websocket.send_json(payload)
            await manager.send_to_user(receiver_id, payload)

    except WebSocketDisconnect:
        pass
    finally:
        manager.disconnect(user_id)
        user.is_online = False
        user.last_seen = datetime.utcnow()
        db.commit()
        db.close()
