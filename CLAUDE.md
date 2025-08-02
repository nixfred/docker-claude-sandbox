# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This repository creates a lightweight Docker environment optimized specifically for Claude Code development. The core architecture consists of:

- **`Dockerfile`**: Ubuntu 22.04 base with Claude Code pre-installed + Node.js 18+ + essential tools
- **`docker-compose.yml`**: Container orchestration with no port mappings (Claude Code is CLI-based)
- **`run.sh`**: Optional setup script for automated deployment
- **Persistent workspace**: `/workspace` directory survives container restarts

### What's Included (MINIMAL by Design)
- **Claude Code**: Pre-installed globally - just run `claude`
- **Node.js 18+**: Required runtime for Claude Code
- **Essential Python stack**: Core libraries without bloat (requests, pytest, black, flake8, pylint)
- **Git**: Version control (essential for Claude Code workflows)
- **curl**: For downloading dependencies
- **Verbose build process**: See exactly what's being installed during build

### What's NOT Included (Ask Claude Code to Install)
- **Editors** (vim, nano, emacs) - Ask Claude: "Install vim because I need to edit files"
- **Archive tools** (zip, tar, unzip) - Ask Claude: "Install unzip because I need to extract files"  
- **System monitoring** (htop, ps) - Ask Claude: "Install htop because I need to monitor processes"
- **Network tools** (wget, ssh, ping) - Ask Claude: "Install ssh because I need to clone private repos"
- **File managers** (mc, ranger) - Ask Claude: "Install mc because I need file browser"

**Philosophy**: Container includes ONLY what Claude Code requires. Everything else gets installed on-demand with justification.

## Common Development Commands

### Container Lifecycle
```bash
# Recommended: Use setup script (always prompts for container name, works with curl | bash)
./run.sh

# Or manual setup
docker-compose up -d

# Rebuild after Dockerfile changes
docker-compose build --no-cache && docker-compose up -d

# Enter running container (replace with your container name)
docker exec -it claude-sandbox bash  # Default name
docker exec -it your-name bash       # Custom name

# View logs and status
docker-compose logs
docker ps | grep claude

# Stop and cleanup
docker-compose down
docker system prune -f  # Remove unused images
```

### Container Naming
The `./run.sh` script provides container name customization with improved interactive support:
- Always prompts: `Container name [claude-sandbox]: ` (even when run via `curl ... | bash`)
- Default: `claude-sandbox` (just press Enter)
- Custom names: `project1-claude`, `testing-env`, etc.
- Automatic conflict resolution for existing containers with interactive prompts
- Uses `/dev/tty` redirection to ensure prompts work correctly when piped

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

✅ **MINIMAL Philosophy Applied**: 
- Claude Code pre-installed globally with Node.js 18+ runtime
- Removed ALL non-essential tools (editors, archive tools, system monitoring)
- Removed all port mappings (Claude Code is CLI-based)
- Removed unnecessary Python packages (matplotlib, seaborn, jupyter)
- Removed network tools (wget, ssh, ping) - install on-demand
- Removed health checks, custom networks, restart policies
- Removed build tools, file managers, terminal multiplexers
- Added clear welcome message: "Ask Claude to install what you need"
- Container optimization environment variables
- Focused on ONLY what Claude Code absolutely requires

**Result**: Ultra-minimal container that extends through Claude Code conversation.

## Essential Commands for Claude Code

```bash
# Quick start for Claude Code usage
docker-compose up -d && docker exec -it claude-sandbox bash

# Start Claude Code (pre-installed globally)
claude

# Inside container - verify environment
node --version     # Verify Node.js 18+ available
python3 --version  # Verify Python available
git --version      # Verify git available  
curl --version     # Verify network tools
ls /workspace      # Check persistent workspace (CLAUDE.md files persist here!)

# Container includes ONLY these essentials:
# - Claude Code pre-installed globally
# - Node.js 18+ runtime (required for Claude Code)
# - Python 3 with essential packages (requests, pytest, black, flake8, pylint)
# - Git for version control
# - curl for downloads
# Everything else: Ask Claude to install with justification!
```

## Troubleshooting

### Common Issues
- **No port conflicts**: Claude Code doesn't need ports - purely CLI-based
- **Claude Code not found**: Ensure container built successfully with Node.js installation
- **Permission issues**: Container runs as `coder` user with sudo access
- **Volume persistence**: Files in `/workspace` persist, other locations don't
- **Build failures**: Use `docker-compose build --no-cache` to force clean build
- **Interactive prompts not working**: Script now uses `/dev/tty` redirection to ensure prompts work with `curl | bash`

### Development Testing
```bash
# Test in clean environment
docker-compose down -v  # Remove volumes too
docker system prune -f  # Clean images
docker-compose up -d    # Fresh build

# Verify essential functionality
docker exec claude-sandbox claude --version  # Verify Claude Code
docker exec claude-sandbox node --version         # Verify Node.js
docker exec claude-sandbox python3 -c "print('Python OK')"
docker exec claude-sandbox git --version
docker exec claude-sandbox curl -s http://httpbin.org/ip
```