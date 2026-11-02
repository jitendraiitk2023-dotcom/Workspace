# Professional Buddy — Backend (FastAPI + PostgreSQL)

## What's included
- **Auth**: register/login with JWT, bcrypt password hashing
- **Buddies**: search users, send/accept/reject buddy requests, list buddies with last-message preview & unread counts
- **Chat**: REST message history + a WebSocket endpoint for real-time 1:1 messaging
- Ready to extend with calling (Agora/Twilio) later — see note at bottom

## 1. Setup

```bash
cd backend
python3 -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## 2. Database

Install PostgreSQL locally (or use a hosted one like Supabase/Neon/Railway), then:

```sql
CREATE DATABASE buddy_db;
CREATE USER buddy_user WITH PASSWORD 'buddy_pass';
GRANT ALL PRIVILEGES ON DATABASE buddy_db TO buddy_user;
```

Copy `.env.example` to `.env` and fill in your real `DATABASE_URL` and a strong random `SECRET_KEY`:

```bash
cp .env.example .env
# generate a secret key:
python3 -c "import secrets; print(secrets.token_hex(32))"
```

Tables are auto-created on first run via `Base.metadata.create_all()`. For production, switch to Alembic migrations (already in requirements.txt).

## 3. Run

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Visit `http://localhost:8000/docs` for interactive Swagger UI — you can test every endpoint from the browser.

## 4. API overview

| Endpoint | Method | Description |
|---|---|---|
| `/auth/register` | POST | `{name, email, password}` -> token + user |
| `/auth/login` | POST (form) | OAuth2 form fields `username` (=email), `password` |
| `/auth/me` | GET | current user profile |
| `/auth/me` | PATCH | update name/bio/avatar_color |
| `/buddies/search?q=` | GET | search users by name |
| `/buddies/request/{user_id}` | POST | send a buddy request |
| `/buddies/pending` | GET | requests awaiting your response |
| `/buddies/respond/{request_id}?accept=true|false` | POST | accept/reject |
| `/buddies/` | GET | your buddy list with last message + unread count |
| `/buddies/{user_id}` | DELETE | remove a buddy |
| `/chat/{buddy_id}/messages` | GET | message history (marks incoming as read) |
| `/chat/ws?token=<JWT>` | WebSocket | real-time send/receive: `{"receiver_id","content"}` |

All endpoints except `/auth/register` and `/auth/login` require `Authorization: Bearer <token>`.

## 5. Adding voice/video calling later (Agora)

You chose Agora/Twilio for calling. To add it without restructuring anything:
1. `pip install agora-token-builder`
2. Add a `POST /calls/token` endpoint that takes a `channel_name` and returns an Agora RTC token (generated server-side using your Agora App ID + Certificate).
3. In Flutter, add the `agora_rtc_engine` package and join the channel using the token from step 2.
4. Optionally add a `Call` model + `/calls/invite/{buddy_id}` endpoint that sends a WebSocket "incoming call" event (reuse `ws_manager.py`) so the buddy's app can show an incoming-call screen.

This backend's auth, buddy-list, and WebSocket manager can be reused as-is for that.

## 6. Deployment notes
- Any host that runs Python works: Railway, Render, Fly.io, a VPS with Docker, etc.
- Put the app behind HTTPS/WSS in production (required for real devices).
- Set `ALLOWED_ORIGINS` in `.env` to your actual app domains instead of `*`.
