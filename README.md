# 🤖 Docker Claude Sandbox V2

**Enhanced one-command Docker container for safely testing Claude AI code**

## 🚀 Instant Start

```bash
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash
```

That's it! The enhanced script will:
- ✅ **Smart port detection** - Automatically avoids conflicts
- ✅ **Ask 4 quick questions** - With intelligent defaults  
- ✅ **Latest security updates** - Includes `apt upgrade -y`
- ✅ **Build optimized container** - Clean, secure, fast
- ✅ **Comprehensive setup report** - Know exactly what you have
- ✅ **Drop you into Claude-ready environment**

## 📁 Or Clone & Run

```bash
git clone https://github.com/nixfred/docker-claude-sandbox.git
cd docker-claude-sandbox
./run.sh
```

## ✨ What's New in V2

### 🔍 **Smart Port Detection**
- Automatically scans ports 8000-9000 for availability
- Finds 3 open ports and suggests them
- No more "port already in use" errors!
- Falls back to safe defaults if needed

### 🛡️ **Enhanced Security & Updates**
- Runs `apt upgrade -y` for latest security patches
- Optimized container image (removes apt cache, temp files)
- Non-root user (`coder`) for security
- Health checks for container monitoring

### 📊 **Comprehensive Startup Report**
When you enter the container, you get a detailed report:
- System information (OS, Python, Node.js versions)
- Storage details (workspace volume info)
- Network mapping (all port forwards)
- Pre-installed tools inventory
- Step-by-step next steps guide

### 🤖 **Claude AI Integration Guide**
Clear instructions for connecting to Claude:
- Where to get Claude AI code (https://claude.ai)
- How to test code safely in the container
- Web development workflow with port forwarding
- Best practices for AI code testing

## 🎯 What You Get

- **🛡️ Safe Environment**: Completely isolated from your host system
- **🐍 Python Ready**: Python 3 + pip + popular packages (requests, flask, pandas, numpy, matplotlib, jupyter, pytest)
- **🟢 Node.js Ready**: Node.js + npm + popular packages (express, nodemon, pm2, typescript, ts-node)
- **🔧 Dev Tools**: git, vim, nano, curl, wget, htop, tree, cmake, build-essential
- **💾 Persistent Storage**: Your code survives container restarts
- **🌐 Smart Port Forwarding**: Automatic conflict detection and resolution
- **📋 System Monitoring**: Built-in health checks and status reporting

## 🎨 Enhanced Features

### 🎭 **Visual Experience**
- Beautiful ASCII art banners
- Animated progress bars during setup
- Color-coded output for better readability
- Enhanced welcome screen with system info

### 🏗️ **Improved Architecture**
- Multi-stage optimized Dockerfile
- Better docker-compose configuration
- Structured workspace directories (`/workspace/{python,javascript,web,scratch}`)
- Enhanced error handling and user guidance

### 🚀 **Developer Experience**
- Helpful aliases (`py`, `serve`, `ll`, `help`)
- Quick test function (`test-env`)
- Enhanced examples with better error handling
- Comprehensive help system

## 📖 Usage Examples

### Quick Start in Container
```bash
# Test the environment
python3 /examples/hello.py
node /examples/hello.js

# Create your own code
cd /workspace
nano mycode.py
py mycode.py

# Start a web server  
serve 8000
# Access at http://localhost:<detected-port>
```

### Test Claude AI Code
1. **Get Code from Claude**:
   - Go to https://claude.ai
   - Ask Claude to write code for you
   - Copy the code Claude provides

2. **Test Code Safely**:
   ```bash
   # In the container
   nano claude_code.py
   # Paste Claude's code
   py claude_code.py
   ```

3. **Web Development**:
   ```bash
   # Create a web app
   nano app.py
   # Paste Claude's Flask/FastAPI code
   py app.py
   # Access at http://localhost:<your-port>
   ```

## 🔧 Container Management

```bash
# View container status and ports
docker ps | grep claude-sandbox

# Access the container
docker exec -it claude-sandbox bash

# View comprehensive logs
docker logs claude-sandbox

# Stop container
docker stop claude-sandbox

# Start existing container
docker start claude-sandbox

# Complete cleanup
docker-compose down && docker system prune
```

## 🌐 Port Management

The V2 smart port detection automatically handles port conflicts:

```bash
# Example output:
🔍 Scanning for available ports...
✓ Found available ports: 8001 8002 8003

# Your services will be available at:
http://localhost:8001  # Primary web server
http://localhost:8002  # Secondary service  
http://localhost:8003  # Additional service
```

If you have many services running, the system will find the first available ports and configure everything automatically.

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