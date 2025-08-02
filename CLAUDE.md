# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## ⚡ TLDR

**Quick Commands:**
```bash
# Start container
docker-compose up -d && docker exec -it claude-sandbox bash

# Or one-liner setup
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash
```

**Container includes:** Essential tools for Claude Code: Python, git, network tools (ssh, curl), system utilities, persistent `/workspace`

## 🚧 **REFACTORING IN PROGRESS**

**Current Issues Being Fixed:**
- Remove unnecessary web server code and examples 
- Strip out excessive Python packages not needed for Claude Code
- Remove unnecessary port mappings
- Add verbose build explanations for each step
- Research what Claude Code actually needs
- Simplify to core purpose: clean Ubuntu + Claude Code tools

**Todo List:**
1. Remove web server examples and HTTP server code
2. Remove unnecessary port mappings (currently has 3 ports)
3. Add verbose build output explaining each step to user
4. Verify security updates (apt update && apt upgrade -y)
5. Research if Claude Code auto-installs/starts on container boot
6. Remove excessive Python packages (matplotlib, seaborn, jupyter, etc.)
7. Simplify to core purpose: Ubuntu + tools for Claude Code only
8. Research what ports/services Claude Code actually needs
9. Update all documentation to reflect simplified approach
10. Commit clean, simplified version

---

## Overview

This is a portable Docker container setup that creates a comprehensive Ubuntu environment with all tools needed for Claude Code to function effectively. The system uses a standard docker-compose configuration for maximum portability and can be deployed with a single command or used directly with docker-compose.

## Architecture

### Core Purpose
- Boot a clean Ubuntu 22.04 Docker container
- Install complete Python ecosystem and common TCP/IP tools
- Provide isolated environment for safe code execution
- Portable docker-compose configuration for easy deployment

### Portable Design
The system is built around three core files:
- **`docker-compose.yml`**: Complete container orchestration with all settings
- **`Dockerfile`**: Self-contained Ubuntu environment with comprehensive toolset
- **`run.sh`**: Optional convenience script for setup and deployment

### Complete Toolset Installed

#### Core System Tools
- **System utilities**: curl, wget, git, vim, nano, tree, htop, neofetch
- **File manager**: mc (midnight commander)
- **Build tools**: build-essential, make, cmake
- **Terminal tools**: screen, tmux

#### Complete Python Stack
- **Python**: python3, pip3, venv, setuptools, wheel
- **Core libraries**: requests, urllib3, certifi
- **Data science**: pandas, numpy, matplotlib, seaborn
- **Development tools**: pytest, black, flake8, pylint
- **Utilities**: pyyaml, json5, toml, psutil

#### Network and TCP/IP Tools
- **Network scanning**: nmap
- **Traffic analysis**: tcpdump, wireshark-common
- **Network utilities**: netcat, telnet, traceroute, ping
- **Network config**: iptables, net-tools, iproute2
- **SSH tools**: ssh, openssh-client
- **DNS tools**: dnsutils

#### System and File Tools
- **Process tools**: lsof, procps, psmisc
- **Archive tools**: unzip, zip, tar, gzip, bzip2, xz-utils
- **Text processing**: jq, grep, sed, gawk
- **File utilities**: rsync, file, bc

## Common Commands

### Quick Setup
```bash
# One-command setup (downloads and runs)
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash

# Local setup with run script
./run.sh
```

### Direct Docker Compose Usage
```bash
# Clone repository
git clone https://github.com/nixfred/docker-claude-sandbox.git
cd docker-claude-sandbox

# Build and start
docker-compose up -d

# Enter container
docker exec -it claude-sandbox bash
```

### Container Management
```bash
# Enter container (shows neofetch on entry)
docker exec -it claude-sandbox bash

# Check status and logs
docker ps | grep claude-sandbox
docker-compose logs

# Start/stop/rebuild
docker-compose up -d
docker-compose down
docker-compose build --no-cache
```

### Inside Container
```bash
# Show available tools
help

# System information
neofetch

# File management
mc                    # Midnight Commander
tree /workspace      # Directory structure

# Network tools
nmap -sn 192.168.1.0/24    # Network scan
ping google.com            # Connectivity test
tcpdump -i any            # Traffic monitoring
```

## Development Notes

### Container Configuration
- Based on Ubuntu 22.04 with security updates
- Non-root `coder` user with passwordless sudo privileges
- Persistent `/workspace` directory via Docker volume `claude_sandbox_data`
- Fixed container name `claude-sandbox` for consistency
- Standard ports 8000, 8001, 8002 exposed
- Automatic neofetch display on login

### Portable Design Benefits
- **Standard docker-compose.yml**: Can be used directly without run script
- **No external dependencies**: All configuration embedded in compose file
- **Version controlled**: All settings tracked in repository
- **Easy customization**: Modify docker-compose.yml for custom ports/volumes
- **CI/CD friendly**: Standard Docker workflow

### Security Features
- Non-root user execution with sudo access
- Latest security updates applied during build
- Isolated from host system
- Comprehensive networking tools for security testing
- Persistent workspace separate from container filesystem

### Deployment Options

#### Option 1: One-Command Setup
Uses run.sh script that downloads docker-compose.yml and Dockerfile automatically.

#### Option 2: Direct Clone and Compose
```bash
git clone https://github.com/nixfred/docker-claude-sandbox.git
cd docker-claude-sandbox
docker-compose up -d
```

#### Option 3: Manual Download
Download docker-compose.yml and Dockerfile manually, then run `docker-compose up -d`.

The container includes a built-in help system accessible with the `help` command that lists all available tools and their purposes.