FROM mcr.microsoft.com/playwright/python:v1.58.0-noble

# Install curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install uv globally and make it accessible to all users
ENV UV_INSTALL_DIR="/usr/local/bin"
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Ensure uv is on the PATH for all users
ENV PATH="/usr/local/bin:$PATH"

# Pre-install playwright browser binaries into a shared location
# This prevents each build from having to download them again
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
RUN playwright install webkit
