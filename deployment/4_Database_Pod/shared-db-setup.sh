#!/bin/bash

# Main setup script for Dagster shared database (Option 4)
# Sets up local connectivity to existing PostgreSQL pod in k8s cluster

set -e

echo "🚀 Setting up Dagster shared database connectivity..."

# Check if port-forward is already running
if pgrep -f "kubectl.*port-forward.*postgres" > /dev/null; then
    echo "⚠️  Port forward already running, killing existing process..."
    pkill -f "kubectl.*port-forward.*postgres"
    sleep 2
fi

# Start port forwarding in background
echo "🔗 Setting up port forwarding (localhost:5433 -> postgres:5432)..."
kubectl port-forward -n dagster-dev service/postgres-service 5433:5432 &

# Store the port-forward PID for later cleanup
echo $! > .port-forward-pid

# Wait a moment for port forward to establish
sleep 3

# Test connection
echo "🔍 Testing database connection..."
if command -v psql &> /dev/null; then
    export PGPASSWORD=zzzzzz
    if psql -h localhost -p 5433 -U dagster_user -d dagster -c "SELECT 1;" &> /dev/null; then
        echo "✅ Database connection successful!"
    else
        echo "❌ Database connection failed"
        exit 1
    fi
else
    echo "⚠️  psql not found, skipping connection test"
fi

# Copy dagster config to project root
echo "📋 Setting up Dagster configuration..."
mkdir -p .dagster
cp "$(dirname "$0")/dagster.yaml" ./.dagster/dagster.yaml

echo "🎉 Setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Port forwarding is active: localhost:5433 -> postgres:5432"
echo "2. Database credentials:"
echo "   - Host: localhost:5433"
echo "   - Database: dagster"
echo "   - User: dagster_user"
echo "   - Password: zzzzzz"
echo "3. Run 'uv run dagster dev' to start with shared database"
echo "4. Use './deployment/4_Database_Pod/shared-db-cleanup.sh' to stop port forwarding"
echo ""
echo "💡 Prerequisites: Run './deployment/4_Database_Pod/shared-db-k8s-setup.sh' first to create k8s resources"
echo ""
echo "💡 For production: export environment variables before running script"
echo "🔗 To manually port-forward: kubectl port-forward -n dagster-dev service/postgres-service 5433:5432"