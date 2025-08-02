---
name: Bug report
about: Create a report to help us improve Docker Claude Sandbox
title: '[BUG] '
labels: bug
assignees: ''

---

## 🐛 Bug Description
A clear and concise description of what the bug is.

## 💻 Environment Information
**Operating System and Architecture:**
- [ ] Linux ARM64 (e.g., Raspberry Pi)
- [ ] Linux x86_64 (e.g., Ubuntu, Debian, Fedora)
- [ ] macOS Intel
- [ ] macOS Apple Silicon
- [ ] Other: ___________

**Docker Information:**
- Docker version: [Run `docker --version`]
- docker-compose version: [Run `docker-compose --version`]
- Docker running method:
  - [ ] Docker Desktop
  - [ ] Colima (macOS)
  - [ ] Native Docker (Linux)
  - [ ] Other: ___________

**Container Details:**
- Container name used: ___________
- Version attempted: [e.g., v1.2.2, main branch, commit hash]

## 🔄 Steps to Reproduce
1. Go to '...'
2. Run command '....'
3. See error

## 🎯 Expected Behavior
A clear and concise description of what you expected to happen.

## ❌ Actual Behavior
A clear and concise description of what actually happened.

## 📋 Error Messages
```bash
# Paste full error messages here
# Include command output, Docker logs, etc.
```

## 🔍 Additional Context
- Is this a fresh installation or existing setup?
- Did this work before? If so, what changed?
- Any custom configurations applied?
- Screenshots if applicable

## 🧪 Troubleshooting Attempted
- [ ] Tried cache-busting URL: `curl -fsSL "https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh?$(date +%s)" | bash`
- [ ] Checked Docker is running: `docker info`
- [ ] Tried with different container name
- [ ] Checked available disk space
- [ ] Reviewed existing issues
- [ ] Tried `docker system prune -f` and rebuild

## 📝 Additional Information
Add any other context about the problem here.