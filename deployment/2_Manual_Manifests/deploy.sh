#!/bin/bash

set -e

echo "🚀 Deploying Dagster with Manual Manifests..."

# Build Docker image
echo "📦 Building user code image..."
docker build -t dagster-demo:latest -f Dockerfile ../../

# Apply all manifests at once
echo "🚀 Applying all Dagster manifests..."
kubectl apply -f all-manifests.yaml

# Wait for deployments
echo "⏳ Waiting for deployments..."
kubectl wait --for=condition=available --timeout=300s deployment/postgres -n dagster
kubectl wait --for=condition=available --timeout=300s deployment/dagster-usercode -n dagster
kubectl wait --for=condition=available --timeout=300s deployment/dagster-webserver -n dagster
kubectl wait --for=condition=available --timeout=300s deployment/dagster-daemon -n dagster

echo "✅ Dagster deployed successfully!"
echo ""
echo "Next steps:"
echo "  ./access.sh     # Access the UI"
echo "  ./cleanup.sh    # Remove deployment"