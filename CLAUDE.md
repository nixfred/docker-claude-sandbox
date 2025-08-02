# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview - v1.0

This repository creates a **cross-platform Docker environment** optimized specifically for Claude Code development. After extensive testing and refinement, v1.0 represents a mature, reliable system with intelligent platform adaptation.

### Core Components

1. **`run.sh`**: Intelligent setup and entry script (311 lines)
   - **Cross-platform compatibility**: Linux, macOS, ARM64, x86_64
   - **TTY intelligence**: Auto-enters on Linux, manual commands on macOS
   - **Robust image detection**: 4-tier fallback system for image naming
   - **macOS optimizations**: Buildx fixes, Colima credential handling
   - **Interactive UX**: Container naming, conflict resolution, progress indicators

2. **`Dockerfile`**: Optimized container image (98 lines)
   - **Base**: Ubuntu 22.04 LTS with security updates
   - **Claude Code**: Pre-installed globally via npm
   - **Runtime**: Node.js 18+ for Claude Code operation
   - **Development**: Python 3 + essential packages + gcc compiler
   - **Security**: Non-root `coder` user with passwordless sudo
   - **UX**: Beautiful welcome banner and optimized shell environment

3. **`docker-compose.yml`**: Container orchestration (20 lines)
   - **Service definition**: claude-sandbox with build context
   - **Volume persistence**: `claude_sandbox_data` for `/workspace`
   - **Interactive support**: TTY and stdin enabled
   - **No network exposure**: Claude Code is CLI-based

4. **Documentation Suite**:
   - **`README.md`**: Comprehensive user guide with troubleshooting
   - **`CLAUDE.md`**: Development architecture and implementation details
   - **`AIINSTALL.md`**: Technical guide for AI assistant integration

### Critical Design Decisions
- **Cross-platform first**: Tested and validated on all major platforms
- **Intelligent adaptation**: Different behaviors based on platform capabilities
- **Robust fallbacks**: Multiple strategies for image detection and container naming
- **Security by design**: Non-root execution with appropriate permissions
- **Minimal core + extensibility**: Essential tools only, expand through Claude
- **Persistent workspace**: Data survives container lifecycle and rebuilds

### What's Included (Optimized Core)
- **Claude Code**: Pre-installed globally - just run `claude`
- **Node.js 18+**: Required runtime for Claude Code
- **Python 3 development stack**: Core libraries (requests, pytest, black, flake8, pylint, psutil)
- **Git**: Version control (essential for Claude Code workflows)
- **Build tools**: gcc compiler for native package compilation
- **System utilities**: curl, locale configuration, timezone handling
- **Security setup**: Non-root user with appropriate sudo access
- **Developer UX**: Custom shell prompt, welcome banner, workspace navigation

### What's NOT Included (Ask Claude Code to Install)
- **Editors** (vim, nano, emacs) - Ask Claude: "Install vim because I need to edit files"
- **Archive tools** (zip, tar, unzip) - Ask Claude: "Install unzip because I need to extract files"  
- **System monitoring** (htop, ps) - Ask Claude: "Install htop because I need to monitor processes"
- **Network tools** (wget, ssh, ping) - Ask Claude: "Install ssh because I need to clone private repos"
- **File managers** (mc, ranger) - Ask Claude: "Install mc because I need file browser"

**Philosophy**: Container includes ONLY what Claude Code requires. Everything else gets installed on-demand with justification.


## Common Development Commands (v1.0)

### Building and Running
```bash
# Quick start (recommended) - prompts for container name
./run.sh

# Remote one-liner installation (tested across platforms)
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash

# Version-pinned installation
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/v1.0/run.sh | bash

# Cache-busting for immediate updates
curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh?$(date +%s)" | bash

# Manual build and run
docker-compose build --no-cache  # Force rebuild
./run.sh                         # Use script for proper image detection
```

### Accessing the Container
```bash
# Enter container with your custom name
docker exec -it YOUR_CONTAINER_NAME bash

# Start Claude Code directly
docker exec -it YOUR_CONTAINER_NAME bash -c "cd /workspace && claude"

# Check container status
docker ps --filter "name=YOUR_CONTAINER_NAME"

# View container logs
docker logs YOUR_CONTAINER_NAME

# Stop and remove container (preserves workspace volume)
docker rm -f YOUR_CONTAINER_NAME

# Remove container AND workspace volume (nuclear option)
docker volume rm claude_sandbox_data
```

### Testing and Development (v1.0 Validated)
```bash
# Test complete rebuild cycle
docker-compose down -v
docker system prune -f
docker-compose build --no-cache
./run.sh

# Verify all components work inside container
docker exec -it YOUR_CONTAINER_NAME bash -c "
  claude --version && 
  node --version && 
  python3 -c 'import requests; print(\"Python OK\")' &&
  git --version"

# Test cross-platform compatibility
./run.sh --help  # Show usage information

# Test with multiple container names (known volume sharing issue)
./run.sh  # Name: test1
./run.sh  # Name: test2  # WARNING: Shares workspace with test1

# Test macOS-specific features (if on macOS)
DOCKER_BUILDKIT=1 ./run.sh  # Should auto-disable buildx
```

### Validated Testing Results (v1.0)
**✅ Tested and confirmed working on:**
- **Linux ARM64** (Raspberry Pi): Auto-enters container, full functionality
- **Linux x86_64**: Standard Docker environments
- **macOS Intel**: Docker Desktop + Colima compatibility
- **macOS Apple Silicon**: Native ARM64 support

**Platform-specific behavior confirmed:**
- Linux: `exec docker exec -it` works (auto-entry)
- macOS: Manual commands provided (TTY limitation expected)
- All platforms: Image detection, container naming, conflict resolution working

## Key Implementation Details

### run.sh Script Behavior (v1.0)
The script handles complex cross-platform scenarios:

1. **Advanced TTY Detection**:
   ```bash
   if [ -t 0 ] && [ -t 1 ] && [ -c /dev/tty ]; then
       # Linux: Auto-enter container
       exec docker exec -it "$CONTAINER_NAME" bash
   else
       # macOS/piped: Show manual commands
   ```

2. **Container Naming & Conflict Resolution**:
   - Uses `/dev/tty` redirection for prompts in piped execution
   - Interactive conflict resolution for existing containers
   - Validates container names and handles Docker naming restrictions
   - Falls back to "claude-sandbox" if no TTY available

3. **Robust Image Detection** (4-tier fallback):
   ```bash
   # Tier 1: docker-compose images command
   IMAGE_NAME=$(docker-compose images -q claude-sandbox 2>/dev/null)
   # Tier 2: docker-compose config parsing
   # Tier 3: Search for any claude-sandbox image
   # Tier 4: Try common naming patterns
   ```

4. **Platform-Specific Optimizations**:
   - **macOS**: Disables buildx, handles Colima credential issues
   - **Linux**: Native Docker support with full TTY integration
   - **ARM64**: Tested and validated on Raspberry Pi

### Docker Build Process (v1.0)
The Dockerfile performs these optimized steps:

1. **Base System Setup** (Lines 1-22):
   ```dockerfile
   FROM ubuntu:22.04
   ENV DEBIAN_FRONTEND=noninteractive
   # Locale and timezone configuration
   ```

2. **Essential Package Installation** (Lines 23-41):
   ```bash
   apt-get install -y git curl ca-certificates python3 python3-pip gcc
   # Minimal package set with build tools
   ```

3. **Node.js 18+ Installation** (Lines 43-51):
   ```bash
   curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
   npm install -g @anthropic-ai/claude-code
   # ⚠️ Known issue: No installation verification
   ```

4. **Python Development Stack** (Lines 53-67):
   ```bash
   pip3 install requests pytest black flake8 pylint psutil pyyaml toml
   # Essential packages for Claude Code development
   ```

5. **User Security Setup** (Lines 74-82):
   ```bash
   useradd -m -s /bin/bash coder
   usermod -aG sudo coder
   echo 'coder ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
   ```

6. **Shell Environment Configuration** (Lines 84-95):
   ```bash
   # Custom PS1 prompt and welcome banner
   # ⚠️ Known issue: Hardcoded workspace path
   ```

### Container Welcome System
When entering the container, users see:
```
╔══════════════════════════════════════════════════════════════════╗
║    🤖 Claude Code Sandbox Ready!                                ║
║    🚀 Start Claude Code: claude                                 ║
║    📦 Need software? Tell Claude why you need it!               ║
║    ✅ Available: Node.js, Python3, Git, curl, apt, sudo        ║
╚══════════════════════════════════════════════════════════════════╝
```

This welcome banner is configured in the Dockerfile's final RUN command (lines 84-95) that modifies `/home/coder/.bashrc`.

## Development Guidelines for Claude Code

### When Making Changes
1. **Test across platforms**: Linux ARM64/x86_64, macOS Intel/Apple Silicon
2. **Validate TTY behavior**: Both interactive and piped execution modes
3. **Check image detection**: Ensure all 4 fallback tiers work
4. **Update documentation**: README.md, CLAUDE.md, and AIINSTALL.md
5. **Version appropriately**: Update version strings in run.sh header

### Code Quality Standards
- **Error handling**: Every operation should have failure paths
- **User feedback**: Clear status messages and progress indicators
- **Platform compatibility**: Test macOS buildx, credential helpers, TTY differences
- **Security**: Maintain non-root execution, validate user inputs
- **Documentation**: Keep inline comments and help text current

### Release Process
1. **Local testing**: Validate on multiple platforms
2. **Version bump**: Update run.sh header version
3. **Git tag**: Create annotated tag with changelog
4. **GitHub release**: Create release with comprehensive notes
5. **Documentation**: Update all .md files with new features/fixes

### Known Technical Debt
- Volume sharing issue (high priority fix needed)
- Container name validation missing
- Claude Code installation verification
- Temporary file cleanup on macOS
- Hardcoded paths in shell configuration

This system has evolved from experimental script to production-quality tool through extensive testing and refinement.

## Troubleshooting Guide (v1.0)

### Build Failures
- **Python package compilation errors**: 
  - **Solution**: Dockerfile includes `gcc` for compiling packages like `psutil`
  - **ARM64 specific**: May need longer build times for native compilation

- **Claude Code installation fails**:
  - **Check**: Node.js 18+ installed successfully (`node --version`)
  - **Known issue**: No verification of npm install success
  - **Workaround**: Check build logs for npm errors

- **macOS buildx errors**:
  - **Auto-fixed**: Script automatically sets `DOCKER_BUILDKIT=0`
  - **Manual fix**: `export DOCKER_BUILDKIT=0` before running

### Runtime Issues
- **Container won't start after build**:
  - **Check**: `docker ps -a --filter "name=YOUR_CONTAINER_NAME"`
  - **Debug**: `docker logs YOUR_CONTAINER_NAME`
  - **Reset**: `docker system prune -f && ./run.sh`

- **"Input device is not a TTY" errors**:
  - **v1.0 Fix**: Use version-pinned URL to bypass CDN cache
  - `curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/v1.0/run.sh" | bash`

- **Image detection failures**:
  - **Check available images**: `docker images | grep claude-sandbox`
  - **Script shows**: Available images when detection fails
  - **Manual override**: Use specific image name with `docker run`

### Volume and Data Issues
- **Multiple containers sharing workspace**:
  - **Known behavior**: All containers share `claude_sandbox_data` volume
  - **Workaround**: Remove old containers before creating new ones
  - **Check volumes**: `docker volume ls | grep claude`

### Platform-Specific Issues
- **macOS Colima credential errors**: Auto-fixed by script
- **ARM64 build timeouts**: Increase Docker timeout or use cached images
- **Linux permission issues**: Ensure user in docker group (`sudo usermod -aG docker $USER`)

## Known Issues and Limitations (v1.0)

### Current Bugs Identified But Not Yet Fixed

**HIGH PRIORITY**:
1. **Volume Name Collision** (Line 262 in run.sh)
   - All containers share `claude_sandbox_data` volume regardless of container name
   - **Impact**: Multiple containers overwrite each other's workspace files
   - **Workaround**: Remove old containers before creating new ones
   - **Planned Fix**: Use `${CONTAINER_NAME}_data` for individual volumes

2. **Container Name Validation Missing** (Line 128 in run.sh)
   - No validation of user input against Docker naming restrictions
   - **Impact**: Could cause cryptic Docker errors for invalid names
   - **Workaround**: Use alphanumeric names with hyphens only

**MEDIUM PRIORITY**:
3. **Temporary File Cleanup Missing** (macOS credential fix)
   - Creates `/tmp/docker-claude-sandbox` but never removes it
   - **Impact**: Accumulates temp directories over time

4. **Redundant Redirection** (Line 38 in run.sh)
   ```bash
   docker info &> /dev/null 2>&1  # Redundant
   ```

5. **Container Readiness Timeout** (30 seconds may be insufficient)
   - **Impact**: May timeout on slow systems or first-time pulls

**LOW PRIORITY**:
6. **Claude Code Installation Verification Missing** (Dockerfile)
   - `npm install -g @anthropic-ai/claude-code` has no success verification
7. **Security Risk**: `curl | bash` pattern in Node.js installation
8. **Hardcoded Paths**: Some bashrc configurations use literal paths

### Platform-Specific Behavior (Expected)
- **Linux**: Auto-enters container after setup
- **macOS**: Provides manual entry commands (TTY limitation)
- **ARM64**: Fully supported and tested on Raspberry Pi
- **x86_64**: Standard support across all platforms