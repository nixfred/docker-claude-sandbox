# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This repository creates a **production-ready Docker environment** specifically optimized for Claude Code development. The system provides cross-platform compatibility (Linux, macOS, ARM64, x86_64) with intelligent platform adaptation and automated CI/CD validation.

**✅ Production Status**: Docker images published to Docker Hub with full multi-architecture support (AMD64 + ARM64).

### Core Components

**1. `run.sh` - Intelligent Setup Script**
- Cross-platform entry point with 4-tier image detection fallback
- TTY intelligence: auto-enters containers on Linux, provides manual commands on macOS  
- Interactive container naming with conflict resolution
- Platform-specific optimizations (macOS buildx fixes, Colima credential handling)
- Progress indicators and robust error handling

**2. `Dockerfile` - Container Definition**
- Ubuntu 22.04 LTS base with Claude Code pre-installed globally
- Node.js 20+ runtime for Claude Code operation
- Python 3 development stack with essential packages
- Non-root `coder` user with passwordless sudo access
- Custom welcome banner and optimized shell environment

**3. `docker-compose.yml` - Container Orchestration**
- External volume system: `${CONTAINER_NAME}_data` for workspace isolation
- Resource limits: 2GB RAM, 2 CPU cores for safety
- Environment variables: TZ auto-detection, TERM configuration
- No network exposure (Claude Code is CLI-based)

**4. Version Management System**
- Centralized versioning via `VERSION` file (current: 1.4.1)
- `scripts/update-version.sh` - Updates all documentation automatically
- `Makefile` - Simplifies common development tasks

### Container Distribution

**Docker Hub Publishing (Production) ✅**
- Multi-architecture builds: AMD64 + ARM64
- Automated publishing via GitHub Actions on version tags
- Repository: `frednix/claude-sandbox:latest`
- Semantic versioning with multiple tags (`latest`, `v1.4.1`, `1.4`, `1`)
- **ARM64 Support**: Requires `--platform linux/arm64` on some systems (Raspberry Pi)

## Common Development Commands

### Version Management
```bash
# Show current version
make version

# Update version across all files (uses scripts/update-version.sh)
make update-version

# Create new release (updates VERSION file, commits, tags)
make release VERSION=1.4.2
```

### Building and Testing
```bash
# Build Docker image locally
make build

# Run local CI tests (bash syntax + docker-compose validation)
make test

# Full rebuild cycle with container creation
docker-compose build --no-cache
./run.sh

# Test specific functionality
docker exec -it CONTAINER_NAME claude --version
docker exec -it CONTAINER_NAME node --version
docker exec -it CONTAINER_NAME python3 --version
```

### Container Operations
```bash
# Quick start (prompts for container name)
./run.sh

# Test published Docker Hub images (temporary containers)
docker run -it --rm frednix/claude-sandbox:latest

# ARM64 systems (Raspberry Pi, Apple Silicon)
docker run -it --rm --platform linux/arm64 frednix/claude-sandbox:latest

# Persistent container management
docker run -it --name my-project frednix/claude-sandbox:latest
docker exec -it my-project bash
docker start my-project && docker exec -it my-project bash
```

### CI/CD Workflows
```bash
# Trigger Docker Hub publishing (requires version tag)
git tag v1.4.2
git push --tags

# Check GitHub Actions status
gh run list

# View specific workflow run details
gh run view RUN_ID

# Re-run failed workflows
gh run rerun RUN_ID

# Manual workflow trigger (if supported)
gh workflow run "Documentation Validation"
```

## Development Architecture

### Intelligent Platform Adaptation
The system detects and adapts to different environments:
- **Linux**: Direct container entry with full TTY support
- **macOS**: Manual command provision due to TTY limitations
- **Docker environments**: Buildx compatibility, credential helper management
- **Container naming**: Dynamic volume isolation per container

### Workflow Triggers
- **CI Testing**: Every push to main, all PRs (`ci.yml`)
- **Docker Hub Publishing**: Version tags (`v*`) only (`docker-hub-publish.yml`)
- **Security Scanning**: Every push + scheduled daily (`security-scan.yml`)
- **Documentation Validation**: Changes to `*.md` files (`docs-validation.yml`)
- **Basic Validation**: Every push/PR (`basic-test.yml`)
- **Docker Build**: Multi-arch testing (`docker-build.yml`)

### External Volume System
Critical for data persistence:
```yaml
volumes:
  claude_sandbox_data:
    external: true
    name: ${CONTAINER_NAME:-claude-sandbox}_data
```
Each named container gets its own isolated workspace volume, preventing data collisions.

### Cross-Platform Testing Matrix
Automated validation across:
- Linux ARM64 (Raspberry Pi), Linux x86_64
- macOS Apple Silicon (Intel marked as untested)
- Multiple Docker environments (Desktop, Colima)

## Key Implementation Details

### Container Welcome System
Users see this on container entry:
```
╔══════════════════════════════════════════════════════════════════╗
║    🤖 Claude Code Sandbox Ready!                                ║
║    🚀 Start Claude Code: claude                                 ║
║    📦 Need software? Tell Claude why you need it!               ║
║    ✅ Available: Node.js, Python3, Git, curl, apt, sudo        ║
╚══════════════════════════════════════════════════════════════════╝
```

### Minimal Core Philosophy
Container includes ONLY Claude Code essentials:
- Claude Code (pre-installed globally)
- Node.js 20+ (required runtime)
- Python 3 + essential packages (requests, pytest, black, flake8, pylint, psutil)
- Git, curl, gcc build tools

Everything else installed on-demand via Claude with justification.

### Security Model
- Non-root execution (`coder` user)
- Passwordless sudo for necessary operations
- No exposed network ports
- Resource limits prevent system exhaustion
- Automated vulnerability scanning

## Critical Workflows

### Release Process
```bash
# Option 1: Using Makefile (recommended)
make release VERSION=1.4.2
git push && git push --tags

# Option 2: Manual process
echo "1.4.2" > VERSION
./scripts/update-version.sh
git add -A && git commit -m "🚀 Release v1.4.2"
git tag v1.4.2
git push && git push --tags
```
GitHub Actions automatically publishes to Docker Hub when tags are pushed.

### Emergency Fixes
- Cache-busting URL: `curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh?$(date +%s)" | bash`
- Version-pinned fallback: `curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/v1.4.1/run.sh | bash`

### Local Development Testing
```bash
# Quick validation (same as `make test`)
bash -n run.sh
docker-compose config --quiet

# Full integration test cycle
./run.sh  # Create container
docker exec -it CONTAINER_NAME claude --version
docker exec -it CONTAINER_NAME bash -c "cd /workspace && ls -la"

# Test ARM64 compatibility (if on ARM64 system)
docker run -it --platform linux/arm64 frednix/claude-sandbox:latest claude --version
```

### Key Architecture Insights
- **run.sh**: 4-tier image detection, TTY intelligence, platform-specific handling
- **Dockerfile**: Minimal core + on-demand installs via Claude interaction
- **Volume isolation**: Each container gets unique workspace via `${CONTAINER_NAME}_data`
- **CI/CD separation**: Regular pushes ≠ Docker Hub updates (only version tags trigger publishing)
- **Multi-arch**: Automated AMD64/ARM64 builds with platform-specific instructions