# Manages database connections and session creation
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine


# Database setup
DATABASE_URL = "postgresql://user:password@localhost/sentiment_db"
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)