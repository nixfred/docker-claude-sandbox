# Docker Hub Setup Guide

This guide explains how to set up Docker Hub publishing for the Docker Claude Sandbox project.

## Current Status

✅ **GitHub Actions workflow configured**
✅ **Docker Hub credentials added to repository secrets**
❌ **Docker Hub repository needs to be created manually**

## Issue Resolution

The GitHub Actions workflow failed with `401 Unauthorized` because the Docker Hub repository `frednix/claude-sandbox` doesn't exist yet. Unlike GitHub, Docker Hub requires repositories to be created manually before pushing.

## Manual Steps Required

### Step 1: Create Docker Hub Repository

1. **Login to Docker Hub**:
   - Go to https://hub.docker.com/
   - Login with username: `frednix`

2. **Create Repository**:
   - Click "Create Repository"
   - Repository name: `claude-sandbox`
   - Full name will be: `frednix/claude-sandbox`
   - Description: "Cross-platform Docker container optimized for Claude Code development"
   - Visibility: **Public** (recommended for open source)
   - Click "Create"

### Step 2: Verify Repository Settings

Once created, the repository should be accessible at:
- **URL**: https://hub.docker.com/r/frednix/claude-sandbox
- **Pull command**: `docker pull frednix/claude-sandbox:latest`

### Step 3: Re-trigger GitHub Actions

After creating the repository:

```bash
# Re-run the failed workflow or create a new tag
git tag -f v1.4.0  # Force update tag
git push --tags --force

# Or create a new patch version
echo "1.4.1" > VERSION
./scripts/update-version.sh
git add -A && git commit -m "🔧 Fix Docker Hub repository setup - v1.4.1"
git tag v1.4.1
git push && git push --tags
```

## Expected Results After Setup

Once the repository is created and the workflow re-runs:

✅ **Multi-arch builds** (linux/amd64, linux/arm64)
✅ **Docker Hub publishing** to `frednix/claude-sandbox:latest`
✅ **GitHub Container Registry** publishing to `ghcr.io/nixfred/docker-claude-sandbox:latest`
✅ **Automated testing** of published images
✅ **README updates** with Docker Hub links

## Alternative: GitHub Container Registry Only

If Docker Hub setup is delayed, users can still access pre-built images:

```bash
# This works immediately (GitHub Container Registry)
docker pull ghcr.io/nixfred/docker-claude-sandbox:latest
docker run -it ghcr.io/nixfred/docker-claude-sandbox:latest
```

## Troubleshooting

### Common Issues

**401 Unauthorized Error**:
- Repository doesn't exist on Docker Hub → Create manually (Step 1 above)
- Invalid token → Check DOCKERHUB_TOKEN secret format
- Wrong username → Verify DOCKERHUB_USERNAME secret

**Repository Name Mismatch**:
- Workflow expects: `frednix/claude-sandbox`
- Must match exactly in Docker Hub

**Token Permissions**:
- Docker Hub token needs push permissions
- Token format: `dckr_pat_XXXXXXXXXX`

### Verification Commands

```bash
# Test local Docker Hub login
echo "YOUR_DOCKER_TOKEN" | docker login --username frednix --password-stdin

# Check if repository exists
curl -s "https://hub.docker.com/v2/repositories/frednix/claude-sandbox/"

# List GitHub repository secrets
gh secret list
```

## Next Steps

1. **Create Docker Hub repository** (manual step above)
2. **Re-trigger workflow** to complete publishing
3. **Update documentation** to reflect Docker Hub availability
4. **Test published images** across platforms

Once completed, users will have two options:
- **Docker Hub**: `docker pull frednix/claude-sandbox:latest` (fastest)
- **GitHub Registry**: `docker pull ghcr.io/nixfred/docker-claude-sandbox:latest` (backup)

This provides redundancy and follows best practices for container distribution.