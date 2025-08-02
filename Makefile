# Docker Claude Sandbox Makefile
# Simplifies common development tasks

# Read version from VERSION file
VERSION := $(shell cat VERSION)

.PHONY: help version update-version build test release

help:
	@echo "Docker Claude Sandbox Development Commands:"
	@echo "  make version       - Show current version"
	@echo "  make update-version - Update version in all files" 
	@echo "  make build        - Build Docker image"
	@echo "  make test         - Run CI tests locally"
	@echo "  make release      - Create a new release (updates version, commits, tags)"

version:
	@echo "Current version: v$(VERSION)"

update-version:
	@./scripts/update-version.sh

build:
	docker-compose build

test:
	@echo "Running local tests..."
	@bash -n run.sh && echo "✅ Bash syntax OK"
	@docker-compose config --quiet && echo "✅ docker-compose.yml OK"

# Usage: make release VERSION=1.3.3
release:
	@if [ -z "$(VERSION)" ]; then \
		echo "ERROR: Please specify VERSION=x.x.x"; \
		exit 1; \
	fi
	@echo "Creating release v$(VERSION)..."
	@echo $(VERSION) > VERSION
	@./scripts/update-version.sh
	@git add -A
	@git commit -m "🚀 Release v$(VERSION)"
	@git tag -a v$(VERSION) -m "Release v$(VERSION)"
	@echo "✅ Release v$(VERSION) created!"
	@echo "Don't forget to: git push && git push --tags"