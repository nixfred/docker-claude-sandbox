# Security Policy

## Supported Versions

We actively maintain and provide security updates for the following versions:

| Version | Supported          | Status |
| ------- | ------------------ | ------ |
| v1.2.x  | :white_check_mark: | Current stable release |
| v1.1.x  | :x:                | No longer supported |
| v1.0.x  | :x:                | No longer supported |

**Recommendation**: Always use the latest version from the `main` branch for the most current security fixes.

## Security Considerations

### Script Distribution Security

Docker Claude Sandbox uses the common `curl | bash` installation pattern:
```bash
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash
```

**Security measures in place:**
- All scripts are publicly auditable on GitHub
- HTTPS-only distribution (encrypted in transit)
- Scripts perform validation before execution
- Non-root container execution by default
- No network exposure (Claude Code is CLI-based)

### Container Security

- **Non-root execution**: Containers run as `coder` user, not root
- **Isolated workspace**: Each container gets isolated volume storage
- **Minimal attack surface**: Only essential packages installed
- **No exposed ports**: Containers don't expose network services
- **Security updates**: Base Ubuntu image updated during build

### Known Security Characteristics

**What Docker Claude Sandbox does:**
- Downloads and executes shell scripts from GitHub
- Builds Docker containers with development tools
- Installs Node.js and Python packages via package managers
- Creates isolated development environments

**What Docker Claude Sandbox does NOT do:**
- Connect to external services (beyond package downloads)
- Store or transmit user data
- Require elevated privileges beyond Docker access
- Expose network ports or services

## Reporting Security Vulnerabilities

**We take security seriously.** If you discover a security vulnerability, please report it responsibly.

### How to Report

**For security issues, please do NOT use public GitHub issues.**

Instead, report security vulnerabilities by:

1. **Email**: Send details to the project maintainer
2. **GitHub Security Advisories**: Use GitHub's private vulnerability reporting
3. **Direct message**: Contact maintainers through GitHub

### What to Include

Please provide the following information:
- **Description**: Clear description of the vulnerability
- **Impact**: Potential impact and attack scenarios  
- **Reproduction**: Step-by-step instructions to reproduce
- **Environment**: Platform, Docker version, and system details
- **Proposed fix**: If you have suggestions for remediation

### Response Timeline

- **Initial response**: Within 48 hours
- **Investigation**: Within 7 days for assessment
- **Fix timeline**: Varies by severity, typically 14-30 days
- **Public disclosure**: After fix is released and users have time to update

### Severity Guidelines

**Critical**: Remote code execution, privilege escalation
**High**: Local privilege escalation, data exposure
**Medium**: Information disclosure, denial of service
**Low**: Minor issues with limited impact

## Security Best Practices for Users

### Installation Security

**Recommended secure installation:**
```bash
# 1. Review the script first
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | less

# 2. Use version-pinned installation for production
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/v1.4.1/run.sh | bash

# 3. Or clone and review locally
git clone https://github.com/nixfred/docker-claude-sandbox.git
cd docker-claude-sandbox
# Review files, then:
./run.sh
```

### Runtime Security

**Secure usage practices:**
- Keep Docker updated to latest version
- Use non-root Docker access (add user to docker group)
- Regularly update containers: `docker system prune && ./run.sh`
- Don't store sensitive data in container workspace
- Use separate containers for different projects/clients

### Environment Security

**System security recommendations:**
- Keep host system updated
- Use firewalls to restrict Docker daemon access
- Consider using rootless Docker for additional isolation
- Monitor Docker resource usage
- Use dedicated development machines when possible

## Security Development Process

### Code Review Requirements

All changes undergo security review:
- Shell script analysis for command injection
- Dockerfile review for security best practices
- Dependency analysis for known vulnerabilities
- Cross-platform security testing

### Automated Security Measures

- **Static analysis**: Scripts analyzed for security issues
- **Dependency scanning**: Regular checks for vulnerable dependencies
- **Container scanning**: Base images scanned for vulnerabilities
- **Supply chain**: All downloads verified from official sources

## Disclosure Policy

### Responsible Disclosure

We follow responsible disclosure practices:
1. Security researchers report vulnerabilities privately
2. We investigate and develop fixes
3. Fixes are released in new versions
4. Public disclosure occurs after users can update
5. Credit given to security researchers (with permission)

### Public Security Information

- Security advisories published for all confirmed vulnerabilities
- Version-specific security information in CHANGELOG.md
- Security-related commits clearly marked in git history
- Documentation updated to reflect security improvements

## Contact Information

**Security contact**: Use GitHub's Security tab to report vulnerabilities privately.

**General contact**: For non-security issues, use [GitHub Issues](https://github.com/nixfred/docker-claude-sandbox/issues).

---

**Last updated**: December 2024  
**Policy version**: 1.0

Thank you for helping keep Docker Claude Sandbox secure for everyone!