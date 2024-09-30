# Defines SQLAlchemy ORM models for the PostgreSQL database
from sqlalchemy import Column, Integer, String, Text
from app.database import Base

class SentimentRecord(Base):
    __tablename__ = "sentiment_records"
    id = Column(Integer, primary_key=True, index=True)
    text = Column(Text, nullable=False)
    sentiment = Column(String, nullable=False)
    confidence = Column(String, nullable=False)
