# 🤖 Docker Claude Sandbox

**One-command Docker container for safely testing Claude AI code**

## 🚀 Instant Start

```bash
curl -fsSL https://raw.githubusercontent.com/nixfred/docker-claude-sandbox/main/run.sh | bash
```

That's it! The script will:
- ✅ Ask you 4 quick questions
- ✅ Build your personalized container
- ✅ Drop you into a ready-to-code environment

## 📁 Or Clone & Run

```bash
git clone https://github.com/nixfred/docker-claude-sandbox.git
cd docker-claude-sandbox
./run.sh
```

## 🎯 What You Get

- **🛡️ Safe Environment**: Completely isolated from your host system
- **🐍 Python Ready**: Python 3 + pip + popular packages (requests, flask, pandas)
- **🟢 Node.js Ready**: Node.js + npm for JavaScript testing
- **🔧 Dev Tools**: git, vim, nano, curl, wget, and more
- **💾 Persistent Storage**: Your code survives container restarts
- **🌐 Port Forwarding**: Easy access to web servers you create

## 🎨 Features

### Interactive Setup
The script asks just 4 questions:
1. **Container name** - What to call your sandbox
2. **Workspace directory** - Where your code lives inside the container
3. **Ports to expose** - Which ports for web development (default: 8000,3000)
4. **Auto-start** - Jump straight into the container when ready

### Visual Progress
- Animated progress bars during setup
- ASCII art welcome banner
- Helpful commands and aliases inside the container

### Built-in Examples
Ready-to-run example files:
- `python3 examples/hello.py` - Test Python environment
- `python3 examples/webserver.py` - Simple web server
- `node examples/hello.js` - Test Node.js environment

## 🎮 Inside the Sandbox

Once you're in the container, you have:

```bash
# Quick commands
py script.py          # Run Python
serve [port]           # Start HTTP server
node script.js         # Run Node.js
help                   # Show all commands

# Your workspace
/workspace             # Your persistent code directory
/examples              # Sample code to try
```

## 🔧 Manual Container Management

```bash
# Start container
docker-compose up -d

# Enter container
docker exec -it claude-sandbox bash

# Stop container
docker-compose down

# View logs
docker logs claude-sandbox
```

## 🎯 Perfect For

- **Testing Claude AI code** safely without affecting your system
- **Learning new languages** in a clean environment
- **Quick prototyping** with no setup hassle
- **Sharing reproducible environments** with others

## 📋 Requirements

- Docker installed and running
- That's it!

Works on:
- ✅ Linux
- ✅ macOS  
- ✅ Windows (with Docker Desktop)

## 🚨 Troubleshooting

**Docker not found?**
```bash
# Install Docker: https://docs.docker.com/get-docker/
```

**Permission denied?**
```bash
# Linux: Add your user to docker group
sudo usermod -aG docker $USER
# Then log out and back in
```

**Container won't start?**
```bash
# Check Docker is running
docker info

# Clean up and retry
docker system prune
./run.sh
```

## 🤔 Why This Exists

Testing AI-generated code can be risky - you don't know if it's safe or if it will mess up your system. This sandbox gives you:

1. **Complete isolation** - Nothing can affect your host machine
2. **Instant setup** - From zero to coding in under 2 minutes  
3. **Persistent workspace** - Your code survives container restarts
4. **Pre-configured environment** - All the tools you need, ready to go

## 🎉 Examples

### Test a Python script Claude gave you:
```bash
# Run the one-liner, enter container, then:
echo 'print("Hello World!")' > test.py
py test.py
```

### Create a simple web server:
```bash
# In the container:
py examples/webserver.py
# Visit http://localhost:8000
```

### Test Node.js code:
```bash
# In the container:
node examples/hello.js
```

## 🚀 Contributing

Found a bug? Want to add a feature? 

1. Fork this repo
2. Make your changes  
3. Test with `./run.sh`
4. Submit a pull request

## 📄 License

MIT License - Use it however you want!

---

**Happy coding! 🚀**

*Built for safely testing Claude AI code, but works great for any development project.*