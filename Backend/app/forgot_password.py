import os
import random
import string
import smtplib
from datetime import datetime, timedelta
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel, EmailStr
from sqlalchemy.orm import Session

from app.database import get_db
from app.models.otp import OTPStore
from app.models.user import User
from app.core.security import hash_password

router = APIRouter(prefix="/api/v1/auth", tags=["Auth"])

GMAIL_USER     = os.getenv("GMAIL_USER")
GMAIL_PASSWORD = os.getenv("GMAIL_PASSWORD")
OTP_EXPIRY_MIN = 10


class ForgotPasswordRequest(BaseModel):
    email: EmailStr

class VerifyOTPRequest(BaseModel):
    email: EmailStr
    otp: str

class ResetPasswordRequest(BaseModel):
    email: EmailStr
    otp: str
    new_password: str


def generate_otp() -> str:
    return "".join(random.choices(string.digits, k=6))


def send_otp_email(to_email: str, otp: str):
    subject = "ApplyFlow — Your Password Reset OTP"
    body = f"""
    <html><body style="font-family:Arial,sans-serif;max-width:480px;margin:auto">
      <h2 style="color:#0553B1">ApplyFlow</h2>
      <p>Hi,</p>
      <p>You requested a password reset. Use the OTP below:</p>
      <div style="font-size:36px;font-weight:bold;letter-spacing:8px;
                  color:#0553B1;padding:16px;background:#f0f4ff;
                  border-radius:8px;text-align:center;margin:20px 0">
        {otp}
      </div>
      <p>This OTP expires in <strong>{OTP_EXPIRY_MIN} minutes</strong>.</p>
      <p>If you didn't request this, ignore this email.</p>
      <p style="color:#888;font-size:12px">— ApplyFlow Team</p>
    </body></html>
    """
    msg = MIMEMultipart("alternative")
    msg["Subject"] = subject
    msg["From"]    = GMAIL_USER
    msg["To"]      = to_email
    msg.attach(MIMEText(body, "html"))

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        server.login(GMAIL_USER, GMAIL_PASSWORD)
        server.sendmail(GMAIL_USER, to_email, msg.as_string())


@router.post("/forgot-password")
def forgot_password(req: ForgotPasswordRequest, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.email == req.email).first()

    if not user:
        return {"message": "If this email is registered, an OTP has been sent."}

    db.query(OTPStore).filter(OTPStore.email == req.email).delete()

    otp        = generate_otp()
    expires_at = datetime.utcnow() + timedelta(minutes=OTP_EXPIRY_MIN)

    db.add(OTPStore(email=req.email, otp=otp, expires_at=expires_at))
    db.commit()

    try:
        send_otp_email(req.email, otp)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to send email: {str(e)}")

    return {"message": "If this email is registered, an OTP has been sent."}


@router.post("/verify-otp")
def verify_otp(req: VerifyOTPRequest, db: Session = Depends(get_db)):
    record = (
        db.query(OTPStore)
        .filter(OTPStore.email == req.email, OTPStore.otp == req.otp)
        .first()
    )

    if not record:
        raise HTTPException(status_code=400, detail="Invalid OTP.")

    if datetime.utcnow() > record.expires_at:
        db.delete(record)
        db.commit()
        raise HTTPException(status_code=400, detail="OTP expired. Please request a new one.")

    record.is_verified = True
    db.commit()

    return {"message": "OTP verified. You may now reset your password."}


@router.post("/reset-password")
def reset_password(req: ResetPasswordRequest, db: Session = Depends(get_db)):
    record = (
        db.query(OTPStore)
        .filter(
            OTPStore.email       == req.email,
            OTPStore.otp         == req.otp,
            OTPStore.is_verified == True,
        )
        .first()
    )

    if not record:
        raise HTTPException(status_code=400, detail="Invalid or unverified OTP.")

    if datetime.utcnow() > record.expires_at:
        db.delete(record)
        db.commit()
        raise HTTPException(status_code=400, detail="OTP expired. Please start again.")

    if len(req.new_password) < 6:
        raise HTTPException(status_code=400, detail="Password must be at least 6 characters.")

    user = db.query(User).filter(User.email == req.email).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found.")

    user.hashed_password = hash_password(req.new_password)
    db.delete(record)
    db.commit()

    return {"message": "Password reset successful. Please log in."}