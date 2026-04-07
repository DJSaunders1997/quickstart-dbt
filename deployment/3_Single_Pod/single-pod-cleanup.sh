#!/bin/bash
set -e

echo "🧹 Cleaning up Dagster Single Pod deployment..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is required but not installed"
    exit 1
fi

# Check if resources exist before trying to delete
if kubectl get namespace dagster-single &> /dev/null; then
    echo "🗑️ Deleting Kubernetes resources..."
    
    # Delete the deployment first (faster than waiting for namespace deletion)
    kubectl delete deployment dagster-single-pod -n dagster-single --ignore-not-found=true
    kubectl delete service dagster-webserver -n dagster-single --ignore-not-found=true
    kubectl delete pvc dagster-data -n dagster-single --ignore-not-found=true
    kubectl delete configmap dagster-config -n dagster-single --ignore-not-found=true
    
    # Delete the namespace (will clean up any remaining resources)
    kubectl delete namespace dagster-single --ignore-not-found=true
    
    echo "✅ Cleanup complete!"
else
    echo "ℹ️ No single pod deployment found to clean up"
fi

echo ""
echo "🔍 Verify cleanup with:"
echo "   kubectl get pods -n dagster-single"