# Dockerfile for user code deployment
FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && apt-get install -y git && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /opt/dagster/app

# Copy requirements and install dependencies
COPY pyproject.toml .
RUN pip install -e .

# Copy application code
COPY . .

# Expose GRPC port
EXPOSE 3030

# Command to run user code server
CMD ["dagster", "api", "grpc", "--python-file", "/opt/dagster/app/assets_dbt_python/__init__.py", "--host", "0.0.0.0", "--port", "3030"]