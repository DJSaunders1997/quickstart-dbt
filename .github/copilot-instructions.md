# Dagster + dbt Project Instructions

## Architecture Overview

This is a **hybrid Dagster + dbt data pipeline** using DuckDB as the backend. The project demonstrates integrating Python assets with dbt transformations in a single orchestrated workflow.

**Key Architecture Pattern:**
- `assets_dbt_python/assets/raw_data/` - Python assets that generate source data
- `dbt_project/models/` - dbt models that transform the raw data
- `assets_dbt_python/assets/forecasting/` - Python ML assets that consume dbt outputs

**Data Flow:** Python raw data → dbt transformations → Python ML forecasting

## Critical Configuration

- **Database:** Single DuckDB file at `dbt_project/example.duckdb`
- **Key Prefix Pattern:** All assets use database + schema prefixes (`["duckdb", "schema_name"]`)
- **dbt Integration:** Uses `dagster-dbt` with CLI resource pointing to `dbt_project/`
- **IO Manager:** `duckdb_pandas_io_manager` enables loading dbt models as pandas DataFrames

## Development Workflows

**Local Development:**
```bash
pip install -e ".[dev]"  # Install in editable mode
dagit                     # Start UI at localhost:3000
```

**Key Jobs:**
- `everything_everywhere_job` - Full pipeline refresh
- `refresh_forecast_model_job` - Daily ML model updates

**Asset Dependencies:**
- dbt sources reference Python assets via `source('raw_data', 'orders')`
- Python forecasting assets consume dbt outputs using `AssetIn(key_prefix=["duckdb", "dbt_schema"])`

## Project-Specific Patterns

**Asset Organization:**
- Group related assets using `group_name` parameter
- Use `key_prefix` consistently: `["duckdb", schema_name]`
- dbt assets auto-prefixed with `["duckdb", "dbt_schema"]`

**Resource Management:**
- Model artifacts use `fs_io_manager` for pickle serialization
- All tabular data uses `duckdb_pandas_io_manager`
- dbt CLI resource configured with project + profiles directories

**Testing Strategy:**
- dbt tests in `dbt_project/models/*/schema.yml`
- Python asset tests in `assets_dbt_python_tests/`
- Use `compute_kind` for asset categorization (`"random"`, `"ml_tool"`)

## File Structure Conventions

**Never modify:**
- `dbt_project/example.duckdb` - Generated database file
- `*/__pycache__/` directories
- `*.egg-info/` build artifacts

**Key Integration Files:**
- `assets_dbt_python/__init__.py` - Main Definitions with all asset loading
- `dbt_project/config/profiles.yml` - Database connection config
- `dbt_project/models/sources.yml` - Python asset references

When adding new assets, follow the existing key_prefix patterns and ensure proper integration between Python assets and dbt sources/refs.