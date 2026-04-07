#!/bin/bash
# Access script for Official Helm Dagster deployment

echo "Starting port-forward to Dagster UI..."
echo "UI will be available at: http://localhost:3000"
echo "Press Ctrl+C to stop"
echo ""

kubectl port-forward svc/dagster-webserver 3000:80 -n dagster-helm