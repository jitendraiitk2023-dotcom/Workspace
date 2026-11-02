import enum
import uuid
from datetime import datetime

from sqlalchemy import (
    Column, String, DateTime, ForeignKey, Text, Boolean, Enum, UniqueConstraint
)
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship

from app.database import Base


def gen_uuid():
    return str(uuid.uuid4())


class BuddyStatus(str, enum.Enum):
    pending = "pending"
    accepted = "accepted"
    rejected = "rejected"
    blocked = "blocked"


class User(Base):
    __tablename__ = "users"

    id = Column(UUID(as_uuid=False), primary_key=True, default=gen_uuid)
    name = Column(String, nullable=False)
    email = Column(String, unique=True, nullable=False, index=True)
    hashed_password = Column(String, nullable=False)
    avatar_color = Column(String, default="#3B82F6")  # hex color for initials avatar
    avatar_url = Column(String, nullable=True)
    bio = Column(String, nullable=True)
    is_premium = Column(Boolean, default=False)
    is_online = Column(Boolean, default=False)
    last_seen = Column(DateTime, default=datetime.utcnow)
    created_at = Column(DateTime, default=datetime.utcnow)

    sent_requests = relationship(
        "BuddyRequest", foreign_keys="BuddyRequest.sender_id", back_populates="sender"
    )
    received_requests = relationship(
        "BuddyRequest", foreign_keys="BuddyRequest.receiver_id", back_populates="receiver"
    )


class BuddyRequest(Base):
    """
    Represents both the request AND the resulting relationship once accepted.
    status = pending -> awaiting receiver action
    status = accepted -> the two users are buddies
    status = rejected -> receiver declined
    status = blocked  -> one user blocked the other
    """
    __tablename__ = "buddy_requests"
    __table_args__ = (UniqueConstraint("sender_id", "receiver_id", name="uq_sender_receiver"),)

    id = Column(UUID(as_uuid=False), primary_key=True, default=gen_uuid)
    sender_id = Column(UUID(as_uuid=False), ForeignKey("users.id"), nullable=False)
    receiver_id = Column(UUID(as_uuid=False), ForeignKey("users.id"), nullable=False)
    status = Column(Enum(BuddyStatus), default=BuddyStatus.pending, nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    responded_at = Column(DateTime, nullable=True)

    sender = relationship("User", foreign_keys=[sender_id], back_populates="sent_requests")
    receiver = relationship("User", foreign_keys=[receiver_id], back_populates="received_requests")


class Message(Base):
    __tablename__ = "messages"

    id = Column(UUID(as_uuid=False), primary_key=True, default=gen_uuid)
    sender_id = Column(UUID(as_uuid=False), ForeignKey("users.id"), nullable=False)
    receiver_id = Column(UUID(as_uuid=False), ForeignKey("users.id"), nullable=False)
    content = Column(Text, nullable=False)
    is_read = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow, index=True)
