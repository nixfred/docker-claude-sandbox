# Branch Protection Configuration

This document outlines the branch protection rules for the Docker Claude Sandbox repository to ensure code quality and prevent breaking changes.

## 🛡️ Main Branch Protection Rules

### Required Status Checks
- ✅ **CI Workflow** (`ci.yml`) - All tests must pass
- ✅ **Docker Build** (`docker-build.yml`) - Multi-arch builds must succeed
- ✅ **Security Scanning** - No critical vulnerabilities allowed

### Pull Request Requirements
- ✅ **Require pull request reviews** - At least 1 approving review
- ✅ **Dismiss stale reviews** - When new commits are pushed
- ✅ **Require review from CODEOWNERS** - For critical files
- ✅ **Restrict pushes** - Only allow merges via pull requests

### Merge Requirements
- ✅ **Require branches to be up to date** - Must be current with main
- ✅ **Require linear history** - Squash or rebase merges only
- ✅ **Delete head branches** - Clean up after merge

### Administrative Restrictions
- ✅ **Restrict force pushes** - Prevent history rewriting
- ✅ **Restrict deletions** - Prevent accidental branch deletion
- ✅ **Include administrators** - Even admins must follow rules

## 📋 CODEOWNERS File

Critical files require review from repository maintainers:

```
# Global fallback
* @nixfred

# Core infrastructure files
Dockerfile @nixfred
docker-compose.yml @nixfred
run.sh @nixfred

# Version management system
VERSION @nixfred
scripts/update-version.sh @nixfred
Makefile @nixfred

# CI/CD workflows
.github/workflows/ @nixfred

# Documentation requiring technical review
CLAUDE.md @nixfred
AI_DEVELOPMENT_GUIDE.md @nixfred
SECURITY.md @nixfred
```

## ⚙️ GitHub CLI Setup Commands

To configure these rules via GitHub CLI:

```bash
# Enable branch protection for main branch
gh api repos/:owner/:repo/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["CI","Docker Multi-Arch Build"]}' \
  --field enforce_admins=true \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
  --field restrictions=null

# Configure merge restrictions
gh api repos/:owner/:repo/branches/main/protection \
  --method PATCH \
  --field allow_squash_merge=true \
  --field allow_merge_commit=false \
  --field allow_rebase_merge=true \
  --field delete_branch_on_merge=true
```

## 🔍 Manual Configuration Steps

1. **Repository Settings** → **Branches** → **Add Rule**
2. **Branch name pattern**: `main`
3. **Enable settings**:
   - ☑️ Require a pull request before merging
   - ☑️ Require approvals (1)
   - ☑️ Dismiss stale PR approvals when new commits are pushed
   - ☑️ Require review from CODEOWNERS
   - ☑️ Require status checks to pass before merging
   - ☑️ Require branches to be up to date before merging
   - ☑️ Require linear history
   - ☑️ Include administrators
   - ☑️ Restrict pushes that create files larger than 100MB
   - ☑️ Allow force pushes: **DISABLED**
   - ☑️ Allow deletions: **DISABLED**

4. **Required status checks**:
   - `CI`
   - `Docker Multi-Arch Build`

## 🎯 Benefits

✅ **Code Quality**: All changes reviewed and tested  
✅ **Security**: No direct pushes to main branch  
✅ **Reliability**: CI must pass before merge  
✅ **Professional**: Industry-standard GitHub workflow  
✅ **Documentation**: Clear process for contributors  
✅ **Automation**: Enforced automatically by GitHub

## 🚀 Implementation

Once configured, this ensures:
- All code changes go through pull requests
- Automated testing validates every change
- Multi-arch Docker builds must succeed
- Security scanning prevents vulnerabilities
- Consistent code quality and review process