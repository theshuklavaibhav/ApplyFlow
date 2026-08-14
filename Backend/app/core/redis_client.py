# Backend/app/core/redis_client.py
#
# Full replacement — handles both:
#   Local dev  → redis://localhost:6379   (plain, no TLS)
#   Render prod → rediss://...upstash.io  (TLS, Upstash)
#
# Your existing code that uses redis_client stays exactly the same —
# token blacklisting, stats caching, rate limiting all work unchanged.

import redis.asyncio as aioredis
from app.config import settings


def create_redis_client() -> aioredis.Redis:
    """
    Build an async Redis client from REDIS_URL.

    Upstash-specific:
        ssl_cert_reqs="none" — Upstash uses TLS but the client
        doesn't need to verify the cert chain because auth is
        handled by the password token in the URL. Without this,
        redis-py raises SSL: CERTIFICATE_VERIFY_FAILED.

    Local dev:
        When REDIS_URL starts with redis:// (no TLS), ssl_cert_reqs
        is not passed — plain connection as usual.
    """
    url = settings.REDIS_URL
    is_tls = url.startswith("rediss://")   # Upstash always uses rediss://

    kwargs: dict = {
        "encoding": "utf-8",
        "decode_responses": True,
    }

    if is_tls:
        # Required for Upstash — do not remove
        kwargs["ssl_cert_reqs"] = "none"

    return aioredis.from_url(url, **kwargs)


# Module-level singleton
# Import this in your services:
#   from app.core.redis_client import redis_client
redis_client = create_redis_client()


# ── Quick usage reference (no changes needed in your existing code) ───────────
#
# Token blacklisting (logout → block reuse of refresh token):
#   await redis_client.setex(f"blacklist:{token_hash}", expire_seconds, "1")
#   is_blacklisted = await redis_client.exists(f"blacklist:{token_hash}")
#
# Stats cache (GET /api/v1/jobs/stats — cached per user):
#   cached = await redis_client.get(f"stats:{user_id}")
#   await redis_client.setex(f"stats:{user_id}", 300, json.dumps(data))
#   await redis_client.delete(f"stats:{user_id}")  # invalidate on write
#
# Rate limiting (slowapi uses Redis internally via app.state.limiter):
#   No direct calls needed — handled by @limiter.limit() decorator
