# Docker Integration

Integrate Docker containers into your development workflow for consistent, isolated environments.

## Overview

This Docker integration provides:
- **Automatic Detection** - Works seamlessly with both Dockerfile and docker-compose.yml
- **Container Management** - Start, stop, and manage containers from Neovim
- **Status Monitoring** - See container status in your statusline
- **Easy Access** - Quick terminal access to running containers  
- **Log Viewing** - Stream container logs in floating windows
- **Visual Management** - LazyDocker in a beautiful floating terminal

### Key Features

🎯 **Smart Detection**
- Automatically detects project type (Dockerfile vs docker-compose.yml)
- Uses appropriate Docker or Docker Compose commands
- No configuration needed - just works!

🐳 **Full Docker Compose Support**
- Manages multi-container applications
- Handles service dependencies
- Preserves volumes and networks
- Shows logs from all services

🖥️ **Floating Terminal Windows**
- LazyDocker opens in a centered floating window
- Logs display in floating terminals
- Optional floating shell access with `<leader>cdA`
- Clean, distraction-free interface

## Prerequisites

- **Docker** - Install Docker Desktop or Docker Engine
- **LazyDocker** (optional) - For visual container management

Verify installation:
```bash
docker --version
lazydocker --version  # Optional but recommended
```

## Container Status

The statusline shows your project's Docker status:
- `📦 No Docker` - No Dockerfile or docker-compose.yml found
- `📦 No Container` - Docker files exist but no container created
- `🐳 Running` - Container is actively running
- `💤 Stopped` - Container exists but is stopped

## Docker Operations

All Docker operations are available through keybindings (see Key Mappings below). The integration automatically detects whether to use Docker or Docker Compose based on your project structure.

## Key Mappings

| Key | Description |
|-----|-------------|
| `<leader>cdi` | Docker Info 📊 |
| `<leader>cdb` | Build Docker image 🔨 |
| `<leader>cds` | Start Docker container 🐳 |
| `<leader>cda` | Attach to Docker container 🔗 (with service selection) |
| `<leader>cdA` | Attach to Docker container (floating window) 🪟 |
| `<leader>cdx` | Stop Docker container 🛑 |
| `<leader>cdd` | Delete Docker container 🗑️ |
| `<leader>cdl` | Show Docker logs 📋 (follows logs - use `<C-c>` to stop, then `<C-q>` or `q` to close) |
| `<leader>cdL` | Open LazyDocker 🐳 |

## Workflow Examples

### Single Container (Dockerfile)

#### 1. Build & Start
```vim
<leader>cdb   " Build Docker image
<leader>cds   " Start Docker container
```
The container is named `docker-<project-name>` with automatic port mapping from EXPOSE directives.

### Multi-Container (Docker Compose)

#### 1. Create docker-compose.yml
```yaml
services:
  app:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - redis
  
  redis:
    image: redis:alpine
    ports:
      - "6379:6379"
```

#### 2. Build & Start All Services
```vim
<leader>cdb   " Build with docker compose build
<leader>cds   " Start with docker compose up -d
```
All commands automatically detect and use Docker Compose when docker-compose.yml exists!

### 3. Access Container
```vim
<leader>cda   " Attach to container
```
Opens a terminal inside the container where you can run commands.

#### Service Selection (Docker Compose)
When using Docker Compose with multiple services, `<leader>cda` presents an interactive menu:

```
Select service to attach to:
> 🗄️ db
  📧 mailhog
  🗃️ phpmyadmin
  🌐 wordpress
```

Features:
- **Smart Icons** - Services are displayed with helpful icons (🌐 web, 🗄️ database, 📧 mail, etc.)
- **Interactive Selection** - Use `j`/`k` or arrow keys to navigate, `Enter` to select
- **Cancel Anytime** - Press `<Esc>` to cancel without attaching
- **Single Service** - If only one service exists, it attaches directly without prompting

This makes it easy to jump between different services in complex Docker Compose setups!

### 4. Run Your Code
In the container terminal:
```bash
go run main.go
go test ./...
```

### 5. View Logs
```vim
<leader>cdl     " View Docker logs
```
The logs window follows container output continuously. To close:
- Press `<C-c>` to stop following logs
- Then press `<C-q>`, `<Esc>`, or `q` to close the window

### 6. Stop When Done
```vim
<leader>cdx     " Stop Docker container
```

## Docker Compose Support

If you have a `docker-compose.yml`, the commands automatically use Docker Compose:

```yaml
version: '3.8'
services:
  app:
    build: .
    volumes:
      - .:/workspace
    ports:
      - "8080:8080"
  
  db:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: secret
```

## LazyDocker Integration 

Press `<leader>cdL` to open LazyDocker in a **beautiful floating terminal window**:

**Key Features:**
- Visual container management
- Real-time logs and metrics
- One-key operations  
- 90% screen size floating window

Additional capabilities:
- View all containers, images, volumes, networks
- Start/stop/restart containers with single keys
- Stream logs from multiple containers
- Monitor CPU/memory usage in real-time
- Prune unused resources
- Exec into containers
- **Works perfectly with Docker Compose projects!**

**Note**: Requires lazydocker to be installed: `brew install lazydocker`

### LazyDocker Keybindings

#### Global
| Key | Action |
|-----|--------|
| `ctrl+r` | Refresh |
| `[` / `]` | Previous/next tab |
| `m` | View logs |
| `enter` | Focus main panel |
| `tab` | Focus next panel |
| `shift+tab` | Focus previous panel |
| `ctrl+c` / `q` | Quit |
| `x` | Open menu |
| `?` | Toggle help |

#### Container Panel
| Key | Action |
|-----|--------|
| `d` | Remove container |
| `e` | Hide/show stopped containers |
| `s` | Stop container |
| `r` | Restart container |
| `a` | Attach to container |
| `shift+e` | Exec shell |
| `ctrl+e` | Open container config |
| `m` | View logs |
| `u` | View CPU/memory usage |

#### Images Panel
| Key | Action |
|-----|--------|
| `d` | Remove image |
| `ctrl+d` | Prune images |

#### Volumes Panel
| Key | Action |
|-----|--------|
| `d` | Remove volume |
| `ctrl+d` | Prune volumes |

#### Networks Panel
| Key | Action |
|-----|--------|
| `d` | Remove network |
| `ctrl+d` | Prune networks |

#### Services Panel (Docker Compose)
| Key | Action |
|-----|--------|
| `d` | Down service |
| `s` | Stop service |
| `r` | Restart service |
| `u` | Up service |
| `shift+r` | Rebuild and restart |
| `m` | View logs |
| `a` | Attach to service |

#### Log Panel
| Key | Action |
|-----|--------|
| `esc` | Return to previous panel |
| `ctrl+a` | Toggle timestamps |
| `ctrl+w` | Toggle wrap |

For the full list of keybindings, see: https://github.com/jesseduffield/lazydocker/blob/master/docs/keybindings/Keybindings_en.md

## Container Naming

Containers are automatically named based on your project directory:
- Project: `~/projects/my-app`
- Container: `docker-my-app`

This ensures each project has its own isolated container.

## Port Mapping

Common ports are automatically mapped:
- `8080:8080` - Web servers
- `3000:3000` - Node.js apps  
- `5000:5000` - Python Flask

Add more ports in your Dockerfile or docker-compose.yml as needed.

## Tips

1. **Edit Locally, Run in Container** - Your code is mounted, so local edits are instantly reflected
2. **Persistent Shells** - Container stays running for quick command execution
3. **Clean Separation** - Each project gets its own container
4. **Easy Cleanup** - Use LazyDocker to remove old containers/images

## Troubleshooting

### Container won't start
```bash
# Check Docker is running
docker ps

# View build errors
docker logs docker-<project-name>
```

### Permission issues
Ensure your Dockerfile sets appropriate user permissions:
```dockerfile
RUN adduser -D appuser
USER appuser
```

### Can't connect to ports
Check port mapping in container status:
```bash
docker ps
docker port docker-<project-name>
```

---
[← Back to Git Integration](../git.md) | [Database Tools →](database.md)