# Language Development

Overview of language-specific development features available in this Neovim configuration.

## Supported Languages

Each language has full LSP support with auto-completion, diagnostics, formatting, and language-specific features:

- **[Go](go.md)** - Full-featured development with go.nvim, gopls LSP, and delve debugging
- **[JavaScript/TypeScript](javascript.md)** - Modern JS/TS with Vue 3 support, vtsls LSP, ESLint, Prettier
- **[Lua](lua.md)** - Neovim configuration with lua_ls and API support
- **[PHP/WordPress](php.md)** - WordPress-optimized development with Intelephense
- **[PowerShell](powershell.md)** - PowerShell 7+ with Editor Services
- **[Python](python.md)** - Python development with Pyright, Ruff, virtual env support and UV
- **[Rust](rust.md)** - Complete Rust support with rustaceanvim and CodeLLDB
- **[Shell Scripting](shell.md)** - Bash/Zsh with bashls LSP diagnostics and formatting
- **[Markdown](markdown.md)** - Enhanced editing with marksman and harper_ls for grammar

## Common Features Across Languages

### Language Server Protocol (LSP)
All languages benefit from:
- **Auto-completion** - Context-aware suggestions with nvim-cmp
- **Diagnostics** - Real-time error checking
- **Go to Definition** - Jump to symbol definitions with preview (`gd`)
- **Find References** - Locate all usages in quickfix (`gr`)
- **Hover Documentation** - Inline help with custom handler (`K`)
- **Code Actions** - Automated fixes (`<leader>ca`)
- **Symbol Renaming** - Project-wide renaming (`<leader>cr`)
- **Type Definitions** - Jump to type definitions (`gy`)
- **Implementations** - Find implementations (`gI`)
- **Formatting** - Auto-format on save or with `<leader>cf`

### Code Intelligence
- **Treesitter** - Advanced syntax highlighting and code understanding
- **Code Outline** - Navigate symbols with `<leader>co`
- **Folding** - Collapse/expand code sections
- **Context Display** - See current function/class while scrolling

### Language-Specific Keybindings

Each language uses a dedicated prefix for its commands:
- `<leader>dgo*` - Go commands
- `<leader>djs*` - JavaScript/TypeScript commands
- `<leader>dlu*` - Lua commands
- `<leader>dph*` - PHP commands
- `<leader>dps*` - PowerShell commands
- `<leader>dpy*` - Python commands
- `<leader>drs*` - Rust commands
- `<leader>dsh*` - Shell commands

Common patterns across languages:
- `*r` - Run current file
- `*f` - Format file
- `*t` - Run tests
- `*b` - Build project
- `*d` - Start debugger

See individual language documentation for complete keybinding lists.

## LSP Server Management

### Mason Package Manager
LSP servers, DAP adapters, and tools are managed via Mason:
```vim
:Mason                 " Open Mason UI
:MasonInstall <server> " Install specific server
:MasonUpdate          " Update installed packages
```

### Auto-installed Servers
The following are automatically installed:
- **LSP**: lua_ls, gopls, rust_analyzer, marksman, harper_ls, bashls, powershell_es, pyright, ruff, intelephense, vtsls, eslint, tailwindcss
- **DAP**: codelldb, debugpy, php-debug-adapter, js-debug-adapter
- **Formatters**: prettier, prettierd

### Checking Server Status
```vim
:LspInfo      " Show active LSP servers
:LspLog       " View LSP communication logs
:checkhealth  " Verify LSP setup
```

## Adding Language Support

To add support for a new language:

1. Install the LSP server via Mason
2. Configure the server in `lua/plugins/lsp.lua`
3. Add language-specific plugins if needed
4. Create keybindings for language features
5. Document in `docs/development/<language>.md`

See the [customization guide](../customization.md) for detailed instructions.

## Debugging Support

Full debugging support via nvim-dap for:
- **Go** - via delve
- **Rust** - via CodeLLDB
- **Python** - via debugpy
- **JavaScript/TypeScript** - via js-debug-adapter
- **PHP** - via php-debug-adapter

Common debug keybindings:
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Set conditional breakpoint
- `<leader>dc` - Continue
- `<leader>dd` - Toggle debug UI
- `<leader>de` - Evaluate expression
- `<leader>di` - Step into
- `<leader>do` - Step out
- `<leader>dO` - Step over

## Development Workflows

### Docker Integration
Many language commands automatically detect and use Docker:
- Runs tests inside containers when docker-compose.yml exists
- Executes build commands in proper environment
- Manages language-specific services

### Project Detection
- Automatically detects project root (git, package.json, go.mod, etc.)
- Virtual environment activation for Python
- Node modules awareness for JS/TS
- Vendor directory support for PHP

## Related Features

For tools that work across all languages, see:
- [Docker Integration](docker.md) - Container-based development
- [Database Tools](database.md) - SQL development 
- [Debugging (DAP)](debugging.md) - Debug configuration details
- [Trouble](../trouble.md) - Enhanced diagnostics navigation
- [REST API Testing](../rest-api.md) - API development tools

---
[← Back to Theme & Colors](../ui/theme.md) | [Go Development →](go.md)