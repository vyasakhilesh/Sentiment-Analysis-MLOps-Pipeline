Application Backend (app/)
app/init.py: Makes the app directory a Python package.
app/main.py: The main FastAPI application file containing API endpoints.
app/models.py: Defines SQLAlchemy ORM models for the PostgreSQL database.
app/database.py: Manages database connections and session creation.
app/schemas.py: Defines Pydantic models for request and response validation.
app/utils.py: Contains utility functions (e.g., model loading, preprocessing).
app/requirements.txt: Lists Python dependencies specific to the backend application.