FROM mcr.microsoft.com/playwright/python:v1.58.0-noble

# Install curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install uv globally
ENV UV_INSTALL_DIR="/usr/local/bin"
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Ensure uv is on the PATH
ENV PATH="/usr/local/bin:$PATH"

# Install playwright into the system python using uv and then install the browser
RUN uv pip install --system playwright && playwright install webkit

# Set the browsers path to a shared location
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
