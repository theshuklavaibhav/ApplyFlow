# from pydantic_settings import BaseSettings

# class Settings(BaseSettings):
#     DATABASE_URL: str
#     SECRET_KEY: str
#     ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
#     REDIS_URL: str | None = None
#     class Config:
#         env_file = ".env"

# settings = Settings()


# Backend/app/config.py
#
# Full replacement for your existing config.py.
# Adds 3 things needed for Render + Upstash + Neon:
#   1. FORWARDED_ALLOW_IPS  — fixes rate limiting behind Render's proxy
#   2. Redis URL validator   — catches wrong rediss:// vs redis:// early
#   3. DATABASE_URL validator — auto-adds sslmode=require for Neon
#
# All existing settings (SECRET_KEY, DATABASE_URL, etc.) unchanged.
# All your existing imports like `from app.config import settings` still work.

from pydantic_settings import BaseSettings
from pydantic import field_validator


class Settings(BaseSettings):

    # ── Database ──────────────────────────────────────────────────────────────
    DATABASE_URL: str

    @field_validator("DATABASE_URL")
    @classmethod
    def ensure_neon_ssl(cls, v: str) -> str:
        """
        Neon PostgreSQL drops connections without SSL.
        Auto-append sslmode=require if it's missing on a Neon URL.
        """
        if "neon.tech" in v and "sslmode" not in v:
            separator = "&" if "?" in v else "?"
            v = f"{v}{separator}sslmode=require"
        return v

    # ── Redis ─────────────────────────────────────────────────────────────────
    REDIS_URL: str

    @field_validator("REDIS_URL")
    @classmethod
    def ensure_upstash_tls(cls, v: str) -> str:
        """
        Upstash Redis requires TLS — connection string must use rediss://
        (double s), not redis://. Catch this mistake at startup, not at
        runtime when a logout attempt silently fails.
        """
        if "upstash.io" in v and not v.startswith("rediss://"):
            raise ValueError(
                "Upstash Redis requires TLS. "
                "Change REDIS_URL from 'redis://' to 'rediss://' "
                "(double s). Copy the exact URL from console.upstash.com "
                "→ your database → Details → REDIS_URL."
            )
        return v

    # ── JWT ───────────────────────────────────────────────────────────────────
    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS:   int = 7

    # ── Rate limiting ─────────────────────────────────────────────────────────
    RATE_LIMIT_PER_MINUTE: int = 100

    # ── Render reverse-proxy ──────────────────────────────────────────────────
    # Render's load balancer adds X-Forwarded-For with the real client IP.
    # This setting tells slowapi to trust that header and use the real IP
    # as the rate-limit key — not Render's internal load balancer IP.
    #
    # Set to "*" in production (FORWARDED_ALLOW_IPS=* in Render env vars).
    # Defaults to localhost-only for local dev safety.
    FORWARDED_ALLOW_IPS: str = "127.0.0.1"

    # ── App ───────────────────────────────────────────────────────────────────
    ENVIRONMENT: str = "development"

    @property
    def is_production(self) -> bool:
        return self.ENVIRONMENT == "production"

    @property
    def is_development(self) -> bool:
        return self.ENVIRONMENT in ("development", "dev")

    @property
    def is_test(self) -> bool:
        return self.ENVIRONMENT == "test"

    class Config:
        env_file = ".env"
        env_file_encoding = "utf-8"
        case_sensitive = True


# Singleton — import everywhere with:
#   from app.config import settings
settings = Settings()
