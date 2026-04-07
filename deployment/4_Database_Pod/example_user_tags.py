# Example: Add to your assets_dbt_python/__init__.py

import os
import getpass

# Add user info to all jobs
user_tags = {"user": os.getenv("USER_NAME", getpass.getuser())}

# Update your job definitions
everything_job = define_asset_job(
    "everything_everywhere_job", 
    selection="*",
    tags=user_tags
)

forecast_job = define_asset_job(
    "refresh_forecast_model_job", 
    selection="*order_forecast_model",
    tags=user_tags
)