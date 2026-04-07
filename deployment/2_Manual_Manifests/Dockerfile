FROM python:3.12-slim

WORKDIR /opt/dagster/app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy and install Python dependencies
COPY pyproject.toml .
RUN pip install -e .

# Copy application code
COPY assets_dbt_python/ ./assets_dbt_python/
COPY dbt_project/ ./dbt_project/

# Set environment
ENV DAGSTER_HOME=/opt/dagster/dagster_home
ENV PYTHONPATH=/opt/dagster/app

# Create necessary directories
RUN mkdir -p $DAGSTER_HOME

EXPOSE 4000

CMD ["dagster", "api", "grpc", "-h", "0.0.0.0", "-p", "4000", "-m", "assets_dbt_python"]