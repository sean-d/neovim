# My Neovim Configuration

**note**

This config has been saved local and evolved over time. A friend asked about it and I realized maybe I should put this up in github for others. 
Doing so meant I needed to document everything and how to use it. Enter Claude for helping document it all. 


**/note**


A modern Neovim setup optimized for full-stack development with comprehensive language support, focusing on productivity and clean UI.

## 🚀 Quick Start

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this configuration
git clone git@github.com:sean-d/neovim.git ~/.config/nvim

# Install (auto-installs plugins on first launch)
cd ~/.config/nvim && nvim
```

## 📚 Documentation

- **[Installation Guide](installation.md)** - Prerequisites, setup, and troubleshooting
- **[Key Mappings](keymaps.md)** - Complete keybinding reference
- **[Navigation](navigation.md)** - File explorer, fuzzy finding, Harpoon
- **[Language Development](development/index.md)** - Language-specific features
  - [Go Development](development/go.md)
  - [JavaScript/TypeScript](development/javascript.md)
  - [PHP/WordPress Development](development/php.md)
  - [PowerShell](development/powershell.md)
  - [Python Development](development/python.md)
  - [Rust Development](development/rust.md)
  - [Shell Scripting](development/shell.md)
- **[Git Integration](git.md)** - Gitsigns, Lazygit, and version control
- **[Docker Integration](development/docker.md)** - Container-based development workflows
- **[Database Tools](development/database.md)** - SQL development with vim-dadbod
- **[Debugging (DAP)](development/debugging.md)** - Debug adapter protocol for all languages
- **[Markdown](markdown.md)** - Enhanced markdown editing and preview
- **[RESTful Testing](rest-api.md)** - Test APIs directly in Neovim
- **[UI Customization](ui/index.md)** - Theme, dashboard, statusline
  - [Dashboard Customization](ui/dashboard.md)
  - [Theme & Colors](ui/theme.md)
- **[Trouble - Code Issues & Navigation](trouble.md)** - Using Trouble.nvim for diagnostics
- **[Installed Plugins](plugins.md)** - Complete list of all plugins with links
- **[Customization Guide](customization.md)** - How to add your own features

## ✨ Key Features

- **🎨 Beautiful UI** - Catppuccin theme with custom pink accents
- **🔍 Smart Navigation** - Flash.nvim for lightning-fast jumps
- **📝 Full LSP Support** - Auto-completion, diagnostics, and refactoring for 13+ languages
- **🐹 Go Development** - Comprehensive tooling with go.nvim and debugging
- **🦀 Rust Development** - Full-featured Rust support with rustaceanvim
- **🐍 Python Development** - Virtual env support, debugging, and UV package manager
- **📜 JavaScript/TypeScript** - Vue 3 support, debugging, ESLint, and Prettier
- **🐘 PHP Development** - WordPress optimized with Intelephense and Xdebug
- **🐚 Shell Scripting** - Bash/Zsh support with LSP diagnostics and formatting
- **⚡ PowerShell** - Full PowerShell development with LSP
- **🐳 Docker Integration** - Container workflows with docker-compose support
- **📄 Markdown Excellence** - Live preview, image paste, table formatting
- **🚀 Fast Startup** - Lazy-loaded plugins for optimal performance
- **🎯 Project Navigation** - Harpoon for quick file switching
- **🔧 Integrated Terminal** - Floating terminals with Snacks.nvim
- **📊 Git Integration** - Inline blame, Lazygit, GitHub integration
- **🔍 Enhanced Diagnostics** - Trouble.nvim for beautiful error navigation
- **🗄️ Database Tools** - SQL development with vim-dadbod and interactive UI
- **🔌 REST API Testing** - Test APIs with .http files using kulala.nvim
- **🎯 Debugging Support** - Full DAP integration for multiple languages

## 🎯 Custom Enhancements

This configuration includes several custom-built features that enhance the development experience:

### Enhanced Floating Windows
- **Definition Preview** - Press `gd` to see definitions in a beautiful floating window with syntax highlighting and documentation. Navigate through multiple definitions with `]` and `[`, or jump to source with `<Enter>`.
- **Hover Documentation** - Press `K` to view documentation in a custom modal that's properly sized and positioned, replacing the default LSP hover with a more readable interface.
- **Consistent Styling** - All floating windows use rounded borders with pink accents, matching the overall theme.

### Async Docker Operations
- **Non-Blocking Builds** - Docker builds (`<leader>cdb`) run in floating terminals with real-time output, preventing Neovim from freezing during long operations.
- **Smart Container Starts** - Starting containers (`<leader>cds`) automatically detects when images need pulling and shows progress in a terminal window.
- **Intelligent Operation Detection** - The system knows which Docker operations are fast (stop, remove) and which need async handling (builds, image pulls).
- **Clean Terminal Interface** - All Docker operations display in themed floating windows with clear success/failure messages and "Press 'q' to close" prompts.

### Visual Enhancements
- **Inline Git Blame** - Git blame information appears automatically at the end of lines in pink text after 1 second of cursor idle time, showing who last modified each line without cluttering the interface.
- **Smart Indent Guides** - Active indent scope highlighted in mauve with animated transitions, while inactive guides remain subtle.
- **Smart Bufferline** - Clean buffer tabs with file icons, diagnostics indicators, and the ability to pin important buffers.

## 🎮 Getting Started Shortcuts

Here's a taste of the shortcuts that will make your development life better:

### Navigation
| Key | Description |
|-----|-------------|
| `<Space>` | Leader key (your command center) |
| `<leader>ff` | Find files |
| `<leader>fg` | Search text in project (grep) |
| `<leader>e` | Toggle file explorer |
| `<leader><leader>` | Switch between recent buffers |

### Code Intelligence
| Key | Description |
|-----|-------------|
| `K` | Hover documentation |
| `gd` | Go to definition |
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename symbol |
| `<leader>cf` | Format file |

### Git & Tools
| Key | Description |
|-----|-------------|
| `<leader>gg` | Open Lazygit |
| `<leader>gb` | Git blame current line |
| `<leader>cds` | Start Docker container |
| `<leader>cxx` | Toggle diagnostics panel |

### Quick Access
| Key | Description |
|-----|-------------|
| `<leader>h` | Return to dashboard |
| `<leader>/` | Search current buffer |
| `<C-/>` | Toggle terminal |
| `<leader>Dt` | Toggle database UI |
| `<leader>rr` | Send REST request |

**[→ View Complete Keybinding Reference](keymaps.md)**

## 🚀 Getting Started

Ready to dive in? Check out the **[Installation Guide](installation.md)** for setup instructions.
