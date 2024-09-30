# locustfile.py
from locust import HttpUser, task, between

class SentimentUser(HttpUser):
    wait_time = between(1, 5)

    @task
    def predict_sentiment(self):
        self.client.post("/predict", json={"text": "I love this product!"})
