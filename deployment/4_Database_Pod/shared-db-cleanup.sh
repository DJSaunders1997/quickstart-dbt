#!/bin/bash

# Cleanup script for Dagster shared database setup

echo "🧹 Cleaning up port forwarding..."

# Kill port forward if running
if [ -f .port-forward-pid ]; then
    PID=$(cat .port-forward-pid)
    if ps -p $PID > /dev/null; then
        echo "🔌 Stopping port forward (PID: $PID)..."
        kill $PID
    fi
    rm .port-forward-pid
fi

# Kill any remaining port forwards
if pgrep -f "kubectl.*port-forward.*postgres" > /dev/null; then
    echo "🔌 Cleaning up any remaining port forwards..."
    pkill -f "kubectl.*port-forward.*postgres"
fi

echo "🎉 Cleanup complete!"
echo "💡 PostgreSQL pod and dagster.yaml left in place for continued use"
echo "💡 To remove PostgreSQL: kubectl delete -f deployment/4_Database_Pod/postgres-shared.yaml"