FROM ubuntu:22.04

# Build arguments 
ARG WORKSPACE=workspace

# Prevent interactive prompts and optimize for container use
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV NODE_ENV=production

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
    echo "📦 Installing ONLY what Claude Code needs..." && \
    apt-get install -y --no-install-recommends \
    # Claude Code essentials
    git \
    # Node.js dependencies  
    curl ca-certificates \
    # Python stack
    python3 python3-pip python3-venv python3-dev python3-setuptools python3-wheel \
    # Build tools for ARM/Python packages
    gcc \
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

# Set up shell environment with welcome message
RUN echo 'export PS1="\[\033[0;32m\]\u@claude-sandbox\[\033[00m\]:\[\033[0;34m\]\w\[\033[00m\]\$ "' >> /home/coder/.bashrc && \
    echo 'cd /${WORKSPACE}' >> /home/coder/.bashrc && \
    echo '' >> /home/coder/.bashrc && \
    echo 'echo ""' >> /home/coder/.bashrc && \
    echo 'echo "    ╔══════════════════════════════════════════════════════════════════╗"' >> /home/coder/.bashrc && \
    echo 'echo "    ║    🤖 Claude Code Sandbox Ready!                                ║"' >> /home/coder/.bashrc && \
    echo 'echo "    ║    🚀 Start Claude Code: claude                                 ║"' >> /home/coder/.bashrc && \
    echo 'echo "    ║    📦 Need software? Tell Claude why you need it!               ║"' >> /home/coder/.bashrc && \
    echo 'echo "    ║    ✅ Available: Node.js, Python3, Git, curl, apt, sudo        ║"' >> /home/coder/.bashrc && \
    echo 'echo "    ╚══════════════════════════════════════════════════════════════════╝"' >> /home/coder/.bashrc && \
    echo 'echo ""' >> /home/coder/.bashrc


CMD ["/bin/bash"]