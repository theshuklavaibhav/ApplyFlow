# Dockerfile
# Place at: ApplyFlow/Dockerfile  (repo root — already there per screenshot)
#
# Built for your actual stack:
#   - Sync SQLAlchemy (Session, not AsyncSession)
#   - No Redis dependency
#   - Backend/requirements.txt at Backend level
#   - Backend/app/ is the FastAPI package
#   - uvicorn runs: app.main:app

# ── Stage 1: Install dependencies ────────────────────────────────────────────
FROM python:3.11-slim AS builder

WORKDIR /build

# gcc + libpq-dev needed to compile psycopg2
RUN apt-get update && apt-get install -y --no-install-recommends \
        gcc \
        libpq-dev \
    && rm -rf /var/lib/apt/lists/*

COPY Backend/requirements.txt .

RUN pip install --upgrade pip && \
    pip install --prefix=/install --no-cache-dir -r requirements.txt


# ── Stage 2: Lean production image ───────────────────────────────────────────
FROM python:3.11-slim AS production

# Non-root user — security best practice
RUN groupadd -r app && useradd -r -g app -d /app appuser

WORKDIR /app

# Only the runtime lib — no compiler
RUN apt-get update && apt-get install -y --no-install-recommends \
        libpq5 \
    && rm -rf /var/lib/apt/lists/*

# Copy installed packages from builder
COPY --from=builder /install /usr/local

# Copy app code
# Backend/app/ → /app/app/
COPY Backend/app ./app

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    ENVIRONMENT=production \
    PORT=8000

USER appuser

EXPOSE ${PORT}

# ── IMPORTANT: 1 worker for sync SQLAlchemy ──────────────────────────────────
# Your app uses sync Session (not AsyncSession).
# Multiple workers with sync SQLAlchemy + a single DB connection pool
# causes connection contention. Use 1 worker on Render free tier (512MB RAM).
# If you upgrade to async SQLAlchemy later, bump this to 2.
#
# --proxy-headers + --forwarded-allow-ips:
# Render sits behind a load balancer. These flags tell uvicorn to trust
# X-Forwarded-For and X-Forwarded-Proto headers from Render's proxy,
# so your app sees the real client IP and correct protocol (https).
CMD ["sh", "-c", \
     "uvicorn app.main:app \
      --host 0.0.0.0 \
      --port ${PORT} \
      --workers 1 \
      --proxy-headers \
      --forwarded-allow-ips '*'"]