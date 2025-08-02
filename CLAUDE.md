# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This repository creates a lightweight Docker environment optimized specifically for Claude Code development. The core architecture consists of:

- **`Dockerfile`**: Ubuntu 22.04 base with Claude Code pre-installed + Node.js 18+ + essential tools
- **`docker-compose.yml`**: Container orchestration with no port mappings (Claude Code is CLI-based)
- **`run.sh`**: Optional setup script for automated deployment
- **Persistent workspace**: `/workspace` directory survives container restarts

### What's Included
- **Claude Code**: Pre-installed globally - just run `claude-code`
- **Node.js 18+**: Required runtime for Claude Code
- **Essential Python stack**: Core libraries without bloat (requests, pytest, black, flake8, pylint)
- **Development tools**: git, vim, nano, mc, tmux
- **Network utilities**: ssh, curl, wget, ping (minimal essential tools)
- **Verbose build process**: See exactly what's being installed during build

## Common Development Commands

### Container Lifecycle
```bash
# Build and start (most common)
docker-compose up -d

# Rebuild after Dockerfile changes
docker-compose build --no-cache && docker-compose up -d

# Enter running container
docker exec -it claude-sandbox bash

# View logs and status
docker-compose logs
docker ps | grep claude-sandbox

# Stop and cleanup
docker-compose down
docker system prune -f  # Remove unused images
```

### Testing Changes
```bash
# Test different port configurations
# Edit docker-compose.yml ports section, then:
docker-compose down && docker-compose up -d

# Test Dockerfile modifications
docker-compose build --no-cache

# Validate docker-compose syntax
docker-compose config
```

### Repository Management
```bash
# Update documentation after changes
git add CLAUDE.md README.md && git commit -m "docs: update"

# Test end-to-end deployment
git clone https://github.com/nixfred/docker-claude-sandbox.git /tmp/test
cd /tmp/test && docker-compose up -d
```

## Development Workflow

### Modifying the Container
1. Edit `Dockerfile` to add/remove packages or configuration
2. Update `docker-compose.yml` if networking/volume changes needed
3. Test with `docker-compose build --no-cache && docker-compose up -d`
4. Update documentation in both `CLAUDE.md` and `README.md`
5. Commit changes and test with fresh clone

### Container Architecture Details
- **Base**: Ubuntu 22.04 with security updates (`apt upgrade -y`)
- **User**: Non-root `coder` with passwordless sudo
- **Workspace**: Persistent `/workspace` via Docker volume
- **Networking**: Bridge network with configurable port mappings
- **Security**: Isolated from host, latest security patches applied

### Key Configuration Points
- **Port mapping**: None required (Claude Code is CLI-based)
- **Volume persistence**: `claude_sandbox_data` volume for `/workspace`
- **Build args**: `WORKSPACE` variable controls internal directory name
- **Claude Code**: Globally installed during build process

## Optimized for Claude Code

✅ **Improvements Made**: 
- Claude Code pre-installed globally with Node.js 18+ runtime
- Removed all port mappings (Claude Code is CLI-based)
- Removed unnecessary Python packages (matplotlib, seaborn, jupyter)
- Removed unnecessary network tools (nmap, tcpdump, wireshark, iptables)
- Removed unnecessary health checks and monitoring
- Removed heavy build tools (build-essential, make, cmake)
- Removed custom networks and restart policies
- Removed neofetch (just eye candy) and screen (tmux is sufficient)
- Added verbose build output to show installation progress
- Focused on absolutely minimal essential tools Claude Code needs
- Added container optimization environment variables

## Essential Commands for Claude Code

```bash
# Quick start for Claude Code usage
docker-compose up -d && docker exec -it claude-sandbox bash

# Start Claude Code (pre-installed globally)
claude-code

# Inside container - verify environment
node --version     # Verify Node.js 18+ available
python3 --version  # Verify Python available
git --version      # Verify git available  
curl --version     # Verify network tools
ls /workspace      # Check persistent workspace

# Container includes these Claude Code essentials:
# - Claude Code pre-installed globally
# - Node.js 18+ runtime (required for Claude Code)
# - Python 3 with essential packages (requests, pytest, black, flake8, pylint)
# - Git for version control
# - Network tools (curl, wget, ssh, ping)
# - Text editors (vim, nano, mc)
# - System utilities (htop, ps, tmux)
```

## Troubleshooting

### Common Issues
- **No port conflicts**: Claude Code doesn't need ports - purely CLI-based
- **Claude Code not found**: Ensure container built successfully with Node.js installation
- **Permission issues**: Container runs as `coder` user with sudo access
- **Volume persistence**: Files in `/workspace` persist, other locations don't
- **Build failures**: Use `docker-compose build --no-cache` to force clean build

### Development Testing
```bash
# Test in clean environment
docker-compose down -v  # Remove volumes too
docker system prune -f  # Clean images
docker-compose up -d    # Fresh build

# Verify essential functionality
docker exec claude-sandbox claude-code --version  # Verify Claude Code
docker exec claude-sandbox node --version         # Verify Node.js
docker exec claude-sandbox python3 -c "print('Python OK')"
docker exec claude-sandbox git --version
docker exec claude-sandbox curl -s http://httpbin.org/ip
```