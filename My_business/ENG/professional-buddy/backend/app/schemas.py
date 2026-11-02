from datetime import datetime
from typing import Optional

from pydantic import BaseModel, EmailStr, ConfigDict

from app.models import BuddyStatus


# ---------- User ----------
class UserCreate(BaseModel):
    name: str
    email: EmailStr
    password: str


class UserLogin(BaseModel):
    email: EmailStr
    password: str


class UserOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    name: str
    email: EmailStr
    avatar_color: str
    avatar_url: Optional[str] = None
    bio: Optional[str] = None
    is_premium: bool
    is_online: bool
    last_seen: datetime


class UserUpdate(BaseModel):
    name: Optional[str] = None
    bio: Optional[str] = None
    avatar_color: Optional[str] = None
    avatar_url: Optional[str] = None


class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserOut


# ---------- Buddy requests ----------
class BuddyRequestOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    sender: UserOut
    receiver: UserOut
    status: BuddyStatus
    created_at: datetime


class BuddyOut(BaseModel):
    """A buddy as seen from the current user's perspective (the OTHER user + last message preview)."""
    user: UserOut
    last_message: Optional[str] = None
    last_message_at: Optional[datetime] = None
    unread_count: int = 0


# ---------- Messages ----------
class MessageCreate(BaseModel):
    receiver_id: str
    content: str


class MessageOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: str
    sender_id: str
    receiver_id: str
    content: str
    is_read: bool
    created_at: datetime
