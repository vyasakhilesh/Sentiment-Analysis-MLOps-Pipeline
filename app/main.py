# The main FastAPI application file containing API endpoints.
# app/main.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import joblib
from app.databases import SessionLocal
from app.model import SentimentRecord



# Model definition
class SentimentRequest(BaseModel):
    text: str

class SentimentResponse(BaseModel):
    sentiment: str
    confidence: float

# Initialize the app
app = FastAPI()

# Load ML model
model = joblib.load("model/sentiment_model.joblib")


@app.get("/")
def read_root():
    return {"message": "Hello World"}
    

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
