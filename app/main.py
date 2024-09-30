# app/main.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from sqlalchemy import create_engine, Column, Integer, String, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
import joblib

# Database setup
DATABASE_URL = "postgresql://user:password@localhost/sentiment_db"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Model definition
class SentimentRequest(BaseModel):
    text: str

class SentimentResponse(BaseModel):
    sentiment: str
    confidence: float

class SentimentRecord(Base):
    __tablename__ = "sentiment_records"
    id = Column(Integer, primary_key=True, index=True)
    text = Column(Text, nullable=False)
    sentiment = Column(String, nullable=False)
    confidence = Column(String, nullable=False)

# Initialize the app
app = FastAPI()

# Load ML model
model = joblib.load("model/sentiment_model.joblib")

# Create tables
Base.metadata.create_all(bind=engine)

@app.post("/predict", response_model=SentimentResponse)
def predict_sentiment(request: SentimentRequest):
    try:
        prediction = model.predict([request.text])[0]
        confidence = max(model.predict_proba([request.text])[0])
        # Save to DB
        db = SessionLocal()
        record = SentimentRecord(
            text=request.text,
            sentiment=prediction,
            confidence=str(confidence)
        )
        db.add(record)
        db.commit()
        db.refresh(record)
        db.close()
        return SentimentResponse(sentiment=prediction, confidence=confidence)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
