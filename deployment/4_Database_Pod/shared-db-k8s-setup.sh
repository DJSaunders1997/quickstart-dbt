#!/bin/bash

# Kubernetes setup script for Dagster shared database
# Deploys PostgreSQL resources to k8s cluster

set -e

# Configuration - MUST be provided via environment variables
AZURE_SUBSCRIPTION_ID=${AZURE_SUBSCRIPTION_ID:?"❌ AZURE_SUBSCRIPTION_ID environment variable is required"}
AZURE_RESOURCE_GROUP=${AZURE_RESOURCE_GROUP:?"❌ AZURE_RESOURCE_GROUP environment variable is required"}
AZURE_AKS_NAME=${AZURE_AKS_NAME:?"❌ AZURE_AKS_NAME environment variable is required"}

echo "📦 Setting up PostgreSQL in Kubernetes cluster..."

# Configure Azure and get AKS credentials
echo "☁️  Configuring Azure connection..."
echo "   - Subscription: $AZURE_SUBSCRIPTION_ID"
echo "   - Resource Group: $AZURE_RESOURCE_GROUP"
echo "   - AKS Cluster: $AZURE_AKS_NAME"

az account set --subscription "$AZURE_SUBSCRIPTION_ID"
az aks get-credentials --resource-group "$AZURE_RESOURCE_GROUP" --name "$AZURE_AKS_NAME" --overwrite-existing

# Deploy PostgreSQL to cluster
echo "📦 Deploying PostgreSQL pod to cluster..."
kubectl apply -f "$(dirname "$0")/postgres-shared.yaml"

# Wait for pod to be ready
echo "⏳ Waiting for PostgreSQL pod to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n dagster-dev --timeout=300s

echo "✅ PostgreSQL pod is ready in dagster-dev namespace"