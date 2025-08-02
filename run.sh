#!/bin/bash
# Docker Claude Sandbox V2 - Enhanced One-Command Setup
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

# Smart port detection
find_available_ports() {
    local ports_needed=3
    local available_ports=()
    local start_port=8000
    
    echo -e "${CYAN}🔍 Scanning for available ports...${NC}"
    
    for ((port=start_port; port<=9000 && ${#available_ports[@]} < ports_needed; port++)); do
        if ! netstat -ln 2>/dev/null | grep -q ":$port " && ! ss -ln 2>/dev/null | grep -q ":$port "; then
            # Double check with lsof if available
            if ! lsof -i:$port >/dev/null 2>&1; then
                available_ports+=($port)
            fi
        fi
    done
    
    if [ ${#available_ports[@]} -ge 2 ]; then
        echo -e "${GREEN}✓ Found available ports: ${available_ports[*]}${NC}"
        DEFAULT_PORTS="${available_ports[0]},${available_ports[1]}"
        if [ ${#available_ports[@]} -ge 3 ]; then
            DEFAULT_PORTS="$DEFAULT_PORTS,${available_ports[2]}"
        fi
    else
        echo -e "${YELLOW}⚠ Limited available ports, using: 8080,3001${NC}"
        DEFAULT_PORTS="8080,3001"
    fi
}

# Progress bar function
show_progress() {
    local duration=$1
    local message=$2
    local bar_length=40
    
    echo -e "${CYAN}${message}${NC}"
    for ((i=0; i<=bar_length; i++)); do
        local percent=$((i * 100 / bar_length))
        local filled=$((i))
        local empty=$((bar_length - i))
        
        printf "\r${GREEN}["
        printf "%*s" $filled | tr ' ' '█'
        printf "%*s" $empty
        printf "] ${percent}%%${NC}"
        
        sleep $(echo "$duration / $bar_length" | bc -l 2>/dev/null || echo "0.01")
    done
    echo ""
}

# ASCII Banner
show_banner() {
    echo -e "${BLUE}"
    cat << "EOF"
    ╔═══════════════════════════════════════════════════════════════╗
    ║                                                               ║
    ║    🤖 Docker Claude Sandbox V2                               ║
    ║    Enhanced safe container for Claude AI code testing        ║
    ║                                                               ║
    ╚═══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Enhanced welcome script with system report
create_welcome_script() {
    cat > welcome.sh << 'EOF'
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# Welcome banner
echo -e "${BLUE}"
cat << "BANNER"
     ╔═══════════════════════════════════════════════════════════╗
     ║  🤖 Claude Sandbox Ready!                                 ║  
     ║  Your secure AI code testing environment                  ║
     ║                                                           ║
     ║  📊 System Report & Next Steps Below                      ║
     ╚═══════════════════════════════════════════════════════════╝
BANNER
echo -e "${NC}"

# System Information Report
echo -e "${CYAN}📊 Container System Report${NC}"
echo "=================================="
echo -e "${GREEN}✓${NC} Container: $CONTAINER_NAME"
echo -e "${GREEN}✓${NC} User: $(whoami) (non-root for security)"
echo -e "${GREEN}✓${NC} OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)"
echo -e "${GREEN}✓${NC} Python: $(python3 --version)"
echo -e "${GREEN}✓${NC} Node.js: $(node --version)"
echo -e "${GREEN}✓${NC} Workspace: /workspace (persistent)"
echo -e "${GREEN}✓${NC} Exposed Ports: $EXPOSED_PORTS"

# Storage info
echo ""
echo -e "${CYAN}💾 Storage Information${NC}"
echo "======================"
df -h /workspace 2>/dev/null | tail -1 | awk '{print "Workspace Volume: " $2 " total, " $4 " available"}'

# Network info
echo ""
echo -e "${CYAN}🌐 Network Access${NC}"
echo "=================="
echo "Host ports forwarded to container:"
IFS=',' read -ra PORTS <<< "$EXPOSED_PORTS"
for port in "${PORTS[@]}"; do
    port=$(echo $port | tr -d ' ')
    echo "  http://localhost:$port → container:$port"
done

# Pre-installed packages
echo ""
echo -e "${CYAN}📦 Pre-installed Tools${NC}"
echo "======================="
echo "Languages: Python 3, Node.js, JavaScript"
echo "Python packages: requests, flask, fastapi, pandas, numpy, matplotlib"
echo "System tools: git, vim, nano, curl, wget, htop, tree"
echo "Build tools: gcc, make, build-essential"

# Next steps
echo ""
echo -e "${YELLOW}🚀 Quick Start Guide${NC}"
echo "===================="
echo "1. Test the environment:"
echo "   ${GREEN}python3 /examples/hello.py${NC}"
echo "   ${GREEN}node /examples/hello.js${NC}"
echo ""
echo "2. Start coding:"
echo "   ${GREEN}cd /workspace${NC}    # Your persistent workspace"
echo "   ${GREEN}nano mycode.py${NC}   # Create a new file"
echo ""
echo "3. Test Claude AI code:"
echo "   • Copy code from Claude → paste into files here"
echo "   • Run safely in this isolated environment"
echo "   • No risk to your host system!"
echo ""
echo "4. Start a web server:"
echo "   ${GREEN}python3 -m http.server 8000${NC}"
echo "   ${GREEN}# Access at http://localhost:<port>${NC}"

# Claude AI Instructions
echo ""
echo -e "${BLUE}🤖 Connecting to Claude AI${NC}"
echo "==========================="
echo "This container is perfect for testing Claude AI code:"
echo ""
echo "1. ${CYAN}Get Code from Claude:${NC}"
echo "   • Go to https://claude.ai"
echo "   • Ask Claude to write code for you"
echo "   • Copy the code Claude provides"
echo ""
echo "2. ${CYAN}Test Code Safely:${NC}"
echo "   • Paste code into files in /workspace"
echo "   • Run with: ${GREEN}python3 yourfile.py${NC} or ${GREEN}node yourfile.js${NC}"
echo "   • Debug and modify as needed"
echo ""
echo "3. ${CYAN}Web Development:${NC}"
echo "   • Create web apps safely"
echo "   • Test at http://localhost:<your-port>"
echo "   • Port forwarding already configured!"

# Helpful commands
echo ""
echo -e "${CYAN}🛠️ Helpful Commands${NC}"
echo "==================="
echo "  ${GREEN}help${NC}              - Show this information again"
echo "  ${GREEN}py <file>${NC}         - Run Python script"
echo "  ${GREEN}serve [port]${NC}      - Start HTTP server"
echo "  ${GREEN}ll${NC}                - List files (detailed)"
echo "  ${GREEN}tree${NC}              - Show directory structure"
echo "  ${GREEN}htop${NC}              - System monitor"
echo "  ${GREEN}exit${NC}              - Leave container (data persists)"

# Add helpful aliases and functions
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias py='python3'
alias serve='python3 -m http.server'
alias ..='cd ..'
alias ...='cd ../..'

# Help function
help() {
    welcome
}

# Quick test function
test-env() {
    echo -e "${CYAN}🧪 Testing environment...${NC}"
    echo "Python: $(python3 --version)"
    echo "Node.js: $(node --version)"
    echo "Git: $(git --version)"
    echo "Workspace: $(ls -la /workspace | wc -l) items"
    echo -e "${GREEN}✅ Environment is working!${NC}"
}

# Create workspace structure
mkdir -p /workspace/{python,javascript,web,scratch}
cd /workspace

echo ""
echo -e "${GREEN}🎉 Ready to code! Your files in /workspace will persist between sessions.${NC}"
echo ""
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
    echo -e "${YELLOW}🔧 Quick Setup (press Enter for smart defaults)${NC}"
    echo ""
    
    # Container name
    read -p "Container name [$DEFAULT_CONTAINER_NAME]: " CONTAINER_NAME
    CONTAINER_NAME=${CONTAINER_NAME:-$DEFAULT_CONTAINER_NAME}
    
    # Workspace directory
    read -p "Workspace directory [$DEFAULT_WORKSPACE]: " WORKSPACE
    WORKSPACE=${WORKSPACE:-$DEFAULT_WORKSPACE}
    
    # Smart port detection
    find_available_ports
    
    # Show suggested ports
    read -p "Ports to expose [$DEFAULT_PORTS]: " PORTS
    PORTS=${PORTS:-$DEFAULT_PORTS}
    
    # Auto-start
    read -p "Auto-start container? [Y/n]: " AUTO_START
    AUTO_START=${AUTO_START:-Y}
    
    echo ""
    echo -e "${CYAN}📋 Configuration Summary:${NC}"
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

# Enhanced Dockerfile with security updates and cleanup
create_dockerfile() {
    cat > Dockerfile << EOF
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

# Set up locale
RUN apt-get update && \\
    apt-get install -y locales && \\
    locale-gen en_US.UTF-8 && \\
    apt-get clean

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Update system and install security updates
RUN apt-get update && \\
    apt-get upgrade -y && \\
    apt-get install -y --no-install-recommends \\
    # Core utilities
    curl wget git vim nano tree less htop \\
    # Build tools  
    build-essential make cmake \\
    # Languages
    python3 python3-pip python3-venv python3-dev \\
    nodejs npm \\
    # Network tools
    netcat-openbsd telnet traceroute dnsutils \\
    # System tools
    lsof procps net-tools \\
    # Archive tools
    unzip zip tar gzip \\
    # Text processing
    jq grep sed gawk \\
    # Additional useful tools
    bc file rsync \\
    && apt-get autoremove -y \\
    && apt-get autoclean \\
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Python packages
RUN pip3 install --no-cache-dir --upgrade pip && \\
    pip3 install --no-cache-dir \\
    requests flask fastapi \\
    pandas numpy matplotlib \\
    jupyter pytest \\
    && rm -rf ~/.cache/pip

# Install Node.js packages globally
RUN npm install -g \\
    express nodemon pm2 \\
    typescript ts-node \\
    && npm cache clean --force

# Create workspace with proper structure
WORKDIR /$WORKSPACE
RUN mkdir -p /$WORKSPACE/{python,javascript,web,scratch}

# Create non-root user for security
RUN useradd -m -s /bin/bash coder && \\
    chown -R coder:coder /$WORKSPACE && \\
    usermod -aG sudo coder

# Copy welcome script
COPY welcome.sh /usr/local/bin/welcome
RUN chmod +x /usr/local/bin/welcome

# Set environment variables for welcome script
ENV CONTAINER_NAME=$CONTAINER_NAME
ENV EXPOSED_PORTS=$PORTS

# Switch to non-root user
USER coder
ENV HOME=/home/coder

# Enhanced bashrc
RUN echo 'export PS1="\\[\\033[0;32m\\]\\u@claude-sandbox\\[\\033[00m\\]:\\[\\033[0;34m\\]\\w\\[\\033[00m\\]\\$ "' >> /home/coder/.bashrc && \\
    echo 'welcome' >> /home/coder/.bashrc && \\
    echo 'cd /workspace' >> /home/coder/.bashrc

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \\
    CMD python3 --version && node --version || exit 1

CMD ["/bin/bash"]
EOF
}

# Enhanced docker-compose with better networking
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
    build: 
      context: .
      dockerfile: Dockerfile
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
      - CONTAINER_NAME=$CONTAINER_NAME
      - EXPOSED_PORTS=$PORTS
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "python3", "--version"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s

volumes:
  ${CONTAINER_NAME}_data:
    driver: local

networks:
  default:
    driver: bridge
EOF
}

# Create improved example files
create_examples() {
    mkdir -p examples
    
    # Fixed Python hello world
    cat > examples/hello.py << EOF
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
    try:
        with open("/workspace/test_output.txt", "w") as f:
            f.write("Claude Sandbox is working!\\n")
            f.write(f"Generated at: $(date)\\n")
        print("✅ Created test file in /workspace/")
    except Exception as e:
        print(f"ℹ️  Note: {e}")
        print("   (This is normal if /workspace isn't mounted yet)")

if __name__ == "__main__":
    main()
EOF

    # Enhanced web server example
    cat > examples/webserver.py << EOF
#!/usr/bin/env python3
"""
Enhanced web server example for Claude Sandbox
Run with: python3 webserver.py [port]
Default port: 8000
"""

import sys
import os
from http.server import HTTPServer, SimpleHTTPRequestHandler
import json
from datetime import datetime

class ClaudeHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            html = f"""
            <!DOCTYPE html>
            <html>
            <head>
                <title>Claude Sandbox Server</title>
                <style>
                    body {{ font-family: Arial, sans-serif; margin: 40px; background: #f0f2f5; }}
                    .container {{ max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }}
                    h1 {{ color: #1a73e8; }}
                    .status {{ background: #e8f5e8; padding: 15px; border-radius: 5px; margin: 20px 0; }}
                    .info {{ background: #f0f8ff; padding: 15px; border-radius: 5px; margin: 20px 0; }}
                    code {{ background: #f1f3f4; padding: 2px 6px; border-radius: 3px; }}
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>🤖 Claude Sandbox Web Server</h1>
                    <div class="status">
                        <h3>✅ Server Status: Running</h3>
                        <p>Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
                        <p>Container: Running in isolated environment</p>
                    </div>
                    
                    <div class="info">
                        <h3>🚀 Quick Test URLs:</h3>
                        <ul>
                            <li><a href="/api/info">/api/info</a> - Server information</li>
                            <li><a href="/api/test">/api/test</a> - Test endpoint</li>
                            <li><a href="/workspace">/workspace</a> - Your files</li>
                        </ul>
                    </div>
                    
                    <div class="info">
                        <h3>💡 Next Steps:</h3>
                        <ol>
                            <li>Create files in <code>/workspace</code></li>
                            <li>Test Claude AI code safely here</li>
                            <li>Access via port forwarding: <code>http://localhost:PORT</code></li>
                        </ol>
                    </div>
                </div>
            </body>
            </html>
            """
            self.wfile.write(html.encode())
        elif self.path == '/api/info':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            info = {
                'server': 'Claude Sandbox Python Server',
                'python_version': sys.version,
                'working_directory': os.getcwd(),
                'timestamp': datetime.now().isoformat(),
                'container': 'claude-sandbox',
                'purpose': 'Safe testing of Claude AI generated code'
            }
            self.wfile.write(json.dumps(info, indent=2).encode())
        elif self.path == '/api/test':
            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            test_data = {
                'message': 'Claude Sandbox API test successful!',
                'timestamp': datetime.now().isoformat(),
                'test_calculation': sum(range(10)),
                'tip': 'Modify this endpoint to test your own code'
            }
            self.wfile.write(json.dumps(test_data, indent=2).encode())
        else:
            # Serve files from workspace
            if self.path.startswith('/workspace'):
                self.path = self.path.replace('/workspace', '/workspace', 1)
            super().do_GET()

if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
    os.chdir("/workspace")
    
    server = HTTPServer(('0.0.0.0', port), ClaudeHandler)
    print(f"🌐 Claude Sandbox server running at http://localhost:{port}")
    print(f"📁 Serving files from /workspace")
    print(f"🛑 Press Ctrl+C to stop")
    
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\\n🛑 Server stopped")
        server.shutdown()
EOF

    # Enhanced Node.js example
    cat > examples/hello.js << EOF
#!/usr/bin/env node
/**
 * Enhanced Node.js test for Claude Sandbox
 */

console.log("🤖 Hello from Claude Sandbox!");
console.log("🟢 Node.js is working perfectly!");

// Test some basic functionality
const numbers = [1, 2, 3, 4, 5];
const squares = numbers.map(n => n * n);
console.log(\`📊 Squares: \${squares}\`);

// Environment info
console.log(\`🔧 Node.js version: \${process.version}\`);
console.log(\`💻 Platform: \${process.platform}\`);
console.log(\`📁 Working directory: \${process.cwd()}\`);

// Test async functionality
const testAsync = async () => {
    return new Promise(resolve => {
        setTimeout(() => {
            resolve("✅ Async operations working!");
        }, 100);
    });
};

testAsync().then(result => {
    console.log(result);
    console.log("🎉 Node.js environment fully functional!");
});
EOF

    chmod +x examples/*.py examples/*.js
}

# Main execution
main() {
    show_banner
    check_requirements
    interactive_setup
    
    # Clean up any existing files
    rm -f Dockerfile docker-compose.yml welcome.sh 2>/dev/null || true
    
    # Create all files
    show_progress 1.0 "🔨 Creating enhanced Docker configuration..."
    create_dockerfile
    create_compose
    create_welcome_script
    
    show_progress 1.5 "📝 Setting up improved examples..."
    create_examples
    
    show_progress 2.5 "🏗️  Building optimized Docker image..."
    docker build -t claude-sandbox:latest . || exit 1
    
    if [[ $AUTO_START =~ ^[Yy]$ ]]; then
        show_progress 1.0 "🚀 Starting enhanced container..."
        docker-compose up -d || exit 1
        
        echo -e "${GREEN}🎉 Claude Sandbox V2 Setup Complete!${NC}"
        echo ""
        echo -e "${CYAN}📊 Container Information:${NC}"
        echo "  Name: $CONTAINER_NAME"
        echo "  Ports: $PORTS"
        echo "  Status: $(docker ps --format "{{.Status}}" --filter "name=$CONTAINER_NAME")"
        echo ""
        echo -e "${YELLOW}🌐 Access your services:${NC}"
        IFS=',' read -ra PORT_ARRAY <<< "$PORTS"
        for port in "${PORT_ARRAY[@]}"; do
            port=$(echo $port | tr -d ' ')
            echo "  http://localhost:$port"
        done
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

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        show_banner
        echo "Docker Claude Sandbox V2 - Enhanced Setup"
        echo ""
        echo "Features:"
        echo "  ✅ Smart port detection (avoids conflicts)"
        echo "  ✅ Latest security updates (apt upgrade)"
        echo "  ✅ Optimized container image"
        echo "  ✅ Enhanced system reporting"
        echo "  ✅ Clear Claude AI integration guide"
        echo ""
        echo "Usage: $0 [options]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo ""
        echo "One-liner install:"
        echo "  curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash"
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac