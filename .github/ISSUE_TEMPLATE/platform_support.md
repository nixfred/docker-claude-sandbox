---
name: Platform support request
about: Report platform compatibility issues or request support for new platforms
title: '[PLATFORM] '
labels: platform, enhancement
assignees: ''

---

## 🖥️ Platform Information
**Platform requesting support for:**
- Operating System: ___________
- Architecture: ___________
- Version: ___________
- Docker installation method: ___________

## 🔍 Current Status
**What happens when you try to run Docker Claude Sandbox?**
- [ ] Script fails to download
- [ ] Docker build fails
- [ ] Container won't start
- [ ] Container starts but Claude Code doesn't work
- [ ] Partial functionality
- [ ] Works but with warnings/issues
- [ ] Untested but should work

## 📋 Error Details
```bash
# Paste any error messages here
```

## 🧪 Testing Information
**What testing have you done?**
- [ ] Tried basic installation: `curl -fsSL URL | bash`
- [ ] Tested Claude Code functionality inside container
- [ ] Tested with different container names
- [ ] Verified Docker and docker-compose versions
- [ ] Checked platform-specific Docker setup

**Docker environment details:**
```bash
# Output of: docker --version

# Output of: docker-compose --version

# Output of: docker info | head -20
```

## 🎯 Expected Support Level
**What level of support are you expecting?**
- [ ] Full official support with testing
- [ ] Basic compatibility (works but not officially tested)
- [ ] Documentation on how to make it work
- [ ] Just confirm if it should work or not

## 🤝 Contribution Availability
**Are you able to help with testing?**
- [ ] Yes, I can test changes on this platform
- [ ] Yes, I can provide environment access for testing
- [ ] Yes, I can help with platform-specific fixes
- [ ] No, I can only report issues

## 📝 Additional Context
- How common is this platform in your environment?
- Any specific requirements or constraints?
- Links to platform documentation if relevant