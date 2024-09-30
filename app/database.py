# Manages database connections and session creation
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
import os


# Database setup
# DATABASE_URL = "postgresql://user:password@localhost/sentiment_db"
database_url = os.environ.get('DATABASE_URL')
engine = create_engine(database_url)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()
# Create tables
Base.metadata.create_all(bind=engine)