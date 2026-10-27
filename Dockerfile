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
    && rm -rf /var/lib/apt/lists/*

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
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# 3. Node.js 24 LTS for Gitea Actions
# Required by JavaScript actions such as checkout
# --------------------------------------------------
RUN set -eux; \
    curl -fsSL \
        https://deb.nodesource.com/setup_24.x \
        -o /tmp/nodesource_setup.sh; \
    bash /tmp/nodesource_setup.sh; \
    apt-get install -y --no-install-recommends nodejs; \
    rm -f /tmp/nodesource_setup.sh; \
    rm -rf /var/lib/apt/lists/*; \
    command -v node; \
    node --version; \
    npm --version

# --------------------------------------------------
# 4. Bioinformatics tools
# --------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        samtools \
        bedtools \
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# 5. WebDAV and filesystem utilities
# --------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        davfs2 \
        fuse3 \
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# 6. Install Docker CLI
# --------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        docker.io \
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# 7. Install latest stable rclone from GitHub
# Automatically detects CPU architecture
# --------------------------------------------------
RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "$ARCH" in \
        amd64|arm64) ;; \
        *) echo "Unsupported rclone architecture: $ARCH"; exit 1 ;; \
    esac; \
    RELEASE_JSON="$(curl -fsSL \
        https://api.github.com/repos/rclone/rclone/releases/latest)"; \
    RCLONE_URL="$(printf '%s' "$RELEASE_JSON" | \
        jq -r --arg arch "$ARCH" \
        '.assets[] | select(.name | endswith("-linux-" + $arch + ".deb")) | .browser_download_url')"; \
    test -n "$RCLONE_URL"; \
    curl -fL "$RCLONE_URL" -o /tmp/rclone.deb; \
    apt-get update; \
    apt-get install -y --no-install-recommends /tmp/rclone.deb; \
    rm -f /tmp/rclone.deb; \
    rm -rf /var/lib/apt/lists/*; \
    rclone version

CMD ["/bin/bash"]
