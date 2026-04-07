# Option 1: Official Helm Deployment

Production-ready Dagster deployment using official Helm charts.

## Reference
- [Dagster Kubernetes Deployment Guide](https://docs.dagster.io/deployment/guides/kubernetes/deploying-with-helm) 

## What You Get
- Separate pods for webserver, daemon, workers
- PostgreSQL database for metadata
- User code deployments
- Auto-scaling and production features

## Quick Start
```bash
# 1. Setup
./helm-setup.sh

# 2. Access UI  
./helm-access.sh

# 3. Cleanup when done
./helm-cleanup.sh
```

## Notes
- Requires Helm installed
- Creates multiple pods (production pattern)
- Used PostgreSQL for shared metadata
- Image needs to be built/pushed to registry for user code

## Next Steps
1. Build and push your app image to a registry
2. Update `values.yaml` with your image details
3. Consider security, monitoring, backup strategies