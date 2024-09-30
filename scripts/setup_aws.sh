# scripts/setup_aws.sh
# scripts/setup_aws.sh: Automates the setup of AWS resources (EKS cluster, S3 buckets, RDS, etc.).
#!/bin/bash

# Create EKS Cluster
eksctl create cluster --name sentiment-cluster --version 1.21 --region us-west-2 --nodegroup-name linux-nodes --node-type t3.medium --nodes 3 --nodes-min 1 --nodes-max 4 --managed

# Create S3 Bucket
aws s3 mb s3://sentiment-model-artifacts --region us-west-2

# Create RDS PostgreSQL Instance
aws rds create-db-instance \
    --db-instance-identifier sentiment-db \
    --db-instance-class db.t3.medium \
    --engine postgres \
    --allocated-storage 20 \
    --master-username user \
    --master-user-password password \
    --vpc-security-group-ids sg-xxxxxxxx \
    --region us-west-2
