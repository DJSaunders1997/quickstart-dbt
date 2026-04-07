#!/bin/bash
set -e

echo "🔗 Setting up access to Dagster Single Pod..."

# Check if the deployment exists
if ! kubectl get deployment dagster-single-pod -n dagster-single &> /dev/null; then
    echo "❌ Single pod deployment not found. Run single-pod-setup.sh first."
    exit 1
fi

# Check if deployment is ready
if ! kubectl wait --for=condition=available --timeout=30s deployment/dagster-single-pod -n dagster-single &> /dev/null; then
    echo "⚠️ Deployment not ready, but continuing..."
fi

echo "📡 Starting port forward to Dagster UI..."
echo "   Dagster UI will be available at: http://localhost:3000"
echo ""
echo "💡 To stop port forwarding, press Ctrl+C"
echo ""

# Start port forward to webserver  
kubectl port-forward -n dagster-single service/dagster-webserver 3000:3000