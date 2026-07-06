from sqlalchemy import Column, String, Text, Boolean, Date, DateTime, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from datetime import datetime, timezone
import uuid
from app.database import Base

class JobApplication(Base):
    __tablename__ = "job_applications"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    user_id = Column(UUID(as_uuid=True), ForeignKey("users.id", ondelete="CASCADE"))
    company = Column(String(255), nullable=False)
    role_title = Column(String(255), nullable=False)
    status = Column(String(50), default="WISHLIST")
    job_url = Column(Text)
    notes = Column(Text)
    location = Column(String(255))
    is_remote = Column(Boolean, default=False)
    applied_date = Column(Date)
    created_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
    updated_at = Column(DateTime(timezone=True), default=lambda: datetime.now(timezone.utc))
