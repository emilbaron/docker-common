FROM mcr.microsoft.com/playwright/python:v1.58.0-noble

ARG DEBIAN_FRONTEND=noninteractive
ARG TARGETARCH
ARG TSDUCK_VERSION=3.43-4549

ENV UV_INSTALL_DIR="/usr/local/bin"
ENV PATH="/usr/local/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PLAYWRIGHT_BROWSERS_PATH=/ms-playwright

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        ffmpeg \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

RUN set -eux; \
    case "${TARGETARCH:-amd64}" in \
      amd64) tsduck_arch="amd64" ;; \
      arm64) tsduck_arch="arm64" ;; \
      *) echo "Unsupported TARGETARCH: ${TARGETARCH}"; exit 1 ;; \
    esac; \
    curl -fsSLo /tmp/tsduck.deb "https://github.com/tsduck/tsduck/releases/download/v${TSDUCK_VERSION}/tsduck_${TSDUCK_VERSION}.ubuntu24_${tsduck_arch}.deb" \
    && apt-get update \
    && apt-get install -y --no-install-recommends /tmp/tsduck.deb \
    && rm -f /tmp/tsduck.deb \
    && rm -rf /var/lib/apt/lists/*

RUN uv pip install --system playwright \
    && playwright install

COPY pyproject.toml README.md /app/
COPY src /app/src

RUN uv pip install --system .

RUN tsp --version

CMD ["python3", "-m", "app"]
