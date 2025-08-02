# Docker Hub Repository Description

## Short Description (100 characters max)
```
Cross-platform Docker container with Claude Code pre-installed. Ready-to-use AI development environment.
```
*Character count: 99/100*

## Recommended Categories
**Primary**: Developer Tools  
**Secondary**: Application Frameworks, Programming Languages

## Full Description
```markdown
# 🤖 Claude Code Sandbox

**Cross-platform Docker container optimized for Claude Code development**

## 🚀 Quick Start

```bash
# Most systems (auto-detects architecture)
docker run -it --rm frednix/claude-sandbox:latest

# ARM64 systems (Raspberry Pi, Apple Silicon)
docker run -it --rm --platform linux/arm64 frednix/claude-sandbox:latest

# x86_64 systems  
docker run -it --rm --platform linux/amd64 frednix/claude-sandbox:latest
```

## ✨ What's Included

- **🤖 Claude Code**: Pre-installed and ready to use
- **⚡ Node.js 20+**: Required runtime for Claude Code
- **🐍 Python 3**: Development stack with essential packages
- **📂 Persistent workspace**: `/workspace` survives container restarts
- **🛡️ Non-root security**: Runs as `coder` user with sudo access

## 🧪 Tested Platforms

✅ **Multi-Architecture Support**
- linux/amd64 (Intel/AMD processors)
- linux/arm64 (Raspberry Pi, Apple Silicon)

✅ **Validated Environments**
- Ubuntu, Debian, Fedora, Arch Linux
- macOS (Intel & Apple Silicon)
- Docker Desktop, Colima

## 🔧 Common Commands

**Temporary containers (recommended):**
```bash
# One command - opens container immediately
docker run -it --rm frednix/claude-sandbox:latest
# Then inside: claude
```

**Persistent containers:**
```bash
# Create named container
docker run -it --name my-project frednix/claude-sandbox:latest

# Access later
docker start my-project && docker exec -it my-project bash
```

## 📋 Troubleshooting

**ARM64 Platform Issues:**
```bash
# Use explicit platform if auto-detection fails
docker run -it --rm --platform linux/arm64 frednix/claude-sandbox:latest
```

**Multiple Containers:**
```bash
# Temporary: Open multiple terminals
docker run -it --rm frednix/claude-sandbox:latest

# Persistent: Use unique names
docker run -it --name project-a frednix/claude-sandbox:latest
docker run -it --name project-b frednix/claude-sandbox:latest
```

## 🔗 Links

- **GitHub Repository**: https://github.com/nixfred/docker-claude-sandbox
- **Documentation**: https://github.com/nixfred/docker-claude-sandbox/blob/main/readme.md
- **Issues/Support**: https://github.com/nixfred/docker-claude-sandbox/issues

## 📊 Tags

- `latest` - Most recent stable version
- `v1.4.1` - Current release version
- `1.4`, `1` - Semantic version aliases

## 🏆 Quality Assurance

- ✅ Automated CI/CD testing across multiple platforms
- ✅ Security scanning with Trivy and Dependabot
- ✅ Multi-architecture builds validated on every release
- ✅ Production-ready with comprehensive documentation

**Start developing with Claude Code in under 30 seconds!**
```

## Tags to Add on Docker Hub

Add these tags when editing the repository:
- claude-code
- ai-development
- nodejs
- python
- ubuntu
- multi-arch
- arm64
- amd64
- development-environment
- containerized-ai
- claude-ai
- anthropic
```