# 🤖 Docker Claude Sandbox

**Portable Docker container for safely testing Claude Code with comprehensive toolset**

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

**What you get:** Ubuntu 22.04 + Essential tools for Claude Code: Python, git, network tools (ssh, curl), system utilities + Persistent `/workspace`

## 🚧 **REFACTORING IN PROGRESS** 

**The container currently has bloat that needs removal:**
- Unnecessary web server examples and HTTP server code
- Excessive Python packages (matplotlib, seaborn, jupyter) not needed for Claude Code  
- Multiple port mappings when Claude Code may not need them
- Missing verbose build explanations for users
- Need to research what Claude Code actually requires

**Goal:** Strip down to clean Ubuntu + only tools Claude Code needs + verbose build process

---

## 🚀 Quick Start

That's it! The setup will:
- ✅ **Portable configuration** - Standard docker-compose.yml approach
- ✅ **Complete Python ecosystem** - Development tools, data science libraries
- ✅ **Network & TCP/IP tools** - nmap, tcpdump, ssh, and more
- ✅ **Self-contained environment** - No external dependencies
- ✅ **Security hardened** - Latest updates, non-root user
- ✅ **Drop you into Claude-ready environment**

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

### 🛡️ **Complete Development Environment**
- Ubuntu 22.04 with latest security updates
- Complete Python ecosystem (pandas, numpy, matplotlib, pytest, black, etc.)
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
- Automatic neofetch system information display
- Built-in help system (`help` command)
- Complete toolset for Claude Code operations
- Persistent `/workspace` directory for your code
- Pre-configured development environment

## 🎯 Complete Toolset

- **🛡️ Safe Environment**: Completely isolated from your host system
- **🐍 Complete Python Stack**: Python 3 + pip + pandas, numpy, matplotlib, seaborn, pytest, black, flake8, pylint
- **🔧 Development Tools**: git, vim, nano, mc (midnight commander), screen, tmux
- **🌐 Network & TCP/IP Tools**: nmap, tcpdump, ssh, telnet, traceroute, ping, wireshark-common, iptables
- **📊 System Tools**: neofetch, htop, lsof, ps, netstat, build-essential, cmake  
- **💾 Persistent Storage**: Your code survives container restarts in `/workspace`
- **🔌 Standard Ports**: 8000, 8001, 8002 exposed for your applications
- **📋 Health Monitoring**: Built-in Docker health checks

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
# Show system info and available tools
neofetch
help

# Test Python environment
python3 -c "import pandas, numpy, matplotlib; print('All Python tools ready!')"

# File management with midnight commander
mc

# Network scanning
nmap -sn 192.168.1.0/24

# Create and test code
cd /workspace
nano mycode.py
python3 mycode.py

# Start a simple web server
python3 -m http.server 8000
# Access at http://localhost:8000
```

### Claude Code Integration
1. **Enter the container**:
   ```bash
   docker exec -it claude-sandbox bash
   ```

2. **Create and test code safely**:
   ```bash
   # Your workspace persists between sessions
   cd /workspace
   nano my_script.py
   python3 my_script.py
   ```

3. **Use development tools**:
   ```bash
   # Format Python code
   black my_script.py
   
   # Run tests
   pytest
   
   # Network diagnostics
   ping google.com
   tcpdump -i any
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

## 🌐 Port Access

The container exposes three standard ports:

```bash
# Your services will be available at:
http://localhost:8000    # Primary port
http://localhost:8001    # Secondary port  
http://localhost:8002    # Additional port

# Test port access
curl http://localhost:8000
python3 -m http.server 8001  # Start simple server
```

To customize ports, modify the `ports` section in docker-compose.yml.

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

- **Testing Claude AI code** safely without affecting your system
- **Learning new frameworks** in a clean environment  
- **Quick prototyping** with no setup hassle
- **Code review** of AI-generated code
- **Teaching/workshops** with consistent environments
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