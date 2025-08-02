FROM ubuntu:22.04

# Build arguments
ARG WORKSPACE=workspace

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Set up locale
RUN apt-get update && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8 && \
    apt-get clean

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Update system and install essential toolset for Claude Code
RUN echo "🔄 Updating package lists and system..." && \
    apt-get update && \
    echo "🔒 Installing security updates..." && \
    apt-get upgrade -y && \
    echo "📦 Installing essential tools for Claude Code development..." && \
    apt-get install -y --no-install-recommends \
    # Core utilities
    curl wget git vim nano tree less htop \
    # System info and file manager
    neofetch mc \
    # Build tools  
    build-essential make cmake \
    # Complete Python stack
    python3 python3-pip python3-venv python3-dev python3-setuptools python3-wheel \
    # Network and TCP/IP tools
    netcat-openbsd telnet traceroute dnsutils \
    nmap tcpdump wireshark-common \
    iptables net-tools iproute2 \
    ssh openssh-client \
    iputils-ping \
    # System tools
    lsof procps psmisc \
    # Archive and compression
    unzip zip tar gzip bzip2 xz-utils \
    # Text processing
    jq grep sed gawk \
    # Additional utilities
    bc file rsync screen tmux \
    # Package management
    software-properties-common apt-transport-https ca-certificates \
    && echo "🧹 Cleaning up package cache..." && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Node.js 18+ (required for Claude Code)
RUN echo "⚡ Installing Node.js 18+ for Claude Code..." && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    echo "🤖 Installing Claude Code globally..." && \
    npm install -g @anthropic-ai/claude-code && \
    echo "🧹 Final cleanup..." && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install essential Python packages for Claude Code
RUN echo "🐍 Installing essential Python packages..." && \
    pip3 install --no-cache-dir --upgrade pip setuptools wheel && \
    echo "📚 Installing development and utility packages..." && \
    pip3 install --no-cache-dir \
    # Core libraries
    requests urllib3 certifi \
    # Development tools
    pytest black flake8 pylint \
    # Utilities
    pyyaml toml \
    # System utilities
    psutil \
    && echo "🧹 Cleaning pip cache..." && \
    rm -rf ~/.cache/pip

# Create workspace
RUN echo "📁 Creating workspace directory..." 
WORKDIR /${WORKSPACE}

# Create non-root user for security
RUN echo "👤 Creating secure non-root user 'coder'..." && \
    useradd -m -s /bin/bash coder && \
    chown -R coder:coder /${WORKSPACE} && \
    usermod -aG sudo coder && \
    echo 'coder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Switch to non-root user
USER coder
ENV HOME=/home/coder

# Enhanced bashrc with neofetch and help system
RUN echo "🎨 Setting up enhanced shell environment..." && \
    echo 'export PS1="\[\033[0;32m\]\u@claude-sandbox\[\033[00m\]:\[\033[0;34m\]\w\[\033[00m\]\$ "' >> /home/coder/.bashrc && \
    echo 'neofetch' >> /home/coder/.bashrc && \
    echo 'cd /${WORKSPACE}' >> /home/coder/.bashrc && \
    echo 'echo "🤖 Claude Code sandbox ready! Use '\''claude-code'\'' to start. Type '\''help'\'' for tools."' >> /home/coder/.bashrc

# Add comprehensive help function
RUN echo "ℹ️  Setting up help system..." && \
    echo 'help() {' >> /home/coder/.bashrc && \
    echo '  echo "Claude Code Sandbox - Available Tools:"' >> /home/coder/.bashrc && \
    echo '  echo "  Claude Code: claude-code (installed globally)"' >> /home/coder/.bashrc && \
    echo '  echo "  Node.js: node, npm (v18+)"' >> /home/coder/.bashrc && \
    echo '  echo "  Python: python3, pip3, black, flake8, pylint, pytest"' >> /home/coder/.bashrc && \
    echo '  echo "  Editors: vim, nano, mc (midnight commander)"' >> /home/coder/.bashrc && \
    echo '  echo "  Network: nmap, tcpdump, telnet, traceroute, ping, ssh"' >> /home/coder/.bashrc && \
    echo '  echo "  System: htop, neofetch, lsof, ps, netstat, screen, tmux"' >> /home/coder/.bashrc && \
    echo '  echo "  Files: tree, tar, zip, unzip, rsync"' >> /home/coder/.bashrc && \
    echo '  echo "  Utils: git, curl, wget, jq, bc"' >> /home/coder/.bashrc && \
    echo '}' >> /home/coder/.bashrc

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python3 --version || exit 1

CMD ["/bin/bash"]