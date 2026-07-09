<div align="center">

<img src="https://img.shields.io/badge/ApplyFlow-v1.0.0-2563EB?style=for-the-badge&labelColor=0F172A" alt="ApplyFlow"/>

# ApplyFlow

**A full-stack job application tracker — FastAPI backend + Flutter mobile app**

Track every application, interview, and offer in one place. Built with a production-grade backend and a native mobile frontend.

[![FastAPI](https://img.shields.io/badge/FastAPI-0.110+-009688?style=flat-square&logo=fastapi&logoColor=white)](https://fastapi.tiangolo.com/)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-4169E1?style=flat-square&logo=postgresql&logoColor=white)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-7-DC382D?style=flat-square&logo=redis&logoColor=white)](https://redis.io/)
[![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=flat-square&logo=docker&logoColor=white)](https://docs.docker.com/)
[![License](https://img.shields.io/badge/License-MIT-059669?style=flat-square)](LICENSE)

<br/>

🔗 **Live API** — `https://applyflow.up.railway.app`
&nbsp;&nbsp;|&nbsp;&nbsp;
📖 **API Docs** — `https://applyflow.up.railway.app/docs`
&nbsp;&nbsp;|&nbsp;&nbsp;
📱 **Flutter App** — [`/mobile`](./mobile)

<br/>

![ApplyFlow Demo](https://raw.githubusercontent.com/yourusername/applyflow/main/docs/demo.gif)
# 📸 Screenshots

<div align="center">

## Authentication

<table>
<tr>
<td align="center">
<img src="Media/login.jpeg" width="260"/><br/>
<b>Login</b>
</td>

<td align="center">
<img src="Media/register.jpeg" width="260"/><br/>
<b>Register</b>
</td>
</tr>
</table>

---

## Dashboard

<table>
<tr>
<td align="center">
<img src="Media/dashboard.jpeg" width="260"/><br/>
<b>Home Dashboard</b>
</td>

<td align="center">
<img src="Media/jobList.jpeg" width="260"/><br/>
<b>Recent Applications</b>
</td>
</tr>
</table>

---

## Job Management

<table>
<tr>
<td align="center">
<img src="Media/addJob.jpeg" width="260"/><br/>
<b>Add Application</b>
</td>

<td align="center">
<img src="Media/profile.jpeg" width="260"/><br/>
<b>Achievements & Progress</b>
</td>
</tr>
</table>

---

## Analytics

<table>
<tr>
<td align="center">
<img src="Media/analytics.jpeg" width="260"/><br/>
<b>Analytics Dashboard</b>
</td>

<td align="center">
<img src="Media/profile.jpeg" width="260"/><br/>
<b>Status Breakdown</b>
</td>
</tr>
</table>

---

## AI Career Copilot

<table>
<tr>
<td align="center">
<img src="Media/aiScreen.jpeg" width="260"/><br/>
<b>AI Career Copilot</b>
</td>

<td align="center">
<img src="Media/upcomingFeatures.jpeg" width="260"/><br/>
<b>Upcoming AI Features</b>
</td>
</tr>
</table>

</div>

</div>

---

## What is ApplyFlow?

ApplyFlow is a **production-grade REST API** paired with a **cross-platform Flutter app** that lets job seekers track their entire application pipeline — from wishlist to offer — in one place.

I built this because I was tracking 200+ job applications in a messy spreadsheet during my own job search. ApplyFlow is the tool I wish I had — and I'm actively using it right now.

**Key engineering decisions worth noting:**
- JWT authentication with **refresh token rotation** — logout actually works by blacklisting tokens in Redis, not just deleting them client-side
- **Cache-aside pattern** with Redis — the stats endpoint is cached per user with automatic invalidation on write operations
- **Repository Pattern + Service Layer** — business logic is fully separated from route handlers and database queries, making the codebase testable without spinning up a real database
- A single Flutter codebase targeting **Android and iOS** via a clean Provider state management architecture

---

## Table of Contents

- [Features](#features)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Database Schema](#database-schema)
- [API Reference](#api-reference)
- [Authentication Flow](#authentication-flow)
- [Getting Started](#getting-started)
- [Running with Docker](#running-with-docker)
- [Running Tests](#running-tests)
- [Flutter App](#flutter-app)
- [Environment Variables](#environment-variables)
- [Deployment](#deployment)
- [Security](#security)
- [Roadmap](#roadmap)

---

## Features

### Backend (FastAPI)
- **JWT Authentication** with access tokens (30 min) and refresh tokens (7 days)
- **Refresh token rotation** — each refresh issues a new refresh token; old one is invalidated
- **Token blacklisting** via Redis — logout is real, not cosmetic
- **Role-based access control** — `USER` and `ADMIN` roles with protected admin endpoints
- **Pagination, filtering, and search** on all list endpoints
- **Redis caching** on high-frequency read endpoints with cache-aside invalidation
- **Rate limiting** — 100 requests/minute per IP
- **Structured request logging** with method, path, status code, and response time
- **Global error handling** — consistent error response shape across all endpoints
- **Alembic database migrations** — schema changes are versioned and repeatable
- **70%+ test coverage** with pytest and an isolated test database

### Flutter App
- **Secure token storage** using platform keychain (never plain SharedPreferences)
- **Auto-login** on app open if a valid token exists
- **State-driven navigation** — AuthGate pattern, no manual Navigator calls on auth events
- **Pull-to-refresh** and optimistic UI updates on add/edit/delete
- **Status pipeline visualization** — color-coded left-edge bar on every card for instant pipeline scanning
- **Filter chips** for status-based filtering without full page reloads
- Works on **Android and iOS** from a single codebase

---

## Tech Stack

| Layer | Technology | Why |
|---|---|---|
| API Framework | FastAPI 0.110+ | Native async, auto OpenAPI docs, Pydantic validation |
| Database | PostgreSQL 15 | ACID compliance, UUID support, excellent indexing |
| ORM | SQLAlchemy 2.0 | Type-safe queries, relationship management |
| Migrations | Alembic | Versioned schema changes, zero-downtime upgrades |
| Cache / Sessions | Redis 7 | Token blacklisting, response caching, rate limiting |
| Auth | python-jose + passlib | Industry-standard JWT, bcrypt password hashing |
| Testing | pytest + httpx | Async-compatible test client, isolated test DB |
| Containerization | Docker + Compose | Reproducible environment across dev and prod |
| CI/CD | GitHub Actions | Automated test + lint on every PR |
| Deployment | Railway.app | Zero-config PostgreSQL + Redis + app hosting |
| Mobile | Flutter 3.x | Single codebase for Android and iOS |
| State Management | Provider | Lightweight, fits the app's complexity level |

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Flutter App                             │
│   LoginScreen → AuthGate → JobListScreen → AddEditScreen   │
│        Provider (AuthProvider, JobProvider)                 │
│        ApiService (HTTP + JWT headers)                      │
└──────────────────────────┬──────────────────────────────────┘
                           │ HTTPS / REST
                           ▼
┌─────────────────────────────────────────────────────────────┐
│                   FastAPI Application                       │
│                                                             │
│  Routers → Services → Repositories → SQLAlchemy Models     │
│                  ↕                                          │
│           Core (JWT · RBAC · Rate Limit · Logging)         │
└──────────┬──────────────────────────────┬───────────────────┘
           │                              │
           ▼                              ▼
  ┌─────────────────┐          ┌─────────────────────┐
  │   PostgreSQL    │          │        Redis         │
  │  (Primary DB)   │          │  Cache · Blacklist   │
  │  Users + Jobs   │          │  Rate Limiting       │
  └─────────────────┘          └─────────────────────┘
```

**Request lifecycle:**
1. Flutter sends request with `Authorization: Bearer <token>` header
2. FastAPI middleware logs the request and checks rate limit in Redis
3. `get_current_user` dependency decodes JWT and verifies token is not blacklisted
4. Route handler calls the Service layer (business logic)
5. Service calls Repository layer (database queries via SQLAlchemy)
6. Response is serialized by Pydantic and returned as JSON
7. Middleware logs response status and duration

---

## Project Structure

```
applyflow/
├── .github/
│   └── workflows/
│       └── ci.yml                 # Run tests + lint on every PR
│
├── app/
│   ├── main.py                    # FastAPI app init, middleware, router registration
│   ├── config.py                  # Pydantic settings from environment variables
│   ├── database.py                # SQLAlchemy engine, session factory, Base
│   │
│   ├── models/                    # SQLAlchemy ORM models (database tables)
│   │   ├── user.py
│   │   └── job_application.py
│   │
│   ├── schemas/                   # Pydantic schemas (request/response validation)
│   │   ├── user.py
│   │   ├── job_application.py
│   │   └── common.py              # PaginatedResponse[T], generic wrapper
│   │
│   ├── routers/                   # FastAPI route handlers (thin — delegate to services)
│   │   ├── auth.py
│   │   ├── jobs.py
│   │   └── admin.py
│   │
│   ├── services/                  # Business logic (validation, orchestration)
│   │   ├── auth_service.py
│   │   └── job_service.py
│   │
│   ├── repositories/              # Database queries (Repository Pattern)
│   │   ├── user_repo.py
│   │   └── job_repo.py
│   │
│   ├── core/
│   │   ├── security.py            # JWT creation/decode, password hashing
│   │   ├── dependencies.py        # get_current_user, require_admin, get_db
│   │   ├── exceptions.py          # Custom HTTPException subclasses
│   │   └── middleware.py          # Request logging, CORS
│   │
│   └── cache/
│       └── redis_client.py        # Redis connection, cache helpers, TTL management
│
├── alembic/
│   ├── env.py
│   └── versions/
│       └── 001_initial_schema.py  # First migration: users + job_applications tables
│
├── tests/
│   ├── conftest.py                # Test DB setup, fixtures: client, test_user, auth_headers
│   ├── test_auth.py               # Register, login, refresh, logout, /me
│   ├── test_jobs.py               # CRUD, filtering, pagination, ownership isolation
│   └── test_admin.py              # Admin-only endpoints, role enforcement
│
├── mobile/                        # Flutter application
│   ├── lib/
│   │   ├── main.dart
│   │   ├── models/
│   │   ├── services/
│   │   ├── providers/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── utils/
│   └── pubspec.yaml
│
├── .env.example
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── docker-compose.test.yml
├── requirements.txt
├── requirements-dev.txt
└── README.md
```

---

## Database Schema

```sql
-- Users
CREATE TABLE users (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email           VARCHAR(255) UNIQUE NOT NULL,
    full_name       VARCHAR(255) NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    role            VARCHAR(20)  NOT NULL DEFAULT 'USER',   -- USER | ADMIN
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Job Applications
CREATE TABLE job_applications (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id         UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    company         VARCHAR(255) NOT NULL,
    role_title      VARCHAR(255) NOT NULL,
    status          VARCHAR(50)  NOT NULL DEFAULT 'WISHLIST',
    -- WISHLIST | APPLIED | OA | INTERVIEW | OFFER | REJECTED | WITHDRAWN
    job_url         TEXT,
    notes           TEXT,
    location        VARCHAR(255),
    is_remote       BOOLEAN DEFAULT FALSE,
    applied_date    DATE,
    follow_up_date  DATE,
    created_at      TIMESTAMPTZ DEFAULT NOW(),
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes — added after profiling query patterns
CREATE INDEX idx_jobs_user_id  ON job_applications(user_id);
CREATE INDEX idx_jobs_status   ON job_applications(status);
CREATE INDEX idx_jobs_company  ON job_applications(company);
```

**Design decisions:**
- `UUID` primary keys instead of serial integers — no sequential ID enumeration, safer for public APIs
- `ON DELETE CASCADE` on `user_id` — deleting a user cleans up all their applications atomically
- `TIMESTAMPTZ` (with timezone) not `TIMESTAMP` — avoids subtle bugs when servers or users are in different timezones
- Indexes on `user_id`, `status`, and `company` — the three columns that appear in every `WHERE` clause

---

## API Reference

### Auth

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `POST` | `/api/v1/auth/register` | Public | Create a new account |
| `POST` | `/api/v1/auth/login` | Public | Login and get tokens |
| `POST` | `/api/v1/auth/refresh` | Refresh token | Issue new access token |
| `POST` | `/api/v1/auth/logout` | JWT | Blacklist refresh token |
| `GET` | `/api/v1/auth/me` | JWT | Current user profile |

### Job Applications

| Method | Endpoint | Auth | Description |
|---|---|---|---|
| `GET` | `/api/v1/jobs` | JWT | List jobs (paginated, filtered) |
| `POST` | `/api/v1/jobs` | JWT | Create a new application |
| `GET` | `/api/v1/jobs/{id}` | JWT | Single application |
| `PUT` | `/api/v1/jobs/{id}` | JWT | Update application |
| `DELETE` | `/api/v1/jobs/{id}` | JWT | Delete application |
| `GET` | `/api/v1/jobs/stats` | JWT | Counts by status (Redis cached) |
| `GET` | `/api/v1/jobs/export` | JWT | Export all as CSV |

### Query Parameters — `GET /api/v1/jobs`

| Parameter | Type | Example | Description |
|---|---|---|---|
| `status` | string | `APPLIED` | Filter by status |
| `company` | string | `Google` | Search by company name |
| `page` | int | `1` | Page number (default: 1) |
| `limit` | int | `20` | Results per page (max: 100) |
| `sort` | string | `created_at` | Sort field |
| `order` | string | `desc` | `asc` or `desc` |

**Example response — `GET /api/v1/jobs`:**
```json
{
  "data": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "company": "Razorpay",
      "role_title": "SDE-1 Backend",
      "status": "INTERVIEW",
      "location": "Bengaluru",
      "applied_date": "2026-06-27",
      "created_at": "2026-06-27T10:30:00+05:30"
    }
  ],
  "total": 24,
  "page": 1,
  "pages": 2
}
```

### Admin (ADMIN role required)

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/api/v1/admin/users` | List all users |
| `GET` | `/api/v1/admin/users/{id}` | User detail + their applications |
| `GET` | `/api/v1/admin/stats` | Platform-wide statistics |

### Health

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/health` | App health check |
| `GET` | `/health/db` | PostgreSQL connectivity check |
| `GET` | `/health/cache` | Redis connectivity check |

---

## Authentication Flow

```
REGISTER
  POST /auth/register  →  hash password (bcrypt, cost=12)
                       →  store user in PostgreSQL
                       →  return user object (no tokens — intentional)

LOGIN
  POST /auth/login     →  verify bcrypt hash
                       →  generate access_token  (JWT, 30 min)
                       →  generate refresh_token (JWT, 7 days)
                       →  store refresh_token hash in Redis
                       →  return { access_token, refresh_token }

AUTHENTICATED REQUEST
  Any protected route  →  extract Bearer token from header
                       →  decode JWT, verify signature + expiry
                       →  check token not in Redis blacklist
                       →  inject current_user into route handler

REFRESH
  POST /auth/refresh   →  verify refresh_token signature
                       →  check token hash exists in Redis
                       →  issue new access_token
                       →  rotate refresh_token (old invalidated)

LOGOUT
  POST /auth/logout    →  add refresh_token hash to Redis blacklist
                       →  next /refresh attempt returns 401
```

---

## Getting Started

### Prerequisites

- Python 3.11+
- PostgreSQL 15+
- Redis 7+
- Flutter 3.x (for the mobile app)

### Backend

```bash
# 1. Clone the repo
git clone https://github.com/yourusername/applyflow.git
cd applyflow

# 2. Create virtual environment
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Set up environment
cp .env.example .env
# Edit .env with your PostgreSQL and Redis credentials

# 5. Create the database
createdb applyflow

# 6. Run migrations
alembic upgrade head

# 7. Start the server
uvicorn app.main:app --reload
```

API is live at `http://localhost:8000`
Interactive docs at `http://localhost:8000/docs`

### Flutter App

```bash
cd mobile
flutter pub get
flutter run
```

> **Note:** On Android emulator, the backend is reachable at `http://10.0.2.2:8000`.
> On iOS simulator, use `http://localhost:8000`.
> On a physical device (same WiFi), use your machine's local IP, e.g. `http://192.168.1.5:8000`.

---

## Running with Docker

The entire stack (API + PostgreSQL + Redis) runs in one command:

```bash
# Start all services
docker-compose up --build

# Run in background
docker-compose up -d

# Stop everything
docker-compose down

# Stop and wipe database volume
docker-compose down -v
```

Services:
| Service | Port | Description |
|---|---|---|
| API | `8000` | FastAPI application |
| PostgreSQL | `5432` | Database |
| Redis | `6379` | Cache and session store |

**`docker-compose.yml` highlights:**
- PostgreSQL and Redis have health checks — the API container waits until both are healthy before starting
- Database data is persisted in a named volume (`postgres_data`) — data survives `docker-compose down`
- The API container runs as a non-root user
- Environment variables are loaded from `.env` — never hardcoded in the compose file

---

## Running Tests

```bash
# Install dev dependencies
pip install -r requirements-dev.txt

# Run all tests
pytest

# Run with coverage report
pytest --cov=app --cov-report=term-missing

# Run a specific test file
pytest tests/test_auth.py -v

# Run tests matching a name pattern
pytest -k "test_login" -v
```

**Test architecture:**
- Tests use a **separate SQLite in-memory database** — no PostgreSQL required to run the test suite
- Each test gets a **fresh database state** via a session-scoped fixture
- Auth tests cover: register, login with wrong password, expired token, logout + reuse attempt
- Job tests cover: create, read, update, delete, ownership isolation (user A cannot access user B's jobs), pagination, filtering
- CI runs the full test suite on every pull request via GitHub Actions

---

## Flutter App

```
mobile/lib/
├── main.dart                  # App entry, MultiProvider setup, AuthGate routing
├── utils/constants.dart       # Colors, API base URL
│
├── models/
│   ├── user.dart              # User model with fromJson
│   └── job_application.dart   # JobApplication model with fromJson/toJson
│
├── services/
│   ├── api_service.dart       # Base HTTP client — injects JWT header on every request
│   ├── auth_service.dart      # Login, register, token storage (flutter_secure_storage)
│   └── job_service.dart       # Job CRUD — maps HTTP responses to model objects
│
├── providers/
│   ├── auth_provider.dart     # Holds User?, isLoading, error — drives AuthGate
│   └── job_provider.dart      # Holds job list, active filter, computed stats
│
├── screens/
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── job_list_screen.dart   # Main screen with stats, filters, paginated list
│   └── add_edit_job_screen.dart  # Shared form for add and edit (existingJob param)
│
└── widgets/
    ├── job_card.dart          # Card with colored status bar (the signature UI element)
    ├── status_chip.dart       # Color-coded status badge
    └── stat_card.dart         # Dashboard metric card (Applied/Interview/Offer count)
```

**State management pattern:**

```
User action (tap button)
    → Screen calls Provider method (context.read<JobProvider>().addJob())
    → Provider calls Service (JobService.createJob())
    → Service calls ApiService (POST /api/v1/jobs with JWT header)
    → Response parsed into JobApplication model
    → Provider updates _jobs list, calls notifyListeners()
    → All Consumer/context.watch widgets rebuild automatically
```

No manual `setState` on the list — the Provider is the single source of truth.

---

## Environment Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `DATABASE_URL` | ✅ | — | PostgreSQL connection string |
| `SECRET_KEY` | ✅ | — | JWT signing key (min 32 chars) |
| `REDIS_URL` | ✅ | — | Redis connection string |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | ❌ | `30` | Access token TTL |
| `REFRESH_TOKEN_EXPIRE_DAYS` | ❌ | `7` | Refresh token TTL |
| `RATE_LIMIT_PER_MINUTE` | ❌ | `100` | Max requests per IP per minute |
| `ENVIRONMENT` | ❌ | `development` | `development` or `production` |

**Generate a secure `SECRET_KEY`:**
```bash
python -c "import secrets; print(secrets.token_hex(32))"
```

---

## Deployment

ApplyFlow is deployed on **Railway.app** — PostgreSQL, Redis, and the FastAPI app run as three separate Railway services.

### Deploy to Railway

```bash
# 1. Install Railway CLI
npm install -g @railway/cli

# 2. Login
railway login

# 3. Initialize project
railway init

# 4. Add PostgreSQL and Redis plugins from Railway dashboard

# 5. Set environment variables in Railway dashboard
#    DATABASE_URL, SECRET_KEY, REDIS_URL are auto-set by Railway plugins

# 6. Deploy
railway up
```

### CI/CD with GitHub Actions

Every push to `main`:
1. Runs `ruff` linter
2. Runs full pytest suite against SQLite test database
3. If all checks pass — auto-deploys to Railway

`.github/workflows/ci.yml`:
```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with: { python-version: '3.11' }
      - run: pip install -r requirements-dev.txt
      - run: ruff check app/
      - run: pytest --cov=app
```

---

## Security

| Practice | Implementation |
|---|---|
| Password hashing | bcrypt with cost factor 12 — never stored in plaintext |
| JWT signing | HMAC-SHA256 with a 256-bit random secret |
| Token expiry | Access: 30 min · Refresh: 7 days |
| Refresh token rotation | New refresh token issued on each refresh; old one invalidated |
| Logout invalidation | Refresh token hash stored in Redis; checked on every /refresh |
| SQL injection prevention | SQLAlchemy parameterized queries — raw SQL never used |
| Rate limiting | 100 req/min per IP via `slowapi` + Redis |
| CORS | Origin whitelist — `*` only in development |
| Input validation | Pydantic validates and coerces all request bodies automatically |
| Non-root container | Docker runs the app as a dedicated `appuser` |
| Secrets management | All secrets via environment variables — never committed to git |

---

## Roadmap

- [x] JWT authentication with refresh token rotation
- [x] Role-based access control (USER / ADMIN)
- [x] Job application CRUD with pagination and filtering
- [x] Redis caching + cache invalidation
- [x] Rate limiting
- [x] Docker + docker-compose
- [x] GitHub Actions CI/CD
- [x] Flutter mobile app (Android + iOS)
- [ ] Push notifications when follow-up date is reached
- [ ] Resume PDF attachment per application
- [ ] Interview prep notes linked to each application
- [ ] Analytics dashboard (application rate, response rate, funnel conversion)
- [ ] Bulk import from CSV
- [ ] Web app (React or Next.js)

---

## Contributing

Pull requests are welcome.

```bash
# Fork the repo, then:
git checkout -b feature/your-feature-name
# Make changes
git commit -m "feat: add your feature"
git push origin feature/your-feature-name
# Open a PR against main
```

Commit message format: `type: description`
Types: `feat` · `fix` · `docs` · `refactor` · `test` · `chore`

---

## Author

**Vaibhav Singh**
B.Tech CSE · GNIOT, Noida · Class of 2026

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-0077B5?style=flat-square&logo=linkedin)](https://linkedin.com/in/vaibhav-shukla-248810249)
[![GitHub](https://img.shields.io/badge/GitHub-Follow-181717?style=flat-square&logo=github)](https://theshuklavaibhav)
[![Email](https://img.shields.io/badge/Email-Contact-D97706?style=flat-square&logo=gmail&logoColor=white)](mailto:vaibhavshuklaofficial8586@gmail.com)

---

## License

MIT — see [LICENSE](LICENSE) for details.

---

<div align="center">
<sub>Built with FastAPI · Flutter · PostgreSQL · Redis · Docker</sub>
</div>
