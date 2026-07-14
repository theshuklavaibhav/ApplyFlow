from sqlalchemy import Column, String, DateTime, Boolean
from sqlalchemy.sql import func
from app.database import Base

class OTPStore(Base):
    __tablename__ = "otp_store"

    email       = Column(String, primary_key=True, index=True)
    otp         = Column(String(6), nullable=False)
    expires_at  = Column(DateTime, nullable=False)
    is_verified = Column(Boolean, default=False)
    created_at  = Column(DateTime, server_default=func.now())