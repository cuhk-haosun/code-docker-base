FROM debian:latest

LABEL maintainer="Xing Zhao"

EXPOSE 22

WORKDIR /root

# Avoid interactive installation prompts
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

# --------------------------------------------------
# 1. Update system and install essential tools
# --------------------------------------------------
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        gnupg \
        jq \
        nano \
        mc \
        fail2ban \
        openssh-server \
        sshfs \
        git \
        apt-utils \
        bc \
        unzip \
        zip \
        xz-utils \
        procps \
        less \
        file \
        bash-completion \
        && \
    rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# 2. Programming languages and development tools
# --------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        python3-venv \
        python3-dev \
        build-essential \
        pkg-config \
        r-base \
        r-base-dev \
        perl \
        openjdk-25-jdk \
        && \
    rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# 3. Bioinformatics tools
# --------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        samtools \
        bedtools \
        && \
    rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# 4. WebDAV and filesystem utilities
# --------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        davfs2 \
        fuse3 \
        && \
    rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# 5. Install Docker CLI
# --------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        docker.io && \
    rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# 6. Install latest rclone (AMD64 only)
# --------------------------------------------------
RUN set -eux; \
    RCLONE_URL="https://downloads.rclone.org/rclone-current-linux-amd64.deb"; \
    curl -fL --retry 5 --retry-all-errors \
        "$RCLONE_URL" -o /tmp/rclone.deb; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        /tmp/rclone.deb; \
    rm -f /tmp/rclone.deb; \
    rm -rf /var/lib/apt/lists/*; \
    rclone version


CMD ["/bin/bash"]
