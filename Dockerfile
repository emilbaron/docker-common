FROM mcr.microsoft.com/playwright/python:v1.58.0-noble

# Install curl (required for uv installer)
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install uv
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Ensure uv is on the PATH
ENV PATH="/root/.local/bin:$PATH"
