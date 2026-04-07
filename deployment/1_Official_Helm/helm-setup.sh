#!/bin/bash
# Setup script for Official Helm Dagster deployment

set -e

echo "Setting up Dagster via Official Helm Chart..."

# Add Dagster Helm repo
helm repo add dagster https://dagster-io.github.io/helm
helm repo update

# Create namespace
kubectl create namespace dagster-helm --dry-run=client -o yaml | kubectl apply -f -

# Install Dagster
helm install dagster dagster/dagster \
  --namespace dagster-helm \
  --values values.yaml

echo ""
echo "✅ Dagster Helm deployment started!"
echo ""
echo "Check status with:"
echo "  kubectl get pods -n dagster-helm"
echo ""
echo "Run './helm-access.sh' to access the UI"