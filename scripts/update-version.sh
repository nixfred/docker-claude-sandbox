#!/bin/bash
# Update version numbers across all documentation files
# This script reads from VERSION file and updates all references

set -e

# Read version from VERSION file
if [ ! -f "VERSION" ]; then
    echo "ERROR: VERSION file not found!"
    exit 1
fi

VERSION=$(cat VERSION)
echo "Updating all files to version: v${VERSION}"

# Update readme.md
echo "Updating readme.md..."
sed -i.bak "s/# 🤖 Docker Claude Sandbox v[0-9.]\+/# 🤖 Docker Claude Sandbox v${VERSION}/" readme.md
sed -i.bak "s/- \*\*Current version\*\*: v[0-9.]\+/- **Current version**: v${VERSION}/" readme.md
sed -i.bak "s/docker-claude-sandbox\/v[0-9.]\+\/run.sh/docker-claude-sandbox\/v${VERSION}\/run.sh/g" readme.md

# Update SECURITY.md
echo "Updating SECURITY.md..."
sed -i.bak "s/docker-claude-sandbox\/v[0-9.]\+\/run.sh/docker-claude-sandbox\/v${VERSION}\/run.sh/g" SECURITY.md

# Update contributing.md
echo "Updating contributing.md..."
sed -i.bak "s/v${VERSION}/v${VERSION}/g" contributing.md  # This is a no-op but keeps pattern

# Update AI_DEVELOPMENT_GUIDE.md
echo "Updating AI_DEVELOPMENT_GUIDE.md..."
sed -i.bak "s/## Project Overview - v[0-9.]\+ Status/## Project Overview - v${VERSION} Status/" AI_DEVELOPMENT_GUIDE.md
sed -i.bak "s/\*\*v[0-9.]\+ represents/**v${VERSION} represents/" AI_DEVELOPMENT_GUIDE.md

# Update claude.md
echo "Updating claude.md..."
sed -i.bak "s/## Architecture Overview - v[0-9.]\+ Production/## Architecture Overview - v${VERSION} Production/" claude.md
sed -i.bak "s/\*\*v[0-9.]\+ represents/**v${VERSION} represents/" claude.md

# Clean up backup files
rm -f *.bak */*.bak

echo "✅ Version update complete! All files now reference v${VERSION}"
echo ""
echo "Don't forget to:"
echo "1. Review the changes: git diff"
echo "2. Commit the version update"
echo "3. Tag the release: git tag v${VERSION}"