# Option 2: Manual Kubernetes Manifests

Deploy Dagster without Helm using direct Kubernetes manifests. This approach gives full control over the deployment while avoiding Helm security restrictions in production environments.

**All manifests are consolidated into a single well-documented `all-manifests.yaml` file for easy management and deployment.**

## Architecture

- PostgreSQL database for metadata storage 
- Dagster webserver for UI
- Dagster daemon for scheduling/sensors
- User code deployment for custom assets
- All components manually configured via YAML

## Quick Start

```bash
# Deploy all components with one command
./deploy.sh

# Alternative: Direct kubectl apply
kubectl apply -f all-manifests.yaml

# Access Dagster UI
./access.sh

# Clean up everything  
./cleanup.sh
```

## Files

- `all-manifests.yaml` - Comprehensive single file with all Kubernetes manifests
- `Dockerfile` - Builds your dbt+Python code into deployable image
- `deploy.sh` - One-command deployment script
- `access.sh` - Port-forward to access UI
- `cleanup.sh` - Clean removal script

## Components in all-manifests.yaml

- Namespace and RBAC setup
- PostgreSQL database and service
- Dagster configuration (storage, launcher, etc.)
- Dagster webserver deployment and service
- Dagster daemon for background processing
- User code deployment with GRPC server

## Advantages

- **Single file deployment** - All manifests consolidated with clear documentation
- **No Helm dependency** - Perfect for production environments with Helm restrictions  
- **Full control** - Every manifest explicitly defined and customizable
- **Easy audit** - Single file review process for security compliance
- **Production-ready** - Proper RBAC, health checks, resource limits
- **Direct Kubernetes** - Native resource management without abstractions

**Docs**: [Dagster Kubernetes Guide](https://docs.dagster.io/deployment/guides/kubernetes/deploying-with-helm)