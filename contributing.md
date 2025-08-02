# Contributing to Docker Claude Sandbox

Thank you for your interest in contributing to Docker Claude Sandbox! This document provides guidelines for contributing to the project.

## 🚀 Quick Start for Contributors

### Prerequisites
- Docker 20.10+ with daemon running
- docker-compose 2.0+
- Git for version control
- Basic knowledge of Bash scripting and Dockerfile

### Development Setup
```bash
# Fork and clone the repository
git clone https://github.com/YOUR_USERNAME/docker-claude-sandbox.git
cd docker-claude-sandbox

# Test the current setup
./run.sh

# Make your changes...

# Test your changes
./run.sh --help  # Test help functionality
docker-compose build --no-cache  # Test build process
```

## 📋 Current Known Issues & Development Tasks

### 🔴 High Priority Issues
- **Help text outdated** - ✅ FIXED - All documentation now references Node.js 20+
- **Container configuration in run.sh** - Should move logic to Dockerfile for better portability
- **Hardcoded timezone** - ✅ FIXED - Auto-detects user timezone with timedatectl fallback to UTC

### 🟡 Medium Priority Issues  
- **Redundant docker-compose download** - Script downloads but uses `docker run` instead
- **Manual container readiness** - Uses 60-second spinning wait instead of proper Docker health checks
- **No input validation feedback** - Container name validation could be more user-friendly
- **Missing progress indicators** - ✅ FIXED - Added comprehensive progress indicators with emojis and spinners
- **No security documentation** - ✅ FIXED - Added comprehensive SECURITY.md with vulnerability reporting
- **No PR template** - ✅ FIXED - Added detailed .github/PULL_REQUEST_TEMPLATE.md
- **No CI/CD pipeline** - ✅ FIXED - Added comprehensive GitHub Actions workflow with multi-platform testing (ALL TESTS PASSING)

### 🟢 Low Priority Enhancements
- **Environment customization** - ✅ IMPLEMENTED - Auto-detects local timezone, uses fixed `/workspace` path
- **No resource limits** - Containers can consume unlimited CPU/memory
- **Package versions unpinned** - Could cause reproducibility issues

### 🎯 v1.3.0 Roadmap: "Self-Contained & Bulletproof"
The goal is to create a standalone Docker image that works without external scripts or dependencies.

## 🐛 Reporting Issues

### Before Reporting
1. Check existing [GitHub Issues](https://github.com/nixfred/docker-claude-sandbox/issues)
2. Test with the latest version: 
   ```bash
   curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh?v=$(date +%s)" | bash
   ```
3. Check the [troubleshooting guide](claude.md#troubleshooting-guide)

### Issue Template
Please include:
- **OS and architecture** (e.g., Ubuntu 22.04 ARM64, macOS Intel)
- **Docker version** (`docker --version`)
- **Container name used**
- **Full error message**
- **Steps to reproduce**
- **Expected vs actual behavior**

## 🔧 Development Guidelines

### Code Standards
- **Bash**: Follow existing indentation and error handling patterns
- **Docker**: Use multi-stage builds when possible, minimize image layers
- **Documentation**: Update readme.md and claude.md for significant changes
- **Testing**: Test on multiple platforms (Linux ARM64/x86_64, macOS)

### Versioning (SemVer)
Every commit must update version in 3 locations:
1. `run.sh` line 2: `# Docker Claude Sandbox - Portable One-Command Setup v1.3.0`
2. `run.sh` thank you messages: `Thank you for using Docker Claude Sandbox v1.3.0` (2 locations)
3. `readme.md` line 1: `# 🤖 Docker Claude Sandbox v1.3.0`

**Version Format**: `vMAJOR.MINOR.PATCH`
- **MAJOR**: Breaking changes affecting existing users
- **MINOR**: New features (backward compatible)  
- **PATCH**: Bug fixes, small improvements, documentation

### Testing Requirements
Before submitting a PR:
```bash
# Test configuration validation
export CONTAINER_NAME="test123" && docker-compose config --quiet

# Test cross-platform compatibility  
./run.sh --help  # Should show current Node.js version

# Test volume isolation (if applicable)
# Create test containers with different names and verify separate volumes

# Test cleanup
docker system prune -f
```

## 📝 Pull Request Process

### Before Submitting
1. **Create an issue** describing the problem/enhancement
2. **Fork the repository** and create a feature branch
3. **Test thoroughly** on your platform
4. **Update documentation** (readme.md, claude.md if needed)
5. **Follow version increment** requirements above

### PR Template
- **Description**: What does this PR do?
- **Issue**: Link to related GitHub issue
- **Testing**: What platforms did you test on?
- **Breaking changes**: Any changes that affect existing users?
- **Documentation**: What docs were updated?

### Review Criteria
- ✅ Code follows existing patterns and standards
- ✅ Changes are tested on multiple platforms
- ✅ Version numbers are properly incremented  
- ✅ Documentation is updated appropriately
- ✅ No breaking changes without major version bump

## 🔗 Resources

- **Main documentation**: [claude.md](claude.md) - Technical implementation details
- **AI Development**: [AI_DEVELOPMENT_GUIDE.md](AI_DEVELOPMENT_GUIDE.md) - Complete AI assistant guide
- **User guide**: [readme.md](readme.md) - Installation and usage
- **Issues**: [GitHub Issues](https://github.com/nixfred/docker-claude-sandbox/issues)
- **Releases**: [GitHub Releases](https://github.com/nixfred/docker-claude-sandbox/releases)

## 🏆 Recently Fixed Issues

### v1.2.1 - Volume Collision Bug (CRITICAL)
**Problem**: Multiple containers shared the same workspace volume, causing data corruption.
**Solution**: Implemented external volumes with dynamic naming in docker-compose.yml
**Impact**: Each container now gets isolated workspace data

### v1.2.0 - Node.js Compatibility
**Problem**: npm version conflicts with Node.js 18 (upgraded to Node.js 20)
**Solution**: Upgraded to Node.js 20 in Dockerfile
**Impact**: Compatible with latest npm versions

### v1.1.x - User Experience Improvements
- Simplified welcome message (removed Unicode issues)
- Added one-command Claude access: `docker exec -it CONTAINER claude`
- Implemented professional SemVer versioning system
- Comprehensive cross-platform testing validation

## 💡 Contributing Ideas

Looking for ways to help? Consider:
- **Platform testing**: Test on new Linux distributions
- **Documentation**: Improve setup instructions or troubleshooting
- **Performance**: Optimize Docker build times or image size
- **User experience**: Better error messages or progress indicators
- **Security**: Review and improve container security practices

---

**Questions?** Open an issue or check the [technical documentation](claude.md) for implementation details.