from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from pydantic import BaseModel, EmailStr
from typing import Optional
import uuid
from datetime import date

from app.database import Base, engine, get_db
from app.models.user import User
from app.models.job_application import JobApplication
from app.core.security import hash_password, verify_password, create_access_token, decode_token
from app.forgot_password import router as forgot_router

# Create all tables on startup
Base.metadata.create_all(bind=engine)

app = FastAPI(title="Job Tracker API")
app.include_router(forgot_router)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],   # tighten this before production
    allow_methods=["*"],
    allow_headers=["*"],
)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")

# ── Pydantic Schemas (request/response shapes) ──────────────────

class RegisterRequest(BaseModel):
    # email: str
    email: EmailStr
    full_name: str
    password: str

class LoginRequest(BaseModel):
    # email: str
    email: EmailStr
    password: str

class JobCreateRequest(BaseModel):
    company: str
    role_title: str
    status: str = "WISHLIST"
    job_url: Optional[str] = None
    notes: Optional[str] = None
    location: Optional[str] = None
    applied_date: Optional[date] = None

# ── Dependency: get current user from JWT ────────────────────────

def get_current_user(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)):
    try:
        payload = decode_token(token)
        user_id = payload.get("sub")
        user = db.query(User).filter(User.id == uuid.UUID(user_id)).first()
        if not user:
            raise HTTPException(status_code=401, detail="User not found")
        return user
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")

# ── AUTH ROUTES ──────────────────────────────────────────────────

@app.post("/api/v1/auth/register", status_code=201)
def register(req: RegisterRequest, db: Session = Depends(get_db)):
    if db.query(User).filter(User.email == req.email).first():
        raise HTTPException(status_code=400, detail="Email already registered")
    user = User(
        email=req.email,
        full_name=req.full_name,
        hashed_password=hash_password(req.password)
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return {"id": str(user.id), "email": user.email, "full_name": user.full_name}

@app.post("/api/v1/auth/login")
def login(req: LoginRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email).first()
    if not user or not verify_password(req.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    token = create_access_token({"sub": str(user.id), "role": user.role})
    return {
        "access_token": token,
        "refresh_token": token,   # placeholder — replace with real refresh token later
        "token_type": "bearer"
    }

@app.get("/api/v1/auth/me")
def get_me(current_user: User = Depends(get_current_user)):
    return {
        "id": str(current_user.id),
        "email": current_user.email,
        "full_name": current_user.full_name,
        "role": current_user.role
    }

# ── JOB ROUTES ───────────────────────────────────────────────────

@app.get("/api/v1/jobs")
def get_jobs(
    status: Optional[str] = None,
    page: int = 1,
    limit: int = 20,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    query = db.query(JobApplication).filter(JobApplication.user_id == current_user.id)
    if status:
        query = query.filter(JobApplication.status == status)
    total = query.count()
    jobs = query.order_by(JobApplication.created_at.desc()).offset((page - 1) * limit).limit(limit).all()
    return {
        "data": [_job_to_dict(j) for j in jobs],
        "total": total,
        "page": page,
        "pages": (total + limit - 1) // limit
    }

@app.post("/api/v1/jobs", status_code=201)
def create_job(
    req: JobCreateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    job = JobApplication(user_id=current_user.id, **req.model_dump())
    db.add(job)
    db.commit()
    db.refresh(job)
    return _job_to_dict(job)

@app.put("/api/v1/jobs/{job_id}")
def update_job(
    job_id: str,
    req: JobCreateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    job = db.query(JobApplication).filter(
        JobApplication.id == uuid.UUID(job_id),
        JobApplication.user_id == current_user.id
    ).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    for key, value in req.model_dump().items():
        setattr(job, key, value)
    db.commit()
    db.refresh(job)
    return _job_to_dict(job)

@app.delete("/api/v1/jobs/{job_id}", status_code=204)
def delete_job(
    job_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    job = db.query(JobApplication).filter(
        JobApplication.id == uuid.UUID(job_id),
        JobApplication.user_id == current_user.id
    ).first()
    if not job:
        raise HTTPException(status_code=404, detail="Job not found")
    db.delete(job)
    db.commit()

@app.get("/health")
def health():
    return {"status": "ok"}

# ── Helper ───────────────────────────────────────────────────────

def _job_to_dict(job: JobApplication) -> dict:
    return {
        "id": str(job.id),
        "company": job.company,
        "role_title": job.role_title,
        "status": job.status,
        "job_url": job.job_url,
        "notes": job.notes,
        "location": job.location,
        "applied_date": job.applied_date.isoformat() if job.applied_date else None,
        "created_at": job.created_at.isoformat(),
    }
