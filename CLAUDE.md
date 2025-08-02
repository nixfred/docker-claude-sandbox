# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This repository creates a portable Docker sandbox environment for Claude Code operations. The core architecture consists of:

- **`Dockerfile`**: Ubuntu 22.04 base with comprehensive toolset installation
- **`docker-compose.yml`**: Container orchestration with volume/network configuration  
- **`run.sh`**: Optional setup script for automated deployment
- **Persistent workspace**: `/workspace` directory survives container restarts

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
- **Port mappings**: Currently 8000, 8001, 8002 (configurable in docker-compose.yml)
- **Volume persistence**: `claude_sandbox_data` volume for `/workspace`
- **Build args**: `WORKSPACE` variable controls internal directory name
- **Health checks**: Python availability check every 30s

## Current State Notes

⚠️ **Known Issues**: 
- Container includes web development tools that may not be needed for Claude Code
- Multiple port mappings when Claude Code may only need specific ports
- Some Python packages (matplotlib, seaborn) may be excessive for core needs

The container is currently comprehensive but may benefit from simplification based on actual Claude Code requirements.

## Essential Commands for Claude Code

```bash
# Quick start for Claude Code usage
docker-compose up -d && docker exec -it claude-sandbox bash

# Inside container - test Claude Code environment
python3 --version  # Verify Python available
git --version      # Verify git available  
curl --version     # Verify network tools
ls /workspace      # Check persistent workspace

# Container includes these Claude Code essentials:
# - Python 3 with pip, venv, dev tools
# - Git for version control
# - Network tools (curl, wget, ssh)
# - Text editors (vim, nano)
# - System utilities (htop, lsof, ps)
```

## Troubleshooting

### Common Issues
- **Port conflicts**: Change port mappings in docker-compose.yml if 8000-8002 are in use
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
docker exec claude-sandbox python3 -c "print('Python OK')"
docker exec claude-sandbox git --version
docker exec claude-sandbox curl -s http://httpbin.org/ip
```