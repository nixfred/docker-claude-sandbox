# 🤖 Docker Claude Sandbox

**Lightweight Docker container optimized for Claude Code development**

## ⚡ Quick Start

**Option 1: One command (downloads everything)**
```bash
curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh?$(date +%s)" | bash
```

**Option 2: FeNix Users - Ultimate Convenience**
```bash
# If you have FeNix, just run this from anywhere:
sclaw
```

**Option 3: Clone and run**
```bash
git clone https://github.com/nixfred/docker-claude-sandbox.git
cd docker-claude-sandbox && ./run.sh
```

**What you get:** Ubuntu 22.04 + **Claude Code pre-installed** + Node.js 18+ + Essential Python tools + Persistent `/workspace`

## ✨ Features

**This container is specifically designed for Claude Code:**
- ✅ **Claude Code pre-installed globally** - Just run `claude` to start
- ✅ **Node.js 18+** - Required runtime for Claude Code
- ✅ **Essential Python stack** - Core libraries for development (requests, pytest, black, flake8, pylint)
- ✅ **Minimal footprint** - Only includes what Claude Code needs
- ✅ **No ports needed** - Claude Code is CLI-based

## 🎯 Welcome Experience

When you enter the container, you get a beautiful welcome message:
```
╔══════════════════════════════════════════════════════════════════╗
║    🤖 Claude Code Sandbox Ready!                               ║
║    🚀 Start Claude Code: claude                                 ║
║    📦 Need software? Tell Claude why you need it!               ║
║    ✅ Available: Node.js, Python3, Git, curl, apt, sudo        ║
╚══════════════════════════════════════════════════════════════════╝
```

## 🚀 Usage

### Quick Access with FeNix
```bash
sclaw  # From anywhere - starts container and enters Claude Code
```

### Manual Access
```bash
# Enter container and start Claude Code
docker exec -it claude-sandbox bash -c "cd /workspace && claude"

# Or just enter container
docker exec -it claude-sandbox bash
```

### Inside the Container
```bash
# Start Claude Code
claude

# Your workspace persists between sessions
cd /workspace

# Ask Claude to install tools as needed:
# "Install vim because I need to edit files"
# "Install ssh because I need to clone repos" 
# "Install htop because I need to monitor processes"
```

## 🔧 Container Management

```bash
# Start container
docker-compose up -d

# Stop container
docker-compose down

# View logs
docker-compose logs

# Rebuild container
docker-compose build --no-cache
```

## 💡 Quick Access Alias

**For FeNix Users:**
The `sclaw` function is automatically available.

**For Others:**
Add to your `~/.bashrc`:
```bash
sclaw() {
    cd /path/to/docker-claude-sandbox
    if ! docker ps --format "{{.Names}}" | grep -q "claude-sandbox"; then
        docker-compose up -d
        sleep 2
    fi
    docker exec -it claude-sandbox bash -c "cd /workspace && claude"
}
```

## 📋 What's Included

- **Claude Code**: Pre-installed globally
- **Node.js 18+**: Required runtime
- **Python 3**: With essential packages (requests, pytest, black, flake8, pylint)
- **Git**: Version control
- **curl**: For downloads
- **apt & sudo**: For installing additional software through Claude

## 🎯 Perfect For

- **Claude Code development** with pre-installed runtime
- **Safe code testing** without affecting your host system
- **Learning and prototyping** in an isolated environment
- **Consistent development** across different machines

## 🚨 Troubleshooting

```bash
# Container won't start?
docker system prune -f

# Can't enter container?
docker ps  # Check if running
docker logs claude-sandbox  # Check logs

# Rebuild from scratch
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

## 📄 License

MIT License

---

**Ready to try it?**

```bash
curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh?$(date +%s)" | bash
```

*Built specifically for running Claude Code safely in an isolated environment.*