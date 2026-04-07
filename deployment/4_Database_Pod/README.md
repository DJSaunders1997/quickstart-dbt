# Option 4: Local Dagster + Shared Database Pod

## High-Level Concept

This deployment option solves the "shared asset and job history" problem by running Dagster locally while connecting to a shared PostgreSQL database pod in your Kubernetes cluster.

### How It Works

```
Local Development Machines          Kubernetes Cluster
┌─────────────────────────┐         ┌──────────────────┐
│ Developer 1             │         │                  │
│ ├── dagster dev ────────┼─────────┤                  │
│ ├── DuckDB (data)       │         │                  │
│ └── Fast local dev      │         │  PostgreSQL Pod  │
└─────────────────────────┘         │  ┌─────────────┐ │
                                    │  │ Asset History│ │
┌─────────────────────────┐         │  │ Job Runs    │ │
│ Developer 2             │         │  │ Metadata    │ │
│ ├── dagster dev ────────┼─────────┤  └─────────────┘ │
│ ├── DuckDB (data)       │         │                  │
│ └── Fast local dev      │         │ (Minimal        │
└─────────────────────────┘         │  Resources)     │
```

### What Gets Shared vs Local

**Shared in Cluster:**
- Dagster metadata (asset lineage, job runs, schedules)
- Historical execution data
- Asset catalog and relationships

**Stays Local:**  
- Actual data assets (DuckDB files)
- Code execution
- Development experience (`dagster dev`)

## Benefits

- ✅ **Solves the biggest problem**: Everyone sees the same asset history
- ✅ **Fast local development**: No change to developer experience  
- ✅ **Minimal cluster resources**: Just one small PostgreSQL pod
- ✅ **Easy to set up**: One command deployment
- ✅ **Easy to tear down**: Complete cleanup script

## Files

- `postgres-shared.yaml` - Kubernetes manifests for PostgreSQL deployment
- `dagster.yaml` - Dagster configuration for shared database
- `setup-shared-db.sh` - One-command setup script
- `cleanup-shared-db.sh` - Complete cleanup script

## Quick Start

From project root:

```bash
# First create k8s resources
./deployment/4_Database_Pod/shared-db-k8s-setup.sh

# Then set up local connectivity
./deployment/4_Database_Pod/shared-db-setup.sh

# Start Dagster with shared metadata
dagster dev
```

### Azure Resources

**AKS Cluster**: Your AKS cluster (accessible via Azure Portal)

### Environment Configuration

The setup script requires these Azure environment variables:

**Development (default):**
```bash
./deployment/4_Database_Pod/shared-db-k8s-setup.sh  # Create k8s resources
./deployment/4_Database_Pod/shared-db-setup.sh      # Set up connectivity
```

**Production (override with environment variables):**
```bash
export AZURE_SUBSCRIPTION_ID="your-subscription-id"
export AZURE_RESOURCE_GROUP="your-resource-group"
export AZURE_AKS_NAME="your-aks-cluster"  
./deployment/4_Database_Pod/shared-db-k8s-setup.sh  # Create k8s resources
./deployment/4_Database_Pod/shared-db-setup.sh      # Set up connectivity
```

Now all team members will see the same asset lineage and job execution history while maintaining fast local development.

## Verifying Shared Database

**Check in Dagster UI:**
1. Go to `http://127.0.0.1:3000/deployment/config`
2. Look for PostgreSQL storage configuration (no local file warnings)
3. All storage components should show: `postgresql://dagster_user:zzzzzz@localhost:5433/dagster`

**Expected configuration:**
```yaml
run_storage: PostgresRunStorage         # Shared job runs
event_log_storage: PostgresEventLogStorage  # Shared asset history  
schedule_storage: PostgresScheduleStorage   # Shared schedules
```

**Test shared functionality:**
- Materialize some assets in the UI
- Other team members with same setup will see your runs!

## User Attribution

Local `dagster dev` shows runs as "manually launched". 

**Add user tags to runs:**
```python
# In your asset/job code, add run tags
@asset(tags={"user": "dave"})
def my_asset():
    return data
```

**Or set via environment:**
```bash
export USER_NAME="dave"
uv run dagster dev
```
Then modify job definitions to include `tags={"user": os.getenv("USER_NAME", "unknown")}`.

**Or set via UI:** Add tags when manually launching runs in the web interface.

## Cleanup

```bash
./deployment/4_Database_Pod/shared-db-cleanup.sh
```