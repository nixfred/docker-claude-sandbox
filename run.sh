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
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}❌ Docker not found${NC}"
        echo "Install Docker: https://docs.docker.com/get-docker/"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        echo -e "${RED}❌ Docker daemon not running${NC}"
        echo "Please start Docker and try again"
        exit 1
    fi
    
    echo -e "${GREEN}✓ Docker is ready${NC}"
    
    # Check for docker-compose
    if ! command -v docker-compose &> /dev/null; then
        echo -e "${RED}❌ docker-compose not found${NC}"
        echo ""
        echo "Install docker-compose with one of these methods:"
        echo ""
        echo "Option 1 - Using apt (Debian/Ubuntu):"
        echo "  sudo apt update && sudo apt install -y docker-compose"
        echo ""
        echo "Option 2 - Using pip:"
        echo "  sudo pip3 install docker-compose"
        echo ""
        echo "Option 3 - Direct download (latest version):"
        echo "  sudo curl -L \"https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)\" -o /usr/local/bin/docker-compose"
        echo "  sudo chmod +x /usr/local/bin/docker-compose"
        echo ""
        exit 1
    fi
    
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

# Smart directory selection
select_project_directory() {
    local current_dir=$(pwd)
    local suggested_dir="$HOME/claude-sandbox"
    
    echo -e "${CYAN}📁 Project Directory Setup${NC}"
    echo "================================"
    echo ""
    echo "Where would you like to create the Claude Sandbox project?"
    echo ""
    echo -e "${YELLOW}Options:${NC}"
    echo "  1. Current directory: $current_dir"
    echo "  2. Recommended: $suggested_dir"
    echo "  3. Custom directory (you specify)"
    echo ""
    
    if [ -t 0 ]; then
        # Interactive mode
        read -p "Choose [1] current, [2] recommended, [3] custom, or press Enter for recommended: " DIR_CHOICE
        DIR_CHOICE=${DIR_CHOICE:-2}
        
        case "$DIR_CHOICE" in
            1)
                PROJECT_DIR="$current_dir"
                echo -e "${GREEN}✓ Using current directory: $PROJECT_DIR${NC}"
                ;;
            2)
                PROJECT_DIR="$suggested_dir"
                if [ ! -d "$PROJECT_DIR" ]; then
                    echo -e "${YELLOW}Creating directory: $PROJECT_DIR${NC}"
                    mkdir -p "$PROJECT_DIR"
                fi
                echo -e "${GREEN}✓ Using recommended directory: $PROJECT_DIR${NC}"
                cd "$PROJECT_DIR"
                ;;
            3)
                read -p "Enter custom directory path: " CUSTOM_DIR
                if [ -z "$CUSTOM_DIR" ]; then
                    echo -e "${RED}❌ No directory specified, using current${NC}"
                    PROJECT_DIR="$current_dir"
                else
                    PROJECT_DIR="$CUSTOM_DIR"
                    if [ ! -d "$PROJECT_DIR" ]; then
                        echo -e "${YELLOW}Creating directory: $PROJECT_DIR${NC}"
                        mkdir -p "$PROJECT_DIR"
                    fi
                    echo -e "${GREEN}✓ Using custom directory: $PROJECT_DIR${NC}"
                    cd "$PROJECT_DIR"
                fi
                ;;
            *)
                PROJECT_DIR="$suggested_dir"
                if [ ! -d "$PROJECT_DIR" ]; then
                    echo -e "${YELLOW}Creating directory: $PROJECT_DIR${NC}"
                    mkdir -p "$PROJECT_DIR"
                fi
                echo -e "${GREEN}✓ Using recommended directory: $PROJECT_DIR${NC}"
                cd "$PROJECT_DIR"
                ;;
        esac
    else
        # Non-interactive mode - use recommended
        PROJECT_DIR="$suggested_dir"
        if [ ! -d "$PROJECT_DIR" ]; then
            echo -e "${YELLOW}Creating recommended directory: $PROJECT_DIR${NC}"
            mkdir -p "$PROJECT_DIR"
        fi
        echo -e "${GREEN}✓ Using recommended directory: $PROJECT_DIR${NC}"
        cd "$PROJECT_DIR"
    fi
    
    echo ""
    echo -e "${CYAN}📂 Working in: $(pwd)${NC}"
    echo ""
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
        select_project_directory
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
    docker-compose build || exit 1
    
    echo -e "${CYAN}🚀 Starting Claude Sandbox...${NC}"
    # Use docker run with custom name instead of docker-compose up
    docker run -d \
        --name "$CONTAINER_NAME" \
        --hostname claude-sandbox \
        -it \
        --workdir /workspace \
        -v claude_sandbox_data:/workspace \
        -e TERM=xterm-256color \
        docker-claude-sandbox_claude-sandbox || exit 1
    
    echo -e "${GREEN}🎉 Claude Sandbox Setup Complete!${NC}"
    echo ""
    echo -e "${CYAN}📊 Container Information:${NC}"
    echo "  Container Name: $CONTAINER_NAME"
    echo "  Working Directory: /workspace (persists across restarts)"
    echo "  Status: $(docker ps --format "{{.Status}}" --filter "name=$CONTAINER_NAME")"
    echo ""
    echo -e "${CYAN}📋 Quick Commands:${NC}"
    echo "  docker exec -it $CONTAINER_NAME bash  # Enter container"
    echo "  docker-compose logs                   # View logs"
    echo "  docker-compose down                   # Stop container"
    echo ""
    echo -e "${CYAN}🚀 Entering Claude Sandbox...${NC}"
    echo ""
    
    # Wait a moment for container to be fully ready
    sleep 2
    
    echo -e "${GREEN}✅ Container ready!${NC}"
    echo ""
    
    # Only auto-enter if we have a real TTY (not piped)
    if [ -t 0 ] && [ -t 1 ]; then
        echo -e "${CYAN}Entering container...${NC}"
        exec docker exec -it "$CONTAINER_NAME" bash
    else
        echo -e "${YELLOW}To enter the container, run:${NC}"
        echo "  docker exec -it $CONTAINER_NAME bash"
        echo ""
        echo -e "${YELLOW}To start Claude Code directly:${NC}"
        echo "  docker exec -it $CONTAINER_NAME bash -c 'cd /workspace && claude'"
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