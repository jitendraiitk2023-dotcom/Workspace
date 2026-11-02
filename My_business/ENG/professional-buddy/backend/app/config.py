from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    database_url: str = "postgresql://buddy_user:buddy_pass@localhost:5432/buddy_db"
    secret_key: str = "dev-secret-change-me"
    algorithm: str = "HS256"
    access_token_expire_minutes: int = 10080  # 7 days
    allowed_origins: str = "*"

    class Config:
        env_file = ".env"


settings = Settings()
