from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import settings
from app.database import Base, engine
from app.routers import auth, buddies, chat

# Create tables (for production use Alembic migrations instead)
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Professional Buddy API", version="1.0.0")

origins = ["*"] if settings.allowed_origins == "*" else settings.allowed_origins.split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router)
app.include_router(buddies.router)
app.include_router(chat.router)


@app.get("/")
def root():
    return {"status": "ok", "service": "Professional Buddy API"}


@app.get("/health")
def health():
    return {"status": "healthy"}
