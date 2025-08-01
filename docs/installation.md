# Installation Guide

Complete installation and setup guide for this Neovim configuration.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Initial Setup](#initial-setup)
- [Keeping Updated](#keeping-updated)
- [Troubleshooting](#troubleshooting)

## Prerequisites

The following tools are needed for full functionality:

- **Neovim** >= 0.9.0
- **Git** - Plugin management and version control
- **ripgrep** - Fast searching with `<leader>/`
- **Node.js** - LSP servers and markdown preview
- **LuaRocks** - Lua dependencies
- **Docker** - Containerized development with `<leader>cd*`
- **docker-compose** - Multi-container applications
- **lazygit** - Git UI with `<leader>gg`
- **lazydocker** - Docker management with `<leader>cdd`
- **Go** - Go development support
- **shellcheck** - Shell script diagnostics
- **shfmt** - Shell script formatting
- **PowerShell** - PowerShell development
- **Python 3.x** - Python development
- **UV** - Modern Python package manager
- **pngpaste** (macOS) or **xclip** (Linux) - Paste images in markdown

All prerequisites are installed by the platform-specific commands below.

### Install on macOS

```bash
# Install Docker Desktop (includes docker-compose)
brew install --cask docker

# Install other tools
brew install neovim ripgrep lazygit lazydocker go node luarocks pngpaste shellcheck shfmt

# Install global npm packages
npm install -g eslint

# PHP/WordPress development (if needed)
brew install php composer
composer global require wp-coding-standards/wpcs phpcsstandards/phpcsutils phpcsstandards/phpcsextra dealerdirect/phpcodesniffer-composer-installer

# Rust components (if using Rust)
rustup component add rust-src rust-analyzer clippy rustfmt

# Install PowerShell
brew install --cask powershell

# PowerShell modules (after PowerShell is installed)
pwsh -NoProfile -Command "Install-Module -Name PSScriptAnalyzer -Force -Scope CurrentUser"
# pwsh -NoProfile -Command "Install-Module -Name Pester -Force -Scope CurrentUser"

# Install UV (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env  # Add to PATH

# Verify installations
nvim --version
rg --version
docker --version
docker-compose --version
lazygit --version
lazydocker --version
go version
node --version
luarocks --version
pwsh --version
python3 --version
uv --version
```

### Install on Ubuntu/Debian

```bash
# Update package list
sudo apt update

# Install Docker
sudo apt install docker.io docker-compose
# Add your user to docker group
sudo usermod -aG docker $USER
# Log out and back in for group changes to take effect

# Install core dependencies
sudo apt install neovim ripgrep golang nodejs npm luarocks shellcheck shfmt

# Install global npm packages
npm install -g eslint

# PHP/WordPress development (if needed)
sudo apt install php composer
composer global require wp-coding-standards/wpcs phpcsstandards/phpcsutils phpcsstandards/phpcsextra dealerdirect/phpcodesniffer-composer-installer

# Rust components (if using Rust)
rustup component add rust-src rust-analyzer clippy rustfmt

# For image pasting support
sudo apt install xclip

# Install PowerShell
# Update the list of packages
sudo apt-get update
# Install pre-requisite packages
sudo apt-get install -y wget apt-transport-https software-properties-common
# Download the Microsoft repository GPG keys
wget -q "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/packages-microsoft-prod.deb"
# Register the Microsoft repository GPG keys
sudo dpkg -i packages-microsoft-prod.deb
# Update the list of packages after we added packages.microsoft.com
sudo apt-get update
# Install PowerShell
sudo apt-get install -y powershell

# Install UV for Python
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz lazygit

# Install lazydocker
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
```

### Install on Arch Linux

```bash
# Using pacman and AUR
sudo pacman -S neovim ripgrep go nodejs npm luarocks xclip docker docker-compose shellcheck shfmt

# Install PowerShell from AUR
yay -S powershell-bin

# Install UV for Python
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# Install other AUR packages
yay -S lazygit lazydocker pngpaste
```

## Installation

### 1. Backup Existing Configuration

```bash
# Backup if you have an existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Also backup CoC settings if migrating from CoC
mv ~/.config/coc ~/.config/coc.bak
```

### 2. Clone This Configuration

```bash
# Clone via SSH (recommended)
git clone git@github.com:sean-d/neovim.git ~/.config/nvim

# Or via HTTPS
git clone https://github.com/sean-d/neovim.git ~/.config/nvim
```

### 3. Initial Launch

```bash
# Navigate to the config directory
cd ~/.config/nvim

# Launch Neovim (plugins auto-install)
nvim
```

#### What to Expect on First Launch

When you first launch Neovim after installation, expect the following:

1. **Initial Plugin Installation** (~1-2 minutes)
   - Lazy.nvim will show "Working (1)" while installing 62 plugins
   - The interface may appear frozen - this is normal, let it complete
   - Some plugins compile during installation which takes time

2. **Common Notifications You'll See**
   - **"Phpactor is not installed, would you like to install it?"** - Press `1` or Enter for Yes
   - **"phpactor not found. clone repo..."** - This is normal, it's downloading phpactor
   - **"[nvim-treesitter][php]: Could not create tree-sitter-php-tmp"** - This is harmless, the parser still installs correctly
   - **Multiple "Installing..." notifications** - Mason is auto-installing language servers and tools

3. **Background Installations**
   - Treesitter parsers compile from source
   - Mason downloads LSPs, debuggers, and formatters
   - First file of each language type triggers tool installation

4. **Success Indicators**
   - "Config loaded successfully" in the status line
   - Syntax highlighting appears in your files
   - No more "Working" status in Lazy

**Note**: Future launches will be fast (~80ms) after this initial setup.

### 4. Post-Installation Setup

After plugins install:

```vim
" In Neovim, run these commands:
:checkhealth     " Check for any issues
:Mason           " Verify LSP servers installed
:Lazy            " Check plugin status
```

## Initial Setup

### Language Servers

The following LSP servers are auto-installed:
- **lua_ls** - Lua
- **gopls** - Go
- **rust_analyzer** - Rust
- **marksman** - Markdown
- **harper_ls** - Grammar/spelling checker
- **bashls** - Bash/Shell scripting
- **powershell_es** - PowerShell Editor Services
- **pyright** - Python type checker
- **ruff** - Python linter/formatter
- **intelephense** - PHP (optimized for WordPress)
- **vtsls** - TypeScript/JavaScript (with Vue support)
- **eslint** - ESLint for JavaScript/TypeScript
- **tailwindcss** - Tailwind CSS IntelliSense

### Additional Tools

These development tools are also auto-installed:
- **codelldb** - Rust/C++ debugger
- **debugpy** - Python debugger
- **php-debug-adapter** - PHP debugger
- **js-debug-adapter** - JavaScript/TypeScript debugger
- **prettier** - Code formatter
- **prettierd** - Prettier daemon for faster formatting

To add more servers:
```vim
:MasonInstall <server-name>
```

### Go Development

Go development tools are automatically installed when you first open a Go file. To manually install or update all Go tools:
```vim
:lua require("go.install").update_all_sync()  " Install/update Go development tools
```

### Markdown Preview

If you encounter build errors with markdown-preview:
```bash
# Remove and reinstall
rm -rf ~/.local/share/nvim/lazy/markdown-preview.nvim
# Then in Neovim:
:Lazy sync
```

## Keeping Updated

### Pull Latest Changes

To get the latest updates from the original repository:

```bash
cd ~/.config/nvim
git pull
# In Neovim:
:Lazy sync  " Update plugins
```

### Update Plugins

```vim
:Lazy sync    " Update all plugins
:Lazy update  " Update without syncing lockfile
:Mason        " Update LSP servers
```

## Troubleshooting

### Common Issues

#### Plugins not loading
```vim
:Lazy sync      " Force plugin sync
:checkhealth    " Check for issues
```

#### LSP not working
```vim
:LspInfo        " Check server status
:LspLog         " View LSP logs
:Mason          " Reinstall servers
```

#### Go features not working
```bash
# Verify Go installation
go version

# In Neovim:
:lua require("go.install").update_all_sync()  " Install/update Go tools
:checkhealth go     " Check Go setup
```

#### Clipboard not working
```bash
# macOS
brew install pbcopy

# Linux (X11)
sudo apt install xclip

# Linux (Wayland)
sudo apt install wl-clipboard
```

#### Fonts missing icons
Install a Nerd Font:
```bash
# macOS
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font

# Linux - download from:
# https://www.nerdfonts.com/
```

### Clean Reinstall

If all else fails:
```bash
# Remove everything
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim

# Start fresh
git clone git@github.com:sean-d/neovim.git ~/.config/nvim
nvim
```

---
[← Back to Introduction](README.md) | [Customization Guide →](customization.md)