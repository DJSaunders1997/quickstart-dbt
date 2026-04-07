#!/bin/bash
# Cleanup script for Official Helm Dagster deployment

echo "Cleaning up Dagster Helm deployment..."

# Uninstall Helm release
helm uninstall dagster -n dagster-helm

# Delete namespace (this removes PVCs too)
kubectl delete namespace dagster-helm

echo ""
echo "✅ Cleanup complete!"