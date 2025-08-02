# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This repository creates a lightweight Docker environment optimized specifically for Claude Code development. The system uses a three-file architecture for maximum portability:

- **`Dockerfile`**: Multi-stage Ubuntu 22.04 build with Claude Code + Node.js 18+ + minimal Python stack
- **`docker-compose.yml`**: Container orchestration with persistent volumes and TTY support 
- **`run.sh`**: Interactive setup script with container naming, conflict resolution, and automatic entry

### Key Architectural Decisions
- **No port mappings**: Claude Code is purely CLI-based, eliminating networking complexity
- **Persistent `/workspace` volume**: Survives container restarts and rebuilds
- **Non-root `coder` user**: Security-hardened with passwordless sudo access
- **Minimal dependency philosophy**: Only essential tools included, everything else installed on-demand

### What's Included (MINIMAL by Design)
- **Claude Code**: Pre-installed globally - just run `claude`
- **Node.js 18+**: Required runtime for Claude Code
- **Essential Python stack**: Core libraries without bloat (requests, pytest, black, flake8, pylint)
- **Git**: Version control (essential for Claude Code workflows)
- **curl**: For downloading dependencies
- **gcc**: Compiler for building Python packages on ARM systems (Raspberry Pi)
- **Verbose build process**: See exactly what's being installed during build

### What's NOT Included (Ask Claude Code to Install)
- **Editors** (vim, nano, emacs) - Ask Claude: "Install vim because I need to edit files"
- **Archive tools** (zip, tar, unzip) - Ask Claude: "Install unzip because I need to extract files"  
- **System monitoring** (htop, ps) - Ask Claude: "Install htop because I need to monitor processes"
- **Network tools** (wget, ssh, ping) - Ask Claude: "Install ssh because I need to clone private repos"
- **File managers** (mc, ranger) - Ask Claude: "Install mc because I need file browser"

**Philosophy**: Container includes ONLY what Claude Code requires. Everything else gets installed on-demand with justification.

### Enhanced Welcome Experience
The container now features a beautiful welcome message that displays when entering:
```
╔══════════════════════════════════════════════════════════════════╗
║    🤖 Claude Code Sandbox Ready!                               ║
║    🚀 Start Claude Code: claude                                 ║
║    📦 Need software? Tell Claude why you need it!               ║
║    ✅ Available: Node.js, Python3, Git, curl, apt, sudo        ║
╚══════════════════════════════════════════════════════════════════╝
```

## Essential Development Commands

### Primary Entry Points
```bash
# Recommended: Interactive setup with container naming
./run.sh

# One-liner remote deployment (for testing/demos)
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash

# FeNix users: Ultimate convenience (if available)
sclaw
```

### Container Lifecycle Management
```bash
# Recommended: Use setup script (auto-starts Claude Code, prompts for container name)
./run.sh

# Or manual setup
docker-compose up -d

# Rebuild after Dockerfile changes
docker-compose build --no-cache && docker-compose up -d

# Enter running container and start Claude Code
docker exec -it claude-sandbox bash -c "cd /workspace && claude"  # Default name
docker exec -it your-name bash -c "cd /workspace && claude"        # Custom name

# Or just enter bash if needed
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
# Quick start for Claude Code usage (auto-starts Claude Code)
./run.sh

# Or manual container entry with Claude Code start
docker-compose up -d && docker exec -it claude-sandbox bash -c "cd /workspace && claude"

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

### Critical Run.sh Behavior
The `run.sh` script handles several complex scenarios:
- **Container naming conflicts**: Interactive prompts with conflict resolution
- **TTY detection**: Uses `exec docker exec -it` to properly enter container after setup
- **Remote execution compatibility**: Works with both local `./run.sh` and `curl | bash` patterns
- **Automatic container entry**: User ends up inside container ready to run `claude`

### Development Testing
```bash
# Test complete rebuild cycle
docker-compose down -v && docker system prune -f && docker-compose build --no-cache && docker-compose up -d

# Verify core functionality inside container
docker exec -it claude-sandbox bash -c "
  claude --version && 
  node --version && 
  python3 -c 'import requests; print(\"Python stack OK\")' &&
  git --version &&
  echo 'All systems operational'"

# Test run.sh script end-to-end
rm -rf /tmp/claude-test && git clone . /tmp/claude-test && cd /tmp/claude-test && ./run.sh
```

## Container Welcome System

The container features an enhanced bashrc that provides immediate orientation:
- **Beautiful ASCII welcome message** with clear instructions
- **Available tools summary** (Node.js, Python3, Git, curl, apt, sudo)
- **Software installation guidance** encouraging Claude Code interaction
- **Automatic workspace navigation** to `/workspace` on entry

This eliminates the common "what do I do now?" moment when entering containers.

## Important Implementation Notes

### Docker Compose Configuration
- Container name defaults to `claude-sandbox` but `run.sh` allows customization
- Volume `claude_sandbox_data` persists `/workspace` across container lifecycle
- `stdin_open: true` and `tty: true` essential for Claude Code interactive functionality

### Run.sh Script Architecture
The script follows a fail-safe pattern:
1. Environment validation (Docker availability)
2. Configuration file handling (local vs. remote)
3. Interactive container naming with conflict resolution
4. Container lifecycle management
5. **Critical**: `exec docker exec -it` to transfer control to container

### Dockerfile Multi-Stage Philosophy
- **Stage 1**: System updates and locale configuration
- **Stage 2**: Essential package installation (git, curl, Python stack)
- **Stage 3**: Node.js 18+ and Claude Code global installation
- **Stage 4**: User creation and workspace preparation
- **Stage 5**: Welcome message configuration in bashrc