# 🤖 Docker Claude Sandbox

**Lightweight Docker container optimized for Claude Code development with essential toolset**

## ⚡ TLDR Quick Start

```bash
# Option 1: One command (downloads everything)
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash

# Option 2: Clone and run
git clone https://github.com/nixfred/docker-claude-sandbox.git
cd docker-claude-sandbox && docker-compose up -d && docker exec -it claude-sandbox bash

# Option 3: Direct docker-compose (most portable)
curl -O https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/{docker-compose.yml,Dockerfile}
docker-compose up -d && docker exec -it claude-sandbox bash
```

**What you get:** Ubuntu 22.04 + **Claude Code installed globally** + Node.js 18+ + Essential Python tools + Git + Network utilities + Persistent `/workspace`

## ✨ **OPTIMIZED FOR CLAUDE CODE**

**This container is specifically designed for Claude Code:**
- ✅ **Claude Code pre-installed globally** - Just run `claude-code` to start
- ✅ **Node.js 18+** - Required runtime for Claude Code
- ✅ **Essential Python stack** - Core libraries for development
- ✅ **Minimal footprint** - Only includes what Claude Code needs
- ✅ **Verbose build process** - See exactly what's being installed
- ✅ **No ports needed** - Claude Code is CLI-based, no networking required

---

## 🚀 Quick Start

That's it! The setup will:
- ✅ **Claude Code ready** - Pre-installed and ready to use
- ✅ **Portable configuration** - Standard docker-compose.yml approach
- ✅ **Essential Python stack** - Development tools without bloat
- ✅ **Network & system tools** - ssh, curl, git, and more
- ✅ **Self-contained environment** - No external dependencies
- ✅ **Security hardened** - Latest updates, non-root user
- ✅ **Verbose build process** - See every installation step

## 📁 Multiple Ways to Use

### Option 1: Direct Docker Compose (Recommended)
```bash
git clone https://github.com/nixfred/docker-claude-sandbox.git
cd docker-claude-sandbox
docker-compose up -d
docker exec -it claude-sandbox bash
```

### Option 2: With Setup Script
```bash
git clone https://github.com/nixfred/docker-claude-sandbox.git
cd docker-claude-sandbox
./run.sh
```

### Option 3: Download and Compose
```bash
curl -O https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/docker-compose.yml
curl -O https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/Dockerfile
docker-compose up -d
```

## ✨ Key Features

### 🛡️ **Claude Code Optimized Environment**
- **Claude Code pre-installed globally** - Ready to use immediately
- **Node.js 18+** - Required runtime environment
- Ubuntu 22.04 with latest security updates
- Essential Python stack (requests, pytest, black, flake8, pylint)
- Network tools (nmap, tcpdump, ssh, telnet, traceroute)
- System tools (neofetch, mc, htop, screen, tmux)
- Non-root `coder` user with sudo access

### 📊 **Portable Configuration**
- Standard docker-compose.yml for maximum portability
- No complex setup scripts required
- Version-controlled configuration
- Easy customization of ports and volumes
- CI/CD friendly

### 🤖 **Claude Code Ready**
When you enter the container, you get:
- **Claude Code installed globally** - Just run `claude-code`
- Automatic neofetch system information display
- Built-in help system (`help` command) showing all available tools
- Node.js 18+ runtime for Claude Code requirements
- Persistent `/workspace` directory for your code
- Pre-configured development environment

## 🎯 Essential Toolset for Claude Code

- **🤖 Claude Code**: Pre-installed globally - just run `claude` to start
- **⚡ Node.js 18+**: Required runtime environment for Claude Code
- **🛡️ Safe Environment**: Completely isolated from your host system
- **🐍 Essential Python Stack**: Python 3 + pip + requests, pytest, black, flake8, pylint
- **🔧 Development Tools**: git, vim, nano (essential editors only)
- **🌐 Network Tools**: curl, wget, ssh, ping (for git and package management)  
- **💾 Persistent Storage**: Your code survives container restarts in `/workspace`
- **🔌 No Ports**: Claude Code is CLI-based - no networking required

## 🏗️ Architecture

### 📦 **Portable Design**
- Standard docker-compose.yml with all configuration
- Self-contained Dockerfile with comprehensive toolset  
- Optional run.sh for convenience (downloads compose files)
- No external dependencies or complex setup

### 🔧 **Container Features**
- Ubuntu 22.04 base with security updates
- Non-root `coder` user with passwordless sudo
- Persistent `/workspace` volume for code storage
- Fixed container name `claude-sandbox` for consistency
- Built-in help system and neofetch display

## 📖 Usage Examples

### Inside the Container
```bash
# Start Claude Code
claude

# Show available tools
help

# Test Node.js and Python environment
node --version
python3 -c "import requests, pytest; print('Essential Python tools ready!')"

# Test connectivity
ping google.com

# Create and test code
cd /workspace
nano mycode.py
python3 mycode.py
```

### Claude Code Integration
1. **Enter the container**:
   ```bash
   docker exec -it claude-sandbox bash
   ```

2. **Start Claude Code**:
   ```bash
   # Claude Code is pre-installed globally
   claude
   ```

3. **Create and test code safely in your workspace**:
   ```bash
   # Your workspace persists between sessions
   cd /workspace
   nano my_script.py
   python3 my_script.py
   ```

4. **Use development tools**:
   ```bash
   # Format Python code
   black my_script.py
   
   # Run tests
   pytest
   
   # Test connectivity
   ping google.com
   ```

## 🔧 Container Management

```bash
# Standard docker-compose commands
docker-compose up -d          # Start container
docker-compose down           # Stop and remove container
docker-compose logs           # View logs
docker-compose build --no-cache  # Rebuild container

# Container access and status
docker exec -it claude-sandbox bash   # Enter container
docker ps | grep claude-sandbox       # Check status
docker logs claude-sandbox            # View container logs

# Volume management
docker volume ls | grep claude        # Check persistent volume
docker-compose down -v                # Remove container and volume
```

## 🌐 No Ports Required

Claude Code is a CLI tool that doesn't require any port mappings. The container runs in isolation without network services:

```bash
# Claude Code works entirely through the terminal
claude

# No ports needed - everything is command-line based
# If you need to test web applications, you can temporarily add ports to docker-compose.yml
```

## 📊 System Requirements

- **Docker** installed and running
- **4GB+ RAM** (recommended for larger projects)
- **2GB+ disk space** (for container and examples)

**Tested on:**
- ✅ Linux (Ubuntu, Debian, CentOS, Arch)
- ✅ macOS (Intel & Apple Silicon)
- ✅ Windows (with Docker Desktop)
- ✅ Raspberry Pi (ARM64)

## 🎯 Perfect For

- **Claude Code development** with pre-installed runtime and tools
- **Safe code testing** without affecting your host system
- **Learning new frameworks** in a clean, isolated environment  
- **Quick prototyping** with no setup hassle
- **Code review** of AI-generated code
- **Teaching/workshops** with consistent, reproducible environments
- **Cross-platform development** with guaranteed consistency

## 🚨 Troubleshooting

### **Docker Issues**
```bash
# Docker not found?
# Install: https://docs.docker.com/get-docker/

# Permission denied?
sudo usermod -aG docker $USER
# Then log out and back in

# Container won't start?
docker system prune  # Clean up
./run.sh --help      # Check options
```

### **Port Conflicts**
The V2 smart detection should handle this automatically, but if you still have issues:
```bash
# Check what's using ports
lsof -i :8000
netstat -tulpn | grep :8000

# Use different ports manually
# When prompted, enter: 8080,3001,8888
```

### **Container Access Issues**
```bash
# Can't enter container?
docker ps  # Check if running
docker logs claude-sandbox  # Check logs
docker exec -it claude-sandbox bash  # Force entry
```

## 💡 Pro Tips

### **Quick Access Alias**
Add to your `~/.bashrc` or `~/.zshrc`:
```bash
alias claude='docker exec -it claude-sandbox bash'
alias claude-logs='docker logs claude-sandbox'
alias claude-ports='docker port claude-sandbox'
```

### **VS Code Integration**
Install the "Dev Containers" extension and attach to the running container for a full IDE experience.

### **File Sharing**
```bash
# Copy files to container
docker cp myfile.py claude-sandbox:/workspace/

# Copy files from container  
docker cp claude-sandbox:/workspace/output.txt ./
```

## 🤝 Contributing

Found a bug? Have an idea? 

1. **Fork** the repository
2. **Create** a feature branch
3. **Test** with `./run.sh`
4. **Submit** a pull request

## 📄 License

MIT License - Use it however you want!

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/nixfred/docker-claude-sandbox/issues)
- **Discussions**: [GitHub Discussions](https://github.com/nixfred/docker-claude-sandbox/discussions)
- **Documentation**: This README + inline help (`help` command in container)

## 🎉 Quick Test

Ready to try it? Run this and be coding in 2 minutes:

```bash
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash
```

**Example session:**
```bash
🤖 Docker Claude Sandbox V2
🔍 Scanning for available ports...
✓ Found available ports: 8001 8002 8003

Container name [claude-sandbox]: ⏎
Workspace directory [workspace]: ⏎  
Ports to expose [8001,8002,8003]: ⏎
Auto-start container? [Y/n]: ⏎

🏗️ Building optimized Docker image...
🚀 Starting enhanced container...
🎉 Setup complete!

# You're now inside the container with:
# - Python 3 + popular packages
# - Node.js + development tools  
# - Persistent /workspace directory
# - Port forwarding configured
# - Claude AI integration guide

coder@claude-sandbox:/workspace$ help
# Shows comprehensive guide...
```

---

**Happy coding! 🚀**

*Built for testing Claude AI code safely, but perfect for any development project.*