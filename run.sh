#!/bin/bash
# Docker Claude Sandbox - Portable One-Command Setup v2.0 - Updated 2025-08-02 01:40
# Usage: curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Banner
show_banner() {
    echo -e "${BLUE}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║    🤖 Docker Claude Sandbox                                  ║
    ║    Self-contained Ubuntu environment for Claude Code         ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Check requirements
check_requirements() {
    local missing_tools=""
    
    # Check for Docker
    if ! command -v docker &> /dev/null; then
        missing_tools="docker"
    else
        # Docker exists, check if daemon is running
        if ! docker info &> /dev/null 2>&1; then
            echo -e "${YELLOW}⚠️  Docker is installed but not running${NC}"
            echo ""
            echo "Please start the Docker service and try again."
            echo ""
            exit 1
        fi
    fi
    
    # Check for docker-compose
    if ! command -v docker-compose &> /dev/null; then
        if [ -n "$missing_tools" ]; then
            missing_tools="$missing_tools and docker-compose"
        else
            missing_tools="docker-compose"
        fi
    fi
    
    # Report missing tools
    if [ -n "$missing_tools" ]; then
        echo -e "${RED}❌ Missing required tools: $missing_tools${NC}"
        echo ""
        echo "This project requires both Docker and docker-compose to run."
        echo "Please install the missing tools and try again."
        echo ""
        echo "Thank you! 😊"
        echo ""
        exit 1
    fi
    
    # All good!
    echo -e "${GREEN}✓ Docker is ready${NC}"
    echo -e "${GREEN}✓ docker-compose is ready${NC}"
}

# Download portable configuration files
download_config() {
    local base_url="https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main"
    
    echo -e "${CYAN}📥 Downloading portable configuration...${NC}"
    
    # Download docker-compose.yml
    if ! curl -fsSL "$base_url/docker-compose.yml" -o docker-compose.yml; then
        echo -e "${RED}❌ Failed to download docker-compose.yml${NC}"
        exit 1
    fi
    
    # Download Dockerfile
    if ! curl -fsSL "$base_url/Dockerfile" -o Dockerfile; then
        echo -e "${RED}❌ Failed to download Dockerfile${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Configuration files downloaded${NC}"
}

# Setup project directory (simplified)
setup_project_directory() {
    local current_dir=$(pwd)
    local suggested_dir="$HOME/claude-sandbox"
    
    # If not already in a directory with config files, use recommended directory
    if [ ! -f "docker-compose.yml" ] || [ ! -f "Dockerfile" ]; then
        PROJECT_DIR="$suggested_dir"
        if [ ! -d "$PROJECT_DIR" ]; then
            echo -e "${CYAN}📁 Creating project directory: $PROJECT_DIR${NC}"
            if ! mkdir -p "$PROJECT_DIR"; then
                echo -e "${RED}❌ Failed to create directory: $PROJECT_DIR${NC}"
                exit 1
            fi
        fi
        echo -e "${GREEN}✓ Using project directory: $PROJECT_DIR${NC}"
        if ! cd "$PROJECT_DIR"; then
            echo -e "${RED}❌ Failed to enter directory: $PROJECT_DIR${NC}"
            exit 1
        fi
        echo ""
    fi
}

# Ask for container name
ask_container_name() {
    echo -e "${CYAN}🐳 Container Configuration${NC}"
    echo "==============================="
    echo ""
    
    # Always prompt for container name, even in non-interactive mode
    # Use /dev/tty to read directly from terminal
    if [ -c /dev/tty ]; then
        echo -n "Container name [claude-sandbox]: " > /dev/tty
        read CONTAINER_NAME < /dev/tty
        CONTAINER_NAME=${CONTAINER_NAME:-claude-sandbox}
    else
        # Fallback if no tty available
        echo "No terminal available - using default container name"
        CONTAINER_NAME="claude-sandbox"
    fi
    
    echo -e "${GREEN}✓ Container name: $CONTAINER_NAME${NC}"
    echo ""
}

# Main execution
main() {
    show_banner
    check_requirements
    
    # Handle local vs remote execution
    if [ -f "docker-compose.yml" ] && [ -f "Dockerfile" ]; then
        echo -e "${GREEN}✓ Found local configuration files${NC}"
    else
        setup_project_directory
        download_config
    fi
    
    ask_container_name
    
    # Check for existing container and handle conflict
    if docker ps -a --format "{{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        echo -e "${YELLOW}⚠️  Container '$CONTAINER_NAME' already exists${NC}"
        if [ -c /dev/tty ]; then
            echo -n "Remove existing container? [y/N]: " > /dev/tty
            read REMOVE_EXISTING < /dev/tty
            if [[ "$REMOVE_EXISTING" =~ ^[Yy]$ ]]; then
                echo -e "${CYAN}🗑️  Removing existing container...${NC}"
                docker rm -f "$CONTAINER_NAME" || true
            else
                echo -e "${RED}❌ Cannot proceed with existing container${NC}"
                exit 1
            fi
        else
            echo -e "${CYAN}🗑️  Auto-removing existing container in non-interactive mode...${NC}"
            docker rm -f "$CONTAINER_NAME" || true
        fi
    fi
    
    echo -e "${CYAN}🏗️  Building Claude Sandbox container...${NC}"
    
    # macOS/Colima compatibility fixes
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo -e "${YELLOW}🍎 Detected macOS - applying compatibility fixes...${NC}"
        export DOCKER_BUILDKIT=0
        export COMPOSE_DOCKER_CLI_BUILD=0
        
        # Fix credential helper issue with Colima
        if command -v colima >/dev/null 2>&1 && ! command -v docker-credential-desktop >/dev/null 2>&1; then
            echo -e "${YELLOW}   Disabling Docker Desktop credential helper for Colima...${NC}"
            export DOCKER_CONFIG_PATH="$HOME/.docker/config.json"
            if [ -f "$DOCKER_CONFIG_PATH" ]; then
                # Temporarily disable credential helpers while preserving contexts
                if grep -q "credsStore" "$DOCKER_CONFIG_PATH" 2>/dev/null; then
                    echo -e "${YELLOW}   Creating temporary Docker config without credential store...${NC}"
                    mkdir -p /tmp/docker-claude-sandbox
                    # Copy entire .docker directory but modify config.json
                    cp -r "$HOME/.docker"/* /tmp/docker-claude-sandbox/ 2>/dev/null || true
                    # Remove credential store from config while keeping everything else
                    if command -v jq >/dev/null 2>&1; then
                        jq 'del(.credsStore)' "$DOCKER_CONFIG_PATH" > /tmp/docker-claude-sandbox/config.json 2>/dev/null
                    else
                        grep -v '"credsStore"' "$DOCKER_CONFIG_PATH" > /tmp/docker-claude-sandbox/config.json 2>/dev/null || \
                        echo '{}' > /tmp/docker-claude-sandbox/config.json
                    fi
                    export DOCKER_CONFIG=/tmp/docker-claude-sandbox
                fi
            fi
        fi
    fi
    
    docker-compose build || exit 1
    
    echo -e "${CYAN}🚀 Starting Claude Sandbox...${NC}"
    
    # Get the actual built image name dynamically
    echo -e "${CYAN}🔍 Detecting built image name...${NC}"
    
    # First try to get from docker-compose images command
    IMAGE_NAME=$(docker-compose images -q claude-sandbox 2>/dev/null | head -1)
    if [ -n "$IMAGE_NAME" ]; then
        # Convert image ID to actual name
        IMAGE_NAME=$(docker images --format "{{.Repository}}:{{.Tag}}" --filter "id=$IMAGE_NAME" | head -1)
    fi
    
    # If that didn't work, try docker-compose config
    if [ -z "$IMAGE_NAME" ]; then
        IMAGE_NAME=$(docker-compose config 2>/dev/null | grep 'image:' | awk '{print $2}' | head -1)
    fi
    
    # Final fallback: construct from directory name
    if [ -z "$IMAGE_NAME" ]; then
        DIR_NAME=$(basename "$PWD")
        IMAGE_NAME="${DIR_NAME}_claude-sandbox:latest"
        echo -e "${YELLOW}   Using fallback image name: $IMAGE_NAME${NC}"
    else
        echo -e "${GREEN}   Detected image name: $IMAGE_NAME${NC}"
    fi
    
    # Verify the image actually exists
    if ! docker image inspect "$IMAGE_NAME" >/dev/null 2>&1; then
        echo -e "${YELLOW}   Image not found, searching for similar images...${NC}"
        # Look for any image with claude-sandbox in the name
        FOUND_IMAGE=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep claude-sandbox | head -1)
        if [ -n "$FOUND_IMAGE" ]; then
            IMAGE_NAME="$FOUND_IMAGE"
            echo -e "${GREEN}   Found image: $IMAGE_NAME${NC}"
        else
            echo -e "${RED}❌ No suitable image found. Build may have failed.${NC}"
            exit 1
        fi
    fi
    
    # Use docker run with custom name instead of docker-compose up
    docker run -d \
        --name "$CONTAINER_NAME" \
        --hostname claude-sandbox \
        -it \
        --workdir /workspace \
        -v claude_sandbox_data:/workspace \
        -e TERM=xterm-256color \
        "$IMAGE_NAME" || exit 1
    
    echo -e "${GREEN}🎉 Claude Sandbox Setup Complete!${NC}"
    echo ""
    echo -e "${CYAN}📊 Container Information:${NC}"
    echo "  Container Name: $CONTAINER_NAME"
    echo "  Working Directory: /workspace (persists across restarts)"
    echo "  Status: $(docker ps --format "{{.Status}}" --filter "name=$CONTAINER_NAME")"
    echo ""
    echo -e "${CYAN}📋 Quick Commands:${NC}"
    echo "  docker exec -it $CONTAINER_NAME bash           # Enter container"
    echo "  docker logs $CONTAINER_NAME                    # View logs"
    echo "  docker rm -f $CONTAINER_NAME                   # Stop and remove container"
    echo ""
    echo -e "${CYAN}🚀 Entering Claude Sandbox...${NC}"
    echo ""
    
    # Wait for container to be ready (proper readiness check)
    echo -e "${CYAN}⏳ Waiting for container to be ready...${NC}"
    for i in {1..30}; do
        if docker exec "$CONTAINER_NAME" echo "ready" >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Container ready!${NC}"
            break
        fi
        if [ $i -eq 30 ]; then
            echo -e "${RED}❌ Container failed to become ready after 30 seconds${NC}"
            echo -e "${YELLOW}You can still try to enter manually:${NC}"
            echo "  docker exec -it $CONTAINER_NAME bash"
            exit 1
        fi
        sleep 1
    done
    echo ""
    
    # Auto-enter container if TTY is available
    # Check if we can actually allocate a TTY (not just if /dev/tty exists)
    if [ -t 0 ] && [ -t 1 ] && [ -c /dev/tty ]; then
        echo -e "${CYAN}Entering container...${NC}"
        exec docker exec -it "$CONTAINER_NAME" bash
    else
        echo -e "${YELLOW}Container is ready! To enter the container, run:${NC}"
        echo "  docker exec -it $CONTAINER_NAME bash"
        echo ""
        echo -e "${YELLOW}To start Claude Code directly:${NC}"
        echo "  docker exec -it $CONTAINER_NAME bash -c 'cd /workspace && claude'"
        echo ""
        echo -e "${GREEN}✨ Your Claude Sandbox is ready to use!${NC}"
    fi
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        show_banner
        echo "Docker Claude Sandbox - Portable Setup"
        echo ""
        echo "Features:"
        echo "  ✅ Claude Code pre-installed (run 'claude')"
        echo "  ✅ Node.js 18+ runtime environment"
        echo "  ✅ Essential Python development tools"
        echo "  ✅ Git for version control"
        echo "  ✅ Minimal by design - extend through Claude Code"
        echo "  ✅ Persistent /workspace for CLAUDE.md files"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo ""
        echo "One-liner install:"
        echo "  curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash"
        echo ""
        echo "Local usage:"
        echo "  git clone https://github.com/nixfred/docker-claude-sandbox.git"
        echo "  cd docker-claude-sandbox"
        echo "  ./run.sh"
        echo ""
        echo "Or use docker-compose directly:"
        echo "  docker-compose up -d"
        echo "  docker exec -it claude-sandbox bash -c \"cd /workspace && claude\""
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac