#!/bin/bash
# Docker Claude Sandbox - One-Command Setup
# Usage: curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default values
DEFAULT_CONTAINER_NAME="claude-sandbox"
DEFAULT_WORKSPACE="workspace"
DEFAULT_PORTS="8000,3000"

# Progress bar function
show_progress() {
    local duration=$1
    local message=$2
    local bar_length=50
    
    echo -e "${CYAN}${message}${NC}"
    for ((i=0; i<=bar_length; i++)); do
        local percent=$((i * 100 / bar_length))
        local filled=$((i))
        local empty=$((bar_length - i))
        
        printf "\r${GREEN}["
        printf "%*s" $filled | tr ' ' '█'
        printf "%*s" $empty
        printf "] ${percent}%%${NC}"
        
        sleep $(echo "$duration / $bar_length" | bc -l 2>/dev/null || echo "0.02")
    done
    echo ""
}

# ASCII Banner
show_banner() {
    echo -e "${BLUE}"
    cat << "EOF"
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║    🤖 Docker Claude Sandbox                                  ║
    ║    Safe container for testing Claude AI code                ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Welcome banner inside container
create_welcome_script() {
    cat > welcome.sh << 'EOF'
#!/bin/bash
echo -e "\033[0;34m"
cat << "BANNER"
     ╔═══════════════════════════════════════╗
     ║  🤖 Claude Sandbox Ready!             ║  
     ║  Your safe code testing environment   ║
     ║                                       ║
     ║  💡 Try: python3 examples/hello.py    ║
     ║  🌐 Web: python3 -m http.server 8000  ║
     ║  📝 Help: help                        ║
     ╚═══════════════════════════════════════╝
BANNER
echo -e "\033[0m"

# Add helpful aliases and functions
alias ll='ls -alF'
alias la='ls -A'
alias py='python3'
alias serve='python3 -m http.server'

# Help function
help() {
    echo "🚀 Claude Sandbox Commands:"
    echo "  py <file>      - Run Python script"
    echo "  serve [port]   - Start HTTP server (default: 8000)"
    echo "  node <file>    - Run Node.js script"
    echo "  ll             - List files (detailed)"
    echo "  la             - List all files"
    echo ""
    echo "📁 Directories:"
    echo "  /workspace     - Your code workspace"
    echo "  /examples      - Sample code to try"
    echo ""
    echo "🌐 Ports exposed: $EXPOSED_PORTS"
    echo "💾 Files persist in Docker volume: ${CONTAINER_NAME}_data"
}

# Show welcome message
EOF
    chmod +x welcome.sh
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

# Interactive setup
interactive_setup() {
    echo -e "${YELLOW}🔧 Quick Setup (press Enter for defaults)${NC}"
    echo ""
    
    # Container name
    read -p "Container name [$DEFAULT_CONTAINER_NAME]: " CONTAINER_NAME
    CONTAINER_NAME=${CONTAINER_NAME:-$DEFAULT_CONTAINER_NAME}
    
    # Workspace directory
    read -p "Workspace directory [$DEFAULT_WORKSPACE]: " WORKSPACE
    WORKSPACE=${WORKSPACE:-$DEFAULT_WORKSPACE}
    
    # Ports
    read -p "Ports to expose [$DEFAULT_PORTS]: " PORTS
    PORTS=${PORTS:-$DEFAULT_PORTS}
    
    # Auto-start
    read -p "Auto-start container? [Y/n]: " AUTO_START
    AUTO_START=${AUTO_START:-Y}
    
    echo ""
    echo -e "${CYAN}📋 Configuration:${NC}"
    echo "  Container: $CONTAINER_NAME"
    echo "  Workspace: /$WORKSPACE"
    echo "  Ports: $PORTS"
    echo "  Auto-start: $AUTO_START"
    echo ""
    
    read -p "Continue? [Y/n]: " CONFIRM
    if [[ $CONFIRM =~ ^[Nn]$ ]]; then
        echo "Setup cancelled"
        exit 0
    fi
}

# Create Dockerfile
create_dockerfile() {
    cat > Dockerfile << EOF
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Set up locale
RUN apt-get update && apt-get install -y locales && \\
    locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Install essential tools
RUN apt-get update && apt-get install -y --no-install-recommends \\
    # Core utilities
    curl wget git vim nano tree less htop \\
    # Build tools  
    build-essential make \\
    # Languages
    python3 python3-pip python3-venv \\
    nodejs npm \\
    # Network tools
    netcat-openbsd telnet \\
    # System tools
    lsof procps \\
    # Archive tools
    unzip zip \\
    # Text processing
    jq grep \\
    && apt-get clean \\
    && rm -rf /var/lib/apt/lists/*

# Install Python packages
RUN pip3 install --no-cache-dir \\
    requests flask fastapi \\
    pandas numpy matplotlib

# Create workspace
WORKDIR /$WORKSPACE

# Create non-root user
RUN useradd -m -s /bin/bash coder && \\
    chown -R coder:coder /$WORKSPACE

# Copy welcome script
COPY welcome.sh /usr/local/bin/welcome
RUN chmod +x /usr/local/bin/welcome

# Set environment variables for welcome script
ENV CONTAINER_NAME=$CONTAINER_NAME
ENV EXPOSED_PORTS=$PORTS

# Switch to non-root user
USER coder
ENV HOME=/home/coder

# Run welcome script on container start
RUN echo 'welcome' >> /home/coder/.bashrc

CMD ["/bin/bash"]
EOF
}

# Create docker-compose file
create_compose() {
    # Convert comma-separated ports to docker-compose format
    PORT_MAPPINGS=""
    IFS=',' read -ra PORT_ARRAY <<< "$PORTS"
    for port in "${PORT_ARRAY[@]}"; do
        port=$(echo $port | tr -d ' ')
        PORT_MAPPINGS="${PORT_MAPPINGS}      - \"${port}:${port}\"\n"
    done
    
    cat > docker-compose.yml << EOF
version: '3.8'

services:
  claude-sandbox:
    build: .
    container_name: $CONTAINER_NAME
    hostname: claude-sandbox
    stdin_open: true
    tty: true
    working_dir: /$WORKSPACE
    volumes:
      - ${CONTAINER_NAME}_data:/$WORKSPACE
      - ./examples:/examples:ro
    ports:
$(echo -e "$PORT_MAPPINGS")
    environment:
      - TERM=xterm-256color
    restart: unless-stopped

volumes:
  ${CONTAINER_NAME}_data:
    driver: local
EOF
}

# Create example files
create_examples() {
    mkdir -p examples
    
    # Python hello world
    cat > examples/hello.py << 'EOF'
#!/usr/bin/env python3
"""
Simple test script for Claude Sandbox
"""

def main():
    print("🤖 Hello from Claude Sandbox!")
    print("🐍 Python is working perfectly!")
    
    # Test some basic functionality
    numbers = [1, 2, 3, 4, 5]
    squares = [n**2 for n in numbers]
    print(f"📊 Squares: {squares}")
    
    # File writing test
    with open(f"/{WORKSPACE}/test_output.txt", "w") as f:
        f.write("Claude Sandbox is working!\n")
    print(f"✅ Created test file in /{WORKSPACE}/")

if __name__ == "__main__":
    main()
EOF

    # Simple web server
    cat > examples/webserver.py << 'EOF'
#!/usr/bin/env python3
"""
Simple web server example
Run with: python3 webserver.py
Access at: http://localhost:8000
"""

from http.server import HTTPServer, SimpleHTTPRequestHandler
import os

class CustomHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            html = """
            <html><body>
            <h1>🤖 Claude Sandbox Web Server</h1>
            <p>Your test environment is working!</p>
            <ul>
                <li><a href="/examples">View Examples</a></li>
                <li>Add your code to the workspace directory</li>
            </ul>
            </body></html>
            """
            self.wfile.write(html.encode())
        else:
            super().do_GET()

if __name__ == "__main__":
    os.chdir(f"/{WORKSPACE}")
    server = HTTPServer(('0.0.0.0', 8000), CustomHandler)
    print("🌐 Server running at http://localhost:8000")
    server.serve_forever()
EOF

    # Node.js example
    cat > examples/hello.js << 'EOF'
#!/usr/bin/env node
/**
 * Simple Node.js test for Claude Sandbox
 */

console.log("🤖 Hello from Claude Sandbox!");
console.log("🟢 Node.js is working perfectly!");

// Test some basic functionality
const numbers = [1, 2, 3, 4, 5];
const squares = numbers.map(n => n * n);
console.log(`📊 Squares: ${squares}`);

console.log("✅ Node.js test complete!");
EOF

    chmod +x examples/*.py examples/*.js
}

# Main execution
main() {
    show_banner
    check_requirements
    interactive_setup
    
    # Create all files
    show_progress 1.0 "🔨 Creating Docker configuration..."
    create_dockerfile
    create_compose
    create_welcome_script
    
    show_progress 1.5 "📝 Setting up examples..."
    create_examples
    
    show_progress 2.0 "🏗️  Building Docker image..."
    docker build -t claude-sandbox:latest . || exit 1
    
    if [[ $AUTO_START =~ ^[Yy]$ ]]; then
        show_progress 1.0 "🚀 Starting container..."
        docker-compose up -d || exit 1
        
        echo -e "${GREEN}🎉 Setup complete!${NC}"
        echo ""
        echo -e "${CYAN}🚀 Entering Claude Sandbox...${NC}"
        echo ""
        
        # Enter the container
        docker exec -it "$CONTAINER_NAME" bash
    else
        echo -e "${GREEN}🎉 Setup complete!${NC}"
        echo ""
        echo "To start: docker-compose up -d"
        echo "To enter: docker exec -it $CONTAINER_NAME bash"
    fi
}

# Run main function
main "$@"