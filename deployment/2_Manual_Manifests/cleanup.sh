#!/bin/bash

set -e

echo "🧹 Cleaning up Dagster deployment..."

# Delete all resources using the manifest file
echo "🗑️ Removing all Dagster resources..."
kubectl delete -f all-manifests.yaml --ignore-not-found=true

# Remove Docker image
echo "🔥 Removing Docker image..."
docker rmi dagster-demo:latest || true

echo "✅ Cleanup completed!"