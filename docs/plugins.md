# Installed Plugins

Complete list of all plugins used in this Neovim configuration, organized by category.

## Plugin Manager
- [lazy.nvim](https://github.com/folke/lazy.nvim) - Modern plugin manager with lazy loading support

## UI & Appearance

### Theme & Colors
- [catppuccin/nvim](https://github.com/catppuccin/nvim) - Catppuccin colorscheme (using Macchiato flavor)
- [nvim-colorizer.lua](https://github.com/catgoose/nvim-colorizer.lua) - Highlights color codes with their actual colors

### Interface Components
- [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Fast and customizable statusline
- [lualine-pretty-path](https://github.com/bwpge/lualine-pretty-path) - Pretty path display for lualine
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Buffer/tab line with grouping support
- [which-key.nvim](https://github.com/folke/which-key.nvim) - Displays available keybindings in popup
- [dressing.nvim](https://github.com/stevearc/dressing.nvim) - Improved UI for vim.ui.select and vim.ui.input
- [mini.icons](https://github.com/echasnovski/mini.icons) - File type icons

## Core Functionality

### Swiss Army Knife
- [snacks.nvim](https://github.com/folke/snacks.nvim) - Collection of small useful plugins:
  - **Dashboard** - Startup screen with ASCII art
  - **Explorer** - File tree explorer
  - **Picker** - Fuzzy finder (Telescope alternative)
  - **Terminal** - Floating and split terminals
  - **Notifier** - Notification system
  - **Lazygit** - Git integration
  - **Scratch** - Temporary buffers
  - **Statuscolumn** - Enhanced status column
  - **Words** - Word highlighting
  - **Bigfile** - Performance for large files

## Editor Enhancement

### Text Manipulation
- [mini.pairs](https://github.com/echasnovski/mini.pairs) - Auto-close brackets and quotes
- [mini.surround](https://github.com/echasnovski/mini.surround) - Add/delete/change surroundings
- [mini.ai](https://github.com/echasnovski/mini.ai) - Enhanced text objects
- [Comment.nvim](https://github.com/numToStr/Comment.nvim) - Smart code commenting
- [nvim-ts-context-commentstring](https://github.com/JoosepAlviste/nvim-ts-context-commentstring) - Treesitter-aware comment strings

### Navigation & Motion
- [flash.nvim](https://github.com/folke/flash.nvim) - Lightning-fast character navigation
- [stay-centered.nvim](https://github.com/arnamak/stay-centered.nvim) - Keep cursor line centered
- [harpoon](https://github.com/ThePrimeagen/harpoon) - Quick file navigation marks

### Git Integration
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git decorations and operations

## Code Intelligence

### Syntax & Parsing
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Treesitter configurations and abstraction layer
- [nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context) - Shows code context (currently disabled)

### Language Server Protocol
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Quickstart configurations for LSP
- [mason.nvim](https://github.com/williamboman/mason.nvim) - Portable package manager for LSP servers
- [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) - Bridge between mason and lspconfig
- [fidget.nvim](https://github.com/j-hui/fidget.nvim) - LSP progress notifications

### Completion
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completion engine
- [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) - LSP source for nvim-cmp
- [cmp-buffer](https://github.com/hrsh7th/cmp-buffer) - Buffer words source
- [cmp-path](https://github.com/hrsh7th/cmp-path) - Filesystem paths source
- [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) - Command line completion
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Snippet engine
- [cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) - LuaSnip completion source
- [friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - Collection of snippets

## Language Support

### Go Development
- [go.nvim](https://github.com/ray-x/go.nvim) - Complete Go development environment
- [guihua.lua](https://github.com/ray-x/guihua.lua) - Floating window UI library (go.nvim dependency)
- [nvim-dap-go](https://github.com/leoluz/nvim-dap-go) - Go debugging support

### Rust Development
- [rustaceanvim](https://github.com/mrcjkb/rustaceanvim) - Advanced Rust development tools and LSP configuration

### PHP Development
- [phpactor.nvim](https://github.com/phpactor/phpactor) - PHP refactoring and code completion
- Neotest adapters for PHPUnit testing

### Python Development
Supported via LSP (pyright, ruff) and DAP (debugpy) - no specific plugins required

### JavaScript/TypeScript Development
Supported via LSP (vtsls, eslint) - no specific plugins required

### Markdown
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) - Beautiful in-buffer markdown rendering
- [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim) - Live browser preview
- [img-clip.nvim](https://github.com/HakonHarnes/img-clip.nvim) - Paste images from clipboard
- [bullets.vim](https://github.com/bullets-vim/bullets.vim) - Automated bullet lists

## Debugging
- [nvim-dap](https://github.com/mfussenegger/nvim-dap) - Debug Adapter Protocol client
  - Configured for Python (debugpy), Go (delve), JavaScript/TypeScript, PHP
- [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui) - UI for nvim-dap
- [nvim-dap-virtual-text](https://github.com/theHamsta/nvim-dap-virtual-text) - Virtual text for debugger
- [nvim-nio](https://github.com/nvim-neotest/nvim-nio) - Async IO library (dap-ui dependency)

## Code Navigation
- [outline.nvim](https://github.com/hedyhli/outline.nvim) - Code outline sidebar with symbols

## Folding
- [nvim-ufo](https://github.com/kevinhwang91/nvim-ufo) - Modern fold management
- [promise-async](https://github.com/kevinhwang91/promise-async) - Async library (ufo dependency)

## Indentation
- [mini.indentscope](https://github.com/echasnovski/mini.indentscope) - Animated indent scope highlighting
- [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) - Indent guides

## Integration
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) - Seamless tmux/vim navigation
- [tmux.nvim](https://github.com/aserowy/tmux.nvim) - Better tmux integration

## Container Management
- LazyDocker integration via Snacks terminal
  - Requires `lazydocker` CLI: `brew install lazydocker`
  - Opens in floating terminal window
  - Access via `<leader>cdL`

## Database Tools
- [vim-dadbod](https://github.com/tpope/vim-dadbod) - Database interface for Neovim
- [vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui) - Interactive database UI
- [vim-dadbod-completion](https://github.com/kristijanhusak/vim-dadbod-completion) - SQL completion source
  - Multiple database support (PostgreSQL, MySQL, SQLite, Redis, MongoDB)
  - Interactive drawer interface for browsing schemas
  - Query management and saved queries
  - Access via `<leader>Dt`

## Code Issues & Navigation
- [trouble.nvim](https://github.com/folke/trouble.nvim) - Pretty list for diagnostics, references, todos, and more
  - Enhanced error/warning list with preview
  - Workspace-wide diagnostics view
  - LSP references, definitions, and implementations
  - Todo comments navigation
  - Quickfix and location list enhancement
  - Access via `<leader>cx` prefix ("trouble")
- [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) - Highlight and search todo comments
  - Highlights TODO, FIXME, HACK, etc. in code
  - Integrates with Trouble for todo list
  - Navigate with `]t` and `[t`

## REST API Testing
- [kulala.nvim](https://github.com/mistweaverco/kulala.nvim) - REST client for testing APIs
  - Support for .http and .rest files
  - Environment variables and multiple environments
  - Response viewing in floating windows
  - cURL import/export
  - Access via `<leader>r` prefix


## Formatting
- [conform.nvim](https://github.com/stevearc/conform.nvim) - Fast async formatter
  - Prettier/Prettierd for web languages
  - Stylua for Lua
  - Ruff for Python
  - gofmt/goimports for Go
  - rustfmt for Rust
  - shfmt for Shell scripts

## Session Management
- [auto-session](https://github.com/rmagatti/auto-session) - Automatic session save/restore

## Additional Tools
- [sticky_pad.nvim](https://github.com/EtiamNullam/sticky_pad.nvim) - Sticky notes for quick temporary notes

## Utility Libraries
- [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Lua functions library (used by multiple plugins)

## Plugin Configuration

All plugins are managed by lazy.nvim with optimized loading:
- **Lazy Loading** - Plugins load on-demand
- **Event-based Loading** - Load on specific events
- **Command Loading** - Load when commands are used
- **Filetype Loading** - Load for specific file types

Configuration files are organized in `lua/plugins/`:
- `auto-session.lua` - Session management
- `bufferline.lua` - Buffer line setup
- `colorizer.lua` - Color highlighting
- `colorscheme.lua` - Theme configuration
- `database.lua` - Database tools
- `dap.lua` - Debugging setup
- `editor.lua` - Editor enhancements
- `flash.lua` - Flash navigation
- `formatting.lua` - Code formatting
- `go.lua` - Go development
- `harpoon.lua` - Quick navigation
- `indent.lua` - Indentation guides
- `lsp.lua` - Language servers
- `lualine.lua` - Status line
- `markdown.lua` - Markdown tools
- `outline.lua` - Code outline
- `php.lua` - PHP development
- `powershell.lua` - PowerShell support
- `python.lua` - Python development
- `rest.lua` - REST API client
- `rust.lua` - Rust development
- `snacks.lua` - Snacks.nvim suite
- `tmux.lua` - Tmux integration
- `treesitter.lua` - Syntax highlighting
- `trouble.lua` - Diagnostics UI
- `typescript.lua` - TypeScript/JavaScript
- `ui.lua` - UI improvements
- `which-key.lua` - Keybinding help

## Mason Auto-installed Tools

The following tools are automatically installed via Mason:

### Language Servers
- lua_ls, gopls, rust_analyzer, marksman, harper_ls
- bashls, powershell_es, pyright, ruff
- intelephense, vtsls, eslint, tailwindcss

### Debug Adapters
- codelldb (Rust/C/C++)
- debugpy (Python)
- php-debug-adapter
- js-debug-adapter

### Formatters
- prettier, prettierd
- Various language-specific formatters managed by conform.nvim

---
[← Back to Shell Scripting](development/shell.md) | [All Keybindings →](keymaps.md)