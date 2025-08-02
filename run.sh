#!/bin/bash
# Docker Claude Sandbox - Portable One-Command Setup
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
    
    echo -e "${CYAN}🏗️  Building Claude Sandbox container...${NC}"
    docker-compose build || exit 1
    
    echo -e "${CYAN}🚀 Starting Claude Sandbox...${NC}"
    docker-compose up -d || exit 1
    
    echo -e "${GREEN}🎉 Claude Sandbox Setup Complete!${NC}"
    echo ""
    echo -e "${CYAN}📊 Container Information:${NC}"
    echo "  Container Name: claude-sandbox"
    echo "  Working Directory: /workspace"
    echo "  Available Ports: 8000, 8001, 8002"
    echo "  Status: $(docker ps --format "{{.Status}}" --filter "name=claude-sandbox")"
    echo ""
    echo -e "${YELLOW}🌐 Access your services:${NC}"
    echo "  http://localhost:8000"
    echo "  http://localhost:8001" 
    echo "  http://localhost:8002"
    echo ""
    echo -e "${CYAN}📋 Quick Commands:${NC}"
    echo "  docker exec -it claude-sandbox bash  # Enter container"
    echo "  docker-compose logs                  # View logs"
    echo "  docker-compose down                  # Stop container"
    echo ""
    echo -e "${CYAN}🚀 Entering Claude Sandbox...${NC}"
    echo ""
    
    # Wait a moment for container to be fully ready
    sleep 2
    
    # Enter the container with proper TTY handling
    if [ -t 0 ] && [ -t 1 ]; then
        docker exec -it claude-sandbox bash
    else
        echo -e "${YELLOW}Container is ready! Access with:${NC}"
        echo "  docker exec -it claude-sandbox bash"
        echo ""
        echo -e "${CYAN}Or create an alias:${NC}"
        echo "  alias claude='docker exec -it claude-sandbox bash'"
    fi
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        show_banner
        echo "Docker Claude Sandbox - Portable Setup"
        echo ""
        echo "Features:"
        echo "  ✅ Self-contained Ubuntu environment"
        echo "  ✅ Complete Python ecosystem"
        echo "  ✅ Network and TCP/IP tools (nmap, tcpdump, etc.)"
        echo "  ✅ Development tools (git, vim, mc, etc.)"
        echo "  ✅ Portable docker-compose configuration"
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
        echo "  docker exec -it claude-sandbox bash"
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac