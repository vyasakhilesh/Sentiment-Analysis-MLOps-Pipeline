# scripts/build_push_docker.sh
# scripts/build_push_docker.sh: Builds Docker images and pushes them to AWS ECR.
#!/bin/bash

AWS_ACCOUNT_ID=<your_account_id>
REGION=us-west-2

# Authenticate Docker to ECR
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Build and push backend
docker build -f docker/Dockerfile.backend -t sentiment-backend ./app
docker tag sentiment-backend:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/sentiment-backend:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/sentiment-backend:latest

# Build and push worker
docker build -f docker/Dockerfile.worker -t sentiment-worker ./worker
docker tag sentiment-worker:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/sentiment-worker:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/sentiment-worker:latest

# Build and push model
docker build -f docker/Dockerfile.model -t sentiment-model ./model
docker tag sentiment-model:latest $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/sentiment-model:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/sentiment-model:latest