# scripts/deploy.sh
# scripts/deploy.sh: Automates deployment steps (applying Kubernetes configs, etc.).
#!/bin/bash

# Apply Kubernetes configurations
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml
kubectl apply -f k8s/ingress.yaml
