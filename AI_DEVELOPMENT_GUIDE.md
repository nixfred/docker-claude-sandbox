# AI Development Guide for Docker Claude Sandbox

This document provides a comprehensive guide for AI assistants to understand, develop, modify, and maintain the Docker Claude Sandbox project from first principles.

## Project Overview - v1.4.2 Status

The Docker Claude Sandbox is a **production-ready**, cross-platform containerized environment specifically designed for Claude Code development. **v1.4.2 represents a mature, tested system** with extensive validation across multiple platforms and critical bug fixes.

**🏆 Quality Assurance**: All features are automatically validated through comprehensive CI/CD pipeline with multi-platform testing and security scanning.

**Current Status**:
- ✅ **Tested and validated** on Linux ARM64 (Raspberry Pi), Linux x86_64, macOS Apple Silicon
- ✅ **Cross-platform compatibility** with intelligent platform-specific adaptations
- ✅ **Robust error handling** with comprehensive fallback strategies
- ✅ **Automated CI/CD validation** - All tests passing across multiple platforms
- ✅ **Production-grade quality** with continuous integration ensuring reliability

**Core Features**:
- **Ubuntu 22.04 base** with Claude Code pre-installed globally
- **Node.js 20+ runtime** (required for Claude Code operation)
- **Python 3 development stack** with essential packages
- **Cross-platform optimizations** (macOS buildx fixes, Colima support)
- **Intelligent TTY handling** (auto-entry vs manual commands)
- **Persistent workspace** that survives container restarts and rebuilds
- **Security-focused design** (non-root execution with appropriate permissions)

## Architecture Components

### Core Files

1. **`Dockerfile`** - Container definition
   - Base: Ubuntu 22.04 with security updates
   - User: Non-root `coder` with passwordless sudo
   - Claude Code: Globally installed with Node.js runtime
   - Python: Essential packages (requests, pytest, black, flake8, pylint)
   - Welcome message: Displayed on container entry

2. **`docker-compose.yml`** - Container orchestration
   - Service name: `claude-sandbox`
   - Volume: `claude_sandbox_data` mounted to `/workspace`
   - Environment: `TERM=xterm-256color`
   - No port mappings (Claude Code is CLI-based)

3. **`run.sh`** - Intelligent setup and deployment script (449 lines)
   - **Cross-platform compatibility** (Linux/macOS, ARM64/x86_64)
   - **Advanced TTY detection** with 3-level checking
   - **4-tier image detection** with robust fallback strategies
   - **Container name customization** with conflict resolution
   - **Platform-specific optimizations** (macOS buildx, Colima fixes)
   - **Auto-entry logic** (Linux auto-enters, macOS provides commands)

4. **`README.md`** - User documentation
   - Quick start instructions
   - Feature overview
   - Usage examples
   - Troubleshooting guide

5. **`CLAUDE.md`** - AI assistant instructions
   - Development guidelines
   - Architecture details
   - Common commands
   - v1.0 testing validation results

## Known Issues and Technical Debt (v1.2.7)

**✅ MAJOR FIXES COMPLETED**: Critical issues from v1.0-v1.2.1 have been resolved:

### RECENTLY FIXED (v1.2.1)
- **Volume Collision Bug**: ✅ FIXED - Each container now gets isolated workspace volume
- **Node.js Compatibility**: ✅ FIXED - Upgraded to Node.js 20+ for npm compatibility  
- **Documentation Inconsistencies**: ✅ FIXED - All docs now reference Node.js 20+

### REMAINING HIGH PRIORITY ITEMS  
- **Help text outdated**: ✅ FIXED - All documentation now consistently references Node.js 20+
- **Hardcoded timezone**: ✅ FIXED - Auto-detection implemented with timedatectl  
- **Container configuration in run.sh**: ✅ FIXED - Enhanced with timezone detection and better portability

### MEDIUM PRIORITY ENHANCEMENTS  
- **No Docker health checks**: Uses 60-second manual wait instead
- **Missing progress indicators**: ✅ FIXED - Added comprehensive progress indicators for build, download, and readiness
- **Redundant downloads**: Script downloads docker-compose.yml but uses docker run  

### MEDIUM PRIORITY BUGS

**4. Redundant Redirection (run.sh:38)**
```bash
if ! docker info &> /dev/null 2>&1; then
```
**Problem**: `&> /dev/null` already redirects both stdout/stderr, `2>&1` is redundant  
**Fix**: Use just `&> /dev/null` OR `> /dev/null 2>&1`  

**5. Container Readiness Timeout (run.sh:283)**
```bash
for i in {1..30}; do
```
**Problem**: 30 seconds may be insufficient for slow systems or first-time pulls  
**Fix Strategy**: Increase timeout or make configurable  

**6. Image ID Ambiguity (run.sh:214-217)**
```bash
IMAGE_NAME=$(docker images --format "{{.Repository}}:{{.Tag}}" --filter "id=$IMAGE_NAME" | head -1)
```
**Problem**: If multiple images share layer IDs, could return wrong image  
**Likelihood**: Low, but possible with complex build scenarios  

### LOW PRIORITY ISSUES

**7. Claude Code Installation Verification Missing (Dockerfile:48)**
```bash
npm install -g @anthropic-ai/claude-code
```
**Problem**: No verification that installation succeeded  
**Fix Strategy**: Add verification step with claude --version  

**8. Security Risk: Piping curl to bash (Dockerfile:45)**
```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
```
**Problem**: Classic security anti-pattern  
**Mitigation**: This is Node.js official installation method  
**Alternative**: Download, verify, then execute  

**9. Hardcoded Workspace Path (Dockerfile:86)**
```bash
echo 'cd /${WORKSPACE}' >> /home/coder/.bashrc
```
**Problem**: Uses variable substitution that may not work as expected  
**Impact**: Minor - workspace navigation  

**10. Environment Variable Mismatch (docker-compose.yml:17)**
```yaml
- CONTAINER_NAME=claude-sandbox
```
**Problem**: Hardcoded value doesn't match dynamic container names  
**Impact**: Potential confusion about actual container name  

### LEGACY ARCHITECTURAL DECISIONS (Pre-v1.2.1)

**11. Volume Sharing by Design** - ✅ FIXED in v1.2.1
**Previous Behavior**: All containers shared `claude_sandbox_data` volume  
**Fixed**: Each container now gets isolated workspace via `${CONTAINER_NAME}_data` external volumes
**Impact**: No more data corruption between containers  

**12. Platform-Specific TTY Behavior**
**Linux**: Auto-enters container after setup  
**macOS**: Provides manual entry commands  
**Status**: This is correct behavior, not a bug  
**Reason**: macOS Docker TTY allocation differs from Linux  

## Key Design Principles

### 1. Minimal Installation Philosophy
- **Include ONLY essentials**: Claude Code, Node.js, Python basics, Git, curl
- **Everything else on-demand**: Users ask Claude to install what they need
- **Justification required**: "Install vim because I need to edit files"

### 2. Cross-Platform Compatibility
- **macOS fixes**: Buildx compatibility, credential helper issues
- **TTY detection**: Works with both `curl | bash` and local execution
- **Dynamic paths**: No hardcoded assumptions about system layout

### 3. User Experience Focus
- **One-command setup**: `curl -fsSL URL | bash`
- **Beautiful welcome message**: Clear instructions on container entry
- **Container name customization**: Interactive prompting with defaults
- **Auto-entry**: Script enters container automatically after setup

## Technical Implementation Details

### TTY Detection Logic
```bash
# Correct method for piped execution
if [ -c /dev/tty ]; then
    echo -n "Container name [claude-sandbox]: " > /dev/tty
    read CONTAINER_NAME < /dev/tty
else
    # Fallback for no-tty environments
    CONTAINER_NAME="claude-sandbox"
fi
```

### macOS Compatibility Fixes
```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    export DOCKER_BUILDKIT=0  # Disable buildx
    export COMPOSE_DOCKER_CLI_BUILD=0
    
    # Handle Colima credential issues
    if command -v colima >/dev/null 2>&1; then
        # Remove credsStore from Docker config temporarily
        export DOCKER_CONFIG=/tmp/docker-claude-sandbox
    fi
fi
```

### Dynamic Image Naming
```bash
# Detect built image name from docker-compose
IMAGE_NAME=$(docker-compose config 2>/dev/null | grep 'image:' | awk '{print $2}' | head -1)
if [ -z "$IMAGE_NAME" ]; then
    # Fallback: construct from directory name
    DIR_NAME=$(basename "$PWD")
    IMAGE_NAME="${DIR_NAME}_claude-sandbox:latest"
fi
```

### Container Readiness Check
```bash
# Proper readiness check instead of fixed sleep
for i in {1..30}; do
    if docker exec "$CONTAINER_NAME" echo "ready" >/dev/null 2>&1; then
        break
    fi
    sleep 1
done
```

## Common Development Tasks

### 1. Modifying the Welcome Message
**Location**: `Dockerfile` (lines with `echo` commands in RUN instruction)
```dockerfile
RUN echo 'echo "    ╔══════════════════════════════════════════════════════════════════╗"' >> /home/coder/.bashrc && \
    echo 'echo "    ║    🤖 Claude Code Sandbox Ready!                                ║"' >> /home/coder/.bashrc
```

### 2. Adding Software to Container
**Location**: `Dockerfile` (in the main RUN instruction)
```dockerfile
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    # Add new packages here \
    your-new-package \
    && rm -rf /var/lib/apt/lists/*
```

### 3. Fixing TTY Issues
**Problem**: Script fails with "input device is not a TTY"
**Solution**: Use `/dev/tty` redirection for interactive prompts
```bash
# Wrong way
read -p "Prompt: " VARIABLE

# Correct way
echo -n "Prompt: " > /dev/tty
read VARIABLE < /dev/tty
```

### 4. Container Naming Issues
**Problem**: Container name conflicts or hardcoded names
**Solution**: Use dynamic naming with conflict resolution
```bash
# Check for existing container
if docker ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
    # Handle conflict with user prompt
fi
```

### 5. macOS Docker Issues
**Problem**: buildx errors, credential helper failures
**Solution**: Apply macOS-specific compatibility fixes
```bash
if [[ "$OSTYPE" == "darwin"* ]]; then
    export DOCKER_BUILDKIT=0
    # Handle credential helper issues
fi
```

## Testing Procedures

### 1. Local Testing
```bash
# Test script locally
./run.sh

# Test with custom container name
./run.sh
# Enter custom name when prompted

# Test container rebuild
docker-compose down -v
docker-compose build --no-cache
./run.sh
```

### 2. Remote Testing (curl | bash)
```bash
# Test the one-liner install
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash

# Test with cache busting (see CDN section below)
curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh?$(date +%s)" | bash
```

### 3. Cross-Platform Testing
```bash
# Test on different systems
# Linux: Ubuntu, Debian, CentOS, Arch
# macOS: Intel and Apple Silicon
# Windows: WSL2 environments
```

## GitHub CDN Cache Issues

### Problem
GitHub's CDN (raw.githubusercontent.com) aggressively caches files, causing delays of 10-20 minutes before updates are visible to users.

### Solution: Cache-Busting Parameter
```bash
# Add timestamp to force cache bypass
curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh?$(date +%s)" | bash

# Or use random number
curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh?bust=$RANDOM" | bash

# For testing specific commit
curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/COMMIT_HASH/run.sh" | bash
```

## Error Handling Patterns

### 1. Graceful Degradation
```bash
# Check if command exists before using
if command -v jq >/dev/null 2>&1; then
    # Use jq for JSON parsing
else
    # Fallback method
fi
```

### 2. Clear Error Messages
```bash
if ! mkdir -p "$PROJECT_DIR"; then
    echo -e "${RED}❌ Failed to create directory: $PROJECT_DIR${NC}"
    exit 1
fi
```

### 3. Atomic Operations
```bash
# Ensure operations complete fully or fail cleanly
docker run -d \
    --name "$CONTAINER_NAME" \
    # ... other options
    "$IMAGE_NAME" || exit 1
```

## Security Considerations

### 1. Non-Root User
- Container runs as `coder` user, not root
- Passwordless sudo available when needed
- Home directory: `/home/coder`

### 2. No Exposed Ports
- Claude Code is CLI-based, no network services
- Container isolated from host network by default

### 3. Minimal Attack Surface
- Only essential packages installed
- Security updates applied during build
- Additional software installed on-demand

## Debugging Techniques

### 1. Container Issues
```bash
# Check container status
docker ps -a
docker logs CONTAINER_NAME

# Enter container for debugging
docker exec -it CONTAINER_NAME bash

# Check resource usage
docker stats CONTAINER_NAME
```

### 2. Build Issues
```bash
# Verbose build output
docker-compose build --no-cache --progress=plain

# Build without cache
docker build --no-cache -t debug-image .

# Inspect build layers
docker history IMAGE_NAME
```

### 3. Script Issues
```bash
# Debug mode
bash -x run.sh

# Check specific functions
bash -c "source run.sh; check_requirements"
```

## Performance Optimization

### 1. Build Time
- Use multi-stage builds if needed
- Order RUN instructions by frequency of change
- Combine RUN commands to reduce layers
- Use `.dockerignore` to exclude unnecessary files

### 2. Runtime Performance
- Minimal base image (Ubuntu 22.04)
- Essential packages only
- Efficient container startup
- Persistent volume for workspace

### 3. Network Efficiency
- Download configurations once
- Use local caching where possible
- Minimize external dependencies during runtime

## Maintenance Guidelines

### 1. Regular Updates
- Update base image versions
- Update Node.js version as needed
- Update Python packages
- Security patches

### 2. Documentation Updates
- Keep README.md synchronized with features
- Update CLAUDE.md with new patterns
- Maintain version numbers in comments

### 3. Testing Matrix
- Test on multiple Linux distributions
- Test macOS Intel and Apple Silicon
- Test WSL2 environments
- Validate both interactive and non-interactive modes

## Common Pitfalls for AI Assistants

### 1. TTY Detection
**Wrong**: Using `[ -t 0 ]` for piped execution
**Right**: Using `[ -c /dev/tty ]` and redirecting to `/dev/tty`

### 2. Hardcoded Paths
**Wrong**: Assuming specific directory structures
**Right**: Dynamic detection and user-configurable paths

### 3. macOS Compatibility
**Wrong**: Ignoring platform-specific Docker issues
**Right**: Detecting OS and applying appropriate fixes

### 4. Container Naming
**Wrong**: Using hardcoded container names
**Right**: User-configurable names with conflict resolution

### 5. Error Handling
**Wrong**: Silent failures or unclear error messages
**Right**: Clear feedback and graceful degradation

## Integration Points

### 1. FeNix Ecosystem Integration
- `sclaw` alias for quick access
- Compatible with FeNix multi-host architecture
- Maintains separation of concerns

### 2. Claude Code Optimization
- Pre-installed runtime environment
- Persistent workspace for CLAUDE.md files
- Minimal footprint with extensibility

### 3. Development Workflow
- Git integration for version control
- Docker Hub compatibility
- CI/CD friendly architecture

This guide provides the foundation for any AI assistant to understand, maintain, and extend the Docker Claude Sandbox project effectively.