FROM mcr.microsoft.com/playwright/python:v1.56.0-noble

ARG TSDUCK_VERSION=3.43-4549

# Original:
RUN apt update && \
    apt install -y \ 
    iproute2 \
    jq \
    ffmpeg \
    curl \
    wget && \
    mkdir -p /etc/apt/keyrings && \
    curl -sL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_22.x nodistro main" >> /etc/apt/sources.list.d/nodesource.list && \
    apt update && \
    apt install nodejs


RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates

RUN apt install -y libsrt1.5-openssl libpcsclite1

# # Original:
ADD https://astral.sh/uv/install.sh /uv-installer.sh
RUN sh /uv-installer.sh && rm /uv-installer.sh
ENV PATH="/root/.local/bin/:$PATH"


# Original TSDuck for Noble:
RUN curl -Lo /tmp/tsduck.deb \
    "https://github.com/tsduck/tsduck/releases/download/v${TSDUCK_VERSION}/tsduck_${TSDUCK_VERSION}.ubuntu24_amd64.deb" \
    && apt-get update \
    && apt-get install -y /tmp/tsduck.deb \
    && rm -rf /tmp/tsduck.deb

#RUN apt-get update && apt-get install -y /tmp/tsduck.deb

# Delete tsduck .deb file
#RUN rm -rf /tmp/tsduck.deb

# Remove apt-lists:
RUN rm -rf /var/lib/apt/lists*
