#!/bin/bash
set -e

echo "🚀 Setting up Dagster Single Pod deployment..."

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "❌ kubectl is required but not installed"
    exit 1
fi

# Check kubectl connection
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ No kubernetes cluster connection. Ensure you're connected to your cluster"
    exit 1
fi

echo "✅ Kubernetes connection verified"

# Apply the Kubernetes manifests
echo "📦 Creating Kubernetes resources..."
kubectl apply -f "$(dirname "$0")/dagster-single-pod.yaml"

# Wait for deployment to be ready
echo "⏳ Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/dagster-single-pod -n dagster-single

# Copy application code to the pod
echo "📁 Copying application code to pod..."
POD_NAME=$(kubectl get pods -n dagster-single -l app=dagster-single-pod -o jsonpath="{.items[0].metadata.name}")

# Copy your project code
echo "Copying project files..."
kubectl exec -n dagster-single $POD_NAME -- mkdir -p /opt/dagster/app

# Copy main project files
tar czf - -C "$(dirname "$0")/../.." \
  assets_dbt_python \
  dbt_project \
  pyproject.toml \
  --exclude='*.egg-info' \
  --exclude='__pycache__' \
  --exclude='.venv' \
  --exclude='target' \
  --exclude='logs' \
  | kubectl exec -n dagster-single $POD_NAME -i -- tar xzf - -C /opt/dagster/app

echo "🔄 Restarting pod to reload code..."
kubectl delete pod $POD_NAME -n dagster-single
kubectl wait --for=condition=ready pod -l app=dagster-single-pod -n dagster-single --timeout=300s

echo "✅ Single pod deployment complete!"
echo ""
echo "🌐 Access Dagster UI:"
echo "   kubectl port-forward -n dagster-single service/dagster-webserver 3000:3000"
echo ""
echo "Then visit: http://localhost:3000"