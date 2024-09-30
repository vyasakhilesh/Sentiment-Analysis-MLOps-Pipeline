# Exporting the Model with TorchServe
# Create a model archive
torch-model-archiver --model-name sentiment_model \
    --version 1.0 \
    --serialized-file model/pytorch_model.bin \
    --handler transformers_handler.py \
    --extra-files "model/config.json,model/tokenizer.json,model/tokenizer_config.json,model/vocab.txt"

# Serve the model
torchserve --start --ncs --model-store model_store --models sentiment_model=sentiment_model.mar


# Use eksctl for simplified cluster creation
# Install eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

# Create EKS cluster
eksctl create cluster --name sentiment-cluster --version 1.21 --region us-west-2 --nodegroup-name linux-nodes --node-type t3.medium --nodes 3 --nodes-min 1 --nodes-max 4 --managed

# Store model artifacts and data
aws s3 mb s3://sentiment-model-artifacts


# Authenticate Docker to ECR
aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-west-2.amazonaws.com

# Create ECR repository
aws ecr create-repository --repository-name sentiment-backend

# Build Docker image
docker build -t sentiment-backend .

# Tag the image
docker tag sentiment-backend:latest <aws_account_id>.dkr.ecr.us-west-2.amazonaws.com/sentiment-backend:latest

# Push the image
docker push <aws_account_id>.dkr.ecr.us-west-2.amazonaws.com/sentiment-backend:latest

# Applying Kubernetes Configurations
kubectl apply -f k8s/deployment.yaml


#  Example: Create an alarm for high CPU usage
aws cloudwatch put-metric-alarm --alarm-name HighCPUUsage \
    --metric-name CPUUtilization --namespace AWS/EC2 \
    --statistic Average --period 300 --threshold 80 \
    --comparison-operator GreaterThanThreshold \
    --dimensions Name=InstanceId,Value=i-1234567890abcdef0 \
    --evaluation-periods 2 --alarm-actions <sns_topic_arn> \
    --unit Percent

# Use Helm to install Prometheus.
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus

# Grafana Setup:
helm install grafana grafana/grafana

# Apply the HPA configuration:
kubectl apply -f k8s/hpa.yaml

# Apply the Run Locust
locust -f locustfile.py --host=http://<load_balancer_url>



