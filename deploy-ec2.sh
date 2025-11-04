#!/bin/bash
# deploy-ec2.sh
set -e

echo "🚀 Deploying LegiBit Kubernetes stack to EC2..."

# Ensure namespace exists
kubectl get ns legibit >/dev/null 2>&1 || kubectl apply -f k8s/namespace.yaml

# 1️⃣ Apply all manifests
kubectl apply -f k8s/configs/ -n legibit
#kubectl apply -f k8s/secrets/ -n legibit
kubectl apply -f k8s/deployments/ -n legibit
kubectl apply -f k8s/services/ -n legibit  # includes web-ingress.yaml

# 2️⃣ Wait for pods
echo "⏳ Waiting for pods to become ready..."
kubectl wait --for=condition=ready pod -l -all -n legibit --timeout=180s

# 3️⃣ Show ingress info
echo "🌍 Checking ingress public IP..."
kubectl get svc -n legibit
kubectl get ingress -n legibit

echo "✅ Deployment complete!"
echo "Once DNS is configured in Route 53, access your app at: https://legi-bit.com"
