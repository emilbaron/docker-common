FROM mcr.microsoft.com/playwright/python:v1.58.0-noble

# Install curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install uv globally
ENV UV_INSTALL_DIR="/usr/local/bin"
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Ensure both uv and standard paths are available
ENV PATH="/usr/local/bin:$PATH"

# Pre-install playwright browser binaries into a shared location
# Use python3 -m playwright to ensure we use the installed module
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright
RUN python3 -m playwright install webkit
