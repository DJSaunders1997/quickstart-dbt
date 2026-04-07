# Dagster Deployment Options

Testing different ways to deploy Dagster for dev and production environments.

## Options to Explore

### 1. Official Helm deployment ✅
- Standard k8s deployment using Dagster's official helm charts
- **Concerns**: Can't run helm in prod due to security issues, lots of dagster pods running on prod cluster
- **Implementation**: [1_Official_Helm/](1_Official_Helm/)

### 2. No-helm alternative ✅ 
- Deploy without helm using manual k8s manifests
- All the dagster components deployed manually
- **Implementation**: [2_Manual_Manifests/](2_Manual_Manifests/)

### 3. Single pod alternative ✅
- Can all dagster services (UI, database, job runs) run on same pod?
- Would be nice easy demo to show
- **Implementation**: [3_Single_Pod/](3_Single_Pod/)

### 4. Local dev + shared database ✅
- Run everything locally with `dagster dev` 
- Make database pod on cluster so all users can see asset history and job run history
- **This solves our biggest stumbling block currently**
- **Implementation**: [4_Database_Pod/](4_Database_Pod/)

## Plan
Deploy each to dev environment first, then evaluate for production.

## 🎯 [**Detailed Comparison & Recommendations →**](DEPLOYMENT_COMPARISON.md)

**Quick Start:** Begin with Option 4 (Local + DB) to solve immediate shared visibility needs, then plan production deployment with Option 1 (Helm) or Option 2 (Manual Manifests).