#!/bin/bash

set -e

echo "🌐 Accessing Dagster UI..."

# Check if service exists
if ! kubectl get service dagster-webserver -n dagster >/dev/null 2>&1; then
    echo "❌ Dagster webserver service not found. Run ./deploy.sh first."
    exit 1
fi

# Port forward to Dagster UI
echo "🔗 Port forwarding to http://localhost:3000"
echo "Press Ctrl+C to stop"
echo ""

kubectl port-forward service/dagster-webserver 3000:3000 -n dagster