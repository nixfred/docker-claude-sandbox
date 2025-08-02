# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This repository creates a lightweight Docker environment optimized specifically for Claude Code development. The architecture consists of three core files that work together:

### Core Components

1. **`Dockerfile`**: Builds the container image
   - Base: Ubuntu 22.04 LTS
   - Installs Claude Code globally via npm
   - Sets up non-root `coder` user with sudo access
   - Configures welcome message in bashrc
   - Includes only essential tools (git, curl, gcc, Python3, Node.js 18+)

2. **`docker-compose.yml`**: Orchestrates container deployment
   - Defines service configuration (no hardcoded container names)
   - Creates persistent volume `claude_sandbox_data` for `/workspace`
   - Enables TTY and stdin for interactive Claude Code sessions
   - No port mappings (Claude Code is CLI-based)

3. **`run.sh`**: Smart setup and entry script
   - Detects local vs remote execution (works with `curl | bash`)
   - Interactive container naming with conflict resolution
   - Handles docker-compose requirement checking
   - Uses `docker run` for dynamic container naming
   - Automatically enters container when TTY is available

### Critical Design Decisions
- **Minimal philosophy**: Only tools required for Claude Code are included
- **Dynamic image naming**: Script handles different directory contexts
- **TTY-aware execution**: Different behavior for piped vs interactive runs
- **Persistent workspace**: `/workspace` volume survives container lifecycle

### What's Included (MINIMAL by Design)
- **Claude Code**: Pre-installed globally - just run `claude`
- **Node.js 18+**: Required runtime for Claude Code
- **Essential Python stack**: Core libraries without bloat (requests, pytest, black, flake8, pylint)
- **Git**: Version control (essential for Claude Code workflows)
- **curl**: For downloading dependencies
- **gcc**: Compiler for building Python packages from source when needed
- **Verbose build process**: See exactly what's being installed during build

### What's NOT Included (Ask Claude Code to Install)
- **Editors** (vim, nano, emacs) - Ask Claude: "Install vim because I need to edit files"
- **Archive tools** (zip, tar, unzip) - Ask Claude: "Install unzip because I need to extract files"  
- **System monitoring** (htop, ps) - Ask Claude: "Install htop because I need to monitor processes"
- **Network tools** (wget, ssh, ping) - Ask Claude: "Install ssh because I need to clone private repos"
- **File managers** (mc, ranger) - Ask Claude: "Install mc because I need file browser"

**Philosophy**: Container includes ONLY what Claude Code requires. Everything else gets installed on-demand with justification.


## Common Development Commands

### Building and Running
```bash
# Quick start (recommended) - prompts for container name
./run.sh

# Remote one-liner installation
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash

# Manual build and run
docker-compose build --no-cache  # Force rebuild
docker-compose up -d             # Start in background
```

### Accessing the Container
```bash
# Enter container and start Claude Code immediately
docker exec -it <container-name> bash -c "cd /workspace && claude"

# Enter container bash shell
docker exec -it <container-name> bash

# View container logs
docker-compose logs
docker logs <container-name>

# Stop and remove container
docker-compose down
docker rm -f <container-name>  # If using custom name
```

### Testing and Development
```bash
# Test complete rebuild cycle
docker-compose down -v
docker system prune -f
docker-compose build --no-cache
./run.sh

# Verify all components work inside container
docker exec -it <container-name> bash -c "
  claude --version && 
  node --version && 
  python3 -c 'import requests; print(\"Python OK\")' &&
  git --version"

# Test the run.sh script behavior
./run.sh --help  # Show usage information
```

## Key Implementation Details

### run.sh Script Behavior
The script handles several complex scenarios:

1. **TTY Detection**: 
   - Interactive mode: Prompts for container name, auto-enters container
   - Piped mode (`curl | bash`): Shows manual entry commands

2. **Container Naming**:
   - Uses `/dev/tty` for prompts even when piped
   - Handles existing container conflicts
   - Falls back to "claude-sandbox" if no TTY available

3. **Image Naming Challenge**:
   - `docker-compose build` creates image based on directory name
   - Script uses `docker run` with assumed image name
   - May fail if run from differently-named directory

### Docker Build Process
The Dockerfile performs these steps in order:
1. Sets up Ubuntu 22.04 base with locale configuration
2. Installs system packages including gcc (needed for Python package compilation)
3. Installs Node.js 18+ via NodeSource repository
4. Installs Claude Code globally with npm
5. Creates non-root user and configures bashrc with welcome message

### Container Welcome System
When entering the container, users see:
```
╔══════════════════════════════════════════════════════════════════╗
║    🤖 Claude Code Sandbox Ready!                               ║
║    🚀 Start Claude Code: claude                                 ║
║    📦 Need software? Tell Claude why you need it!               ║
║    ✅ Available: Node.js, Python3, Git, curl, apt, sudo        ║
╚══════════════════════════════════════════════════════════════════╝
```

This is configured in the Dockerfile's final RUN command that modifies `/home/coder/.bashrc`.

## Troubleshooting Common Issues

### Build Failures
- **Python package compilation errors**: Dockerfile includes `gcc` for compiling packages like `psutil` when pre-built wheels aren't available
- **Claude Code installation fails**: Ensure Node.js 18+ installed successfully before npm install
- **Permission errors**: Container uses non-root `coder` user with passwordless sudo

### Runtime Issues  
- **Container won't start**: Check `docker-compose config` for syntax errors
- **Can't enter container**: Verify container is running with `docker ps`
- **TTY errors with curl command**: Script detects TTY availability and shows manual commands when piped

### Image Naming Issues
- **"docker-claude-sandbox_claude-sandbox" not found**: This happens when running from different directory name than expected
- Script assumes directory is named "docker-claude-sandbox" for image naming
- Use `docker images` to see actual image name if build succeeds but run fails