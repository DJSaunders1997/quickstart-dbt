# Dagster Single Pod Deployment (Option 3)

Complete Dagster deployment in a single Kubernetes pod - perfect for demos and simple deployments.

## What This Includes

- **Single Pod**: Dagster webserver, daemon, and SQLite database all in one pod
- **Persistent Storage**: Data persists across pod restarts 
- **Easy Demo**: Simple one-command deployment and access

## Quick Start

1. **Deploy the single pod:**
   ```bash
   ./single-pod-setup.sh
   ```

2. **Access Dagster UI:**
   ```bash
   ./single-pod-access.sh
   ```
   Then visit: http://localhost:3000

3. **Clean up when done:**
   ```bash
   ./single-pod-cleanup.sh
   ```

## How It Works

- **Pod Contents**: Single pod runs Dagster webserver + daemon + SQLite
- **Storage**: Uses SQLite database on persistent volume
- **Code Deployment**: Your project code is copied into the pod during setup
- **Access**: Port forward exposes Dagster UI at localhost:3000

## Pros & Cons

**✅ Pros:**
- Extremely simple deployment
- Great for demos and testing
- No external dependencies
- Self-contained

**⚠️ Cons:**
- Single point of failure
- Limited scalability
- SQLite performance limitations
- Pod restarts require re-copying code

## Troubleshooting

**Pod not starting:**
```bash
kubectl logs -f deployment/dagster-single-pod -n dagster-single
```

**Check deployment status:**
```bash
kubectl get pods -n dagster-single
kubectl describe pod -l app=dagster-single-pod -n dagster-single
```

**Copy new code:**
```bash
# After making code changes, re-run setup to update the pod
./single-pod-setup.sh
```

**Port forward not working:**
```bash
# Check if service exists
kubectl get service -n dagster-single

# Try direct pod port forward
POD=$(kubectl get pods -n dagster-single -l app=dagster-single-pod -o name)
kubectl port-forward -n dagster-single $POD 3000:3000
```