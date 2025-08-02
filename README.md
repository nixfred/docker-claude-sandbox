# 🤖 Docker Claude Sandbox v1.2.3

![Version](https://img.shields.io/github/v/release/nixfred/docker-claude-sandbox?label=version&color=blue)
![License](https://img.shields.io/github/license/nixfred/docker-claude-sandbox?color=green)
![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS-lightgrey)
![Docker](https://img.shields.io/badge/docker-required-blue)
![Architecture](https://img.shields.io/badge/arch-ARM64%20%7C%20x86__64-green)
![Node.js](https://img.shields.io/badge/node.js-20%2B-brightgreen)
![Docker Pulls](https://img.shields.io/docker/pulls/nixfred/claude-sandbox?color=blue)
![GitHub Issues](https://img.shields.io/github/issues/nixfred/docker-claude-sandbox?color=red)
![GitHub Stars](https://img.shields.io/github/stars/nixfred/docker-claude-sandbox?style=social)

**Cross-platform Docker container optimized for Claude Code development**

## 🚀 Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash
```

**What you get:** Ubuntu 22.04 + **Claude Code pre-installed** + Node.js 20+ + Python 3 + Git + Persistent workspace

## 🧪 Tested and Validated Platforms

### Linux Distributions
- ✅ **Ubuntu 22.04 ARM64** (Raspberry Pi 5)
- ✅ **Ubuntu 22.04 x86_64** (Standard servers)
- ✅ **Linux Mint Intel x86_64** (Full desktop installation)
- ✅ **Ubuntu in Parallels** (Virtual machine environment)
- ✅ **Debian-based distributions** (apt package manager)
- ✅ **Fedora/RHEL/CentOS** (dnf package manager)
- ✅ **Arch/Manjaro** (pacman package manager)

### macOS Environments  
- 🟡 **macOS Intel** (Should work - Docker Desktop + Colima compatibility)
- ✅ **macOS Apple Silicon** (Native ARM64 support)

### Virtualization & Containers
- ✅ **Parallels Desktop** (Ubuntu guest on macOS host)
- ✅ **Docker Desktop** (All platforms)
- ✅ **Colima** (macOS Docker alternative)

### Architecture Support
- ✅ **ARM64/aarch64** (Raspberry Pi, Apple Silicon)
- ✅ **x86_64/amd64** (Intel/AMD processors)

**Legend**: ✅ Tested and confirmed working | 🟡 Should work but untested

All ✅ combinations tested with Node.js 20, Claude Code installation, and container functionality.

## 📋 System Requirements

- **Docker** 20.10+ with daemon running
- **docker-compose** 2.0+ or docker-compose standalone
- **2+ GB free disk space** for Ubuntu base + dependencies
- **Internet connection** for initial build and package downloads
- **Terminal with TTY support** for optimal experience

### 🐳 Installing Docker

If Docker is not installed, use these commands:

#### Ubuntu/Debian/Linux Mint
```bash
sudo apt update
sudo apt install -y docker.io docker-compose
sudo usermod -aG docker $USER
newgrp docker
```

#### Fedora/RHEL/CentOS
```bash
sudo dnf install -y docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker
```

#### Arch/Manjaro
```bash
sudo pacman -S docker docker-compose
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
newgrp docker
```

#### Official Docker Engine (All Distributions)
For the latest Docker Engine: https://docs.docker.com/engine/install/

**Note:** After installation, log out and back in or run `newgrp docker` to apply group membership.

## 🛠️ Alternative Installation Methods

### Git Clone Method
```bash
git clone https://github.com/nixfred/docker-claude-sandbox.git
cd docker-claude-sandbox
./run.sh
```

### Version-Pinned Install
```bash
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/v1.2.3/run.sh | bash
```

### Cache-Busting Install (Force Latest)
```bash
curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh?$(date +%s)" | bash
```

## ✨ Features

### Core Development Environment
- 🤖 **Claude Code pre-installed globally** - Run `claude` to start
- ⚡ **Node.js 20+ runtime** - Required for Claude Code operation
- 🐍 **Python 3 development stack** - Essential packages included
- 📝 **Git version control** - Ready for repository work
- 🔧 **Build tools included** - gcc for compiling native packages

### Smart Platform Adaptation
- 🖥️ **Cross-platform compatibility** - Linux, macOS, ARM64, x86_64
- 🍎 **macOS optimizations** - Buildx fixes, Colima credential handling
- 🐧 **Linux native support** - Optimized for all major distributions
- 📱 **TTY intelligence** - Adapts behavior based on terminal capabilities

### User Experience Excellence
- 🎨 **Beautiful welcome banner** - Clear usage instructions
- 📂 **Persistent workspace** - `/workspace` survives container restarts
- 🏷️ **Custom container names** - User-defined container naming
- 🔄 **Intelligent image detection** - Handles all Docker naming patterns
- 🛡️ **Non-root security** - Runs as `coder` user with sudo access

### Developer-Friendly Design
- 📦 **Minimal base** - Only essentials included, extend through Claude
- 🚀 **Fast startup** - Optimized build process with caching
- 🧹 **Easy cleanup** - Simple container removal and reset
- 📚 **Comprehensive docs** - Including AI assistant integration guide

## 🎯 Welcome Experience

Upon entering the container, you'll see:
```
╔══════════════════════════════════════════════════════════════════╗
║    🤖 Claude Code Sandbox Ready!                                ║
║    🚀 Start Claude Code: claude                                 ║
║    📦 Need software? Tell Claude why you need it!               ║
║    ✅ Available: Node.js, Python3, Git, curl, apt, sudo        ║
╚══════════════════════════════════════════════════════════════════╝
```

**Philosophy**: Ask Claude to install additional tools with justification:
- *"Install vim because I need to edit configuration files"*
- *"Install htop because I need to monitor system resources"*
- *"Install ssh because I need to clone private repositories"*

## 🚀 Usage

### Setup Flow
1. **Run the script** - Downloads config, builds container, prompts for name
2. **Enter container name** - Custom name or press Enter for default  
3. **Automatic build** - Handles platform-specific optimizations
4. **Smart entry** - Auto-enters container or provides manual commands

### Platform-Specific Behavior
**Linux**: Script auto-enters container after setup
```bash
./run.sh
# Enter container name: myproject
# → Automatically drops you into container shell
```

**macOS**: Script provides manual entry commands  
```bash
./run.sh
# Enter container name: myproject
# → Shows: docker exec -it myproject bash
```

### Access Your Container
```bash
# Start Claude Code directly (one command!)
docker exec -it YOUR_CONTAINER_NAME claude

# Or enter the container shell
docker exec -it YOUR_CONTAINER_NAME bash

# Quick health check
docker logs YOUR_CONTAINER_NAME
```

### Inside the Container
```bash
# Start Claude Code
claude

# Check versions
node --version    # Verify Node.js 20+
python3 --version # Verify Python 3
git --version     # Verify Git

# Persistent workspace
cd /workspace
# All files here survive container restarts!

# Install additional software through Claude:
# "Install vim because I need to edit configuration files"
# "Install docker because I need to build images inside the container"
```

## 🔧 Container Lifecycle Management

### Daily Operations
```bash
# Check if container is running
docker ps --filter "name=YOUR_CONTAINER_NAME"

# Stop container (preserves workspace data)
docker stop YOUR_CONTAINER_NAME

# Restart existing container
docker start YOUR_CONTAINER_NAME

# Remove container completely
docker rm -f YOUR_CONTAINER_NAME
```

### Maintenance Operations
```bash
# Rebuild with latest updates
cd /path/to/docker-claude-sandbox
docker-compose build --no-cache
./run.sh

# Clean up old images
docker system prune -f

# Reset everything (nuclear option)
docker-compose down -v  # Removes volumes too!
docker system prune -af
```

### Multiple Container Management
```bash
# Run multiple instances with different names
./run.sh  # Name: project-a
./run.sh  # Name: project-b  
./run.sh  # Name: testing-env

# Each gets its own isolated environment
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

## 💡 Integration Examples

### Quick Access Function
Add to your `~/.bashrc` or `~/.zshrc`:
```bash
claude-dev() {
    local container_name="${1:-claude-sandbox}"
    if ! docker ps --format "{{.Names}}" | grep -q "^${container_name}$"; then
        echo "Starting $container_name..."
        docker start "$container_name" 2>/dev/null || {
            echo "Container $container_name not found. Run ./run.sh first."
            return 1
        }
        sleep 2
    fi
    docker exec -it "$container_name" bash -c "cd /workspace && claude"
}

# Usage: claude-dev myproject
```

### VS Code Integration
```bash
# Install Dev Containers extension, then:
docker exec -it YOUR_CONTAINER_NAME bash -c "cd /workspace && code ."
```

### CI/CD Pipeline Example
```yaml
# .github/workflows/test.yml
- name: Setup Claude Code Environment
  run: |
    curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/v1.2.3/run.sh | bash
    docker exec claude-sandbox claude --version
```

## 📦 What's Included

### Pre-installed Software
- **🤖 Claude Code**: Latest version, globally accessible via `claude` command
- **⚡ Node.js 20+**: Required runtime environment for Claude Code
- **🐍 Python 3**: Core interpreter with essential development packages
- **📝 Git**: Version control system for repository management
- **🌐 curl**: Network tool for downloads and API calls
- **🔧 Build essentials**: gcc compiler for native package compilation

### Python Packages
- **Core libraries**: requests, urllib3, certifi
- **Development tools**: pytest, black, flake8, pylint
- **Configuration**: pyyaml, toml
- **System utilities**: psutil

### System Configuration
- **🛡️ Security**: Non-root `coder` user with passwordless sudo
- **🎨 Shell**: Customized bash prompt and welcome banner
- **📂 Workspace**: Persistent `/workspace` directory
- **🌍 Locale**: UTF-8 environment with proper timezone handling

## 🎯 Use Cases

### Development Scenarios
- **🧪 Claude Code experimentation** - Safe environment for AI-assisted coding
- **🔬 Code prototyping** - Isolated testing without affecting host system
- **📚 Learning environment** - Consistent setup for tutorials and workshops
- **🏢 Team development** - Standardized environment across team members

### Professional Applications  
- **🔄 CI/CD integration** - Reproducible environment for automated testing
- **📱 Cross-platform development** - Same environment on Linux, macOS, ARM64, x86_64
- **🚀 Quick onboarding** - New developers productive immediately
- **🐛 Bug reproduction** - Clean environment for isolating issues

### Educational Use
- **👨‍🏫 Teaching environments** - Consistent setup for students
- **📖 Documentation testing** - Verify instructions work in clean environment
- **🎓 Workshop preparation** - Pre-configured environment for events

## 🚨 Troubleshooting

### Common Issues and Solutions

**Script fails with "Docker not running"**
```bash
# Start Docker service
sudo systemctl start docker  # Linux
open -a Docker            # macOS Docker Desktop
colima start              # macOS Colima
```

**macOS: "buildx not found" error**
```bash
# Fixed automatically by script, but if manual fix needed:
export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0
```

**Container won't start after build**
```bash
# Check container status
docker ps -a --filter "name=YOUR_CONTAINER_NAME"

# View detailed logs
docker logs YOUR_CONTAINER_NAME

# Force rebuild
docker system prune -f
./run.sh
```

**"Input device is not a TTY" error**
```bash
# Use specific commit to bypass CDN cache
curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/v1.2.2/run.sh" | bash

# Or clone locally
git clone https://github.com/nixfred/docker-claude-sandbox.git
cd docker-claude-sandbox && ./run.sh
```

**Multiple containers sharing workspace**
- ⚠️ **Known behavior**: All containers currently share the same workspace volume
- 🔧 **Workaround**: Use different directories or remove old containers before creating new ones
- 📋 **Planned fix**: Individual volumes per container name

### Reset Everything (Nuclear Option)
```bash
# Remove all containers and volumes
docker system prune -af
docker volume prune -f

# Fresh start
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash
```

## 🔍 Architecture Details

For technical implementation details, see:
- **[CLAUDE.md](CLAUDE.md)** - Development guidelines and architecture
- **[AIINSTALL.md](AIINSTALL.md)** - Comprehensive AI assistant guide

## 🏷️ Version Information

- **Current version**: v1.2.3
- **Tested platforms**: Linux ARM64/x86_64, macOS Apple Silicon (Intel untested)  
- **Docker compatibility**: 20.10+, Buildx optional
- **Base image**: Ubuntu 22.04 LTS

## 📄 License

MIT License - See [LICENSE](LICENSE) for details.

## 🤝 Contributing

Issues, bug reports, and feature requests welcome at [GitHub Issues](https://github.com/nixfred/docker-claude-sandbox/issues).

---

## 🚀 Get Started Now

```bash
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash
```

**Experience the future of AI-assisted development in a safe, isolated environment.**

*This project makes Claude Code development accessible, reliable, and consistent across all platforms.*