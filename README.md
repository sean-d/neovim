# My Neovim Configuration

A modern Neovim setup optimized for Go development with a focus on productivity and clean UI.

## Features

- 🚀 **Plugin Manager**: [lazy.nvim](https://github.com/folke/lazy.nvim) for fast startup
- 🎨 **Theme**: [Catppuccin Macchiato](https://github.com/catppuccin/nvim)
- 🔍 **Fuzzy Finder**: [snacks.picker](https://github.com/folke/snacks.nvim) (modern alternative to Telescope)
- 📝 **LSP**: Full language server support with automatic installation
- 🐹 **Go Development**: Comprehensive Go tooling with [go.nvim](https://github.com/ray-x/go.nvim)
- ⌨️ **Keybinding Help**: [which-key](https://github.com/folke/which-key.nvim) for discovering commands

## Installation

1. Backup your existing Neovim configuration:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. Clone this configuration:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. Start Neovim - plugins will auto-install on first launch:
   ```bash
   nvim
   ```

## Key Mappings

Leader key: `<Space>`

### Essential Navigation
| Key | Description |
|-----|-------------|
| `<leader><space>` | Find files |
| `<leader>/` | Search in project (grep) |
| `<leader>,` | Switch buffers |
| `<leader>?` | Show keybindings (which-key) |

### Window Management
| Key | Description |
|-----|-------------|
| `<C-h/j/k/l>` | Navigate between windows |
| `<leader>w-` | Split window horizontally |
| `<leader>w\|` | Split window vertically |
| `<leader>wd` | Close window |

### Code Navigation
| Key | Description |
|-----|-------------|
| `gd` | Go to definition |
| `gr` | Find references |
| `K` | Hover documentation |
| `<leader>ca` | Code actions |
| `<leader>cr` | Rename symbol |

### File Management
| Key | Description |
|-----|-------------|
| `<leader>ff` | Find files |
| `<leader>fg` | Find git files |
| `<leader>fr` | Recent files |
| `<leader>fb` | Browse buffers |

### Go Development
| Key | Description |
|-----|-------------|
| `<leader>gt` | Run Go tests |
| `<leader>gT` | Run test for current function |
| `<leader>gc` | Show test coverage |
| `<leader>gi` | Organize imports |
| `<leader>gm` | Run go mod tidy |
| `<leader>gd` | Show Go documentation |

### Git Integration
| Key | Description |
|-----|-------------|
| `<leader>gg` | Open Lazygit |
| `<leader>gb` | Git blame current line |
| `]h` | Next git hunk |
| `[h` | Previous git hunk |
| `<leader>ghs` | Stage hunk |
| `<leader>ghr` | Reset hunk |

### Code Folding
| Key | Description |
|-----|-------------|
| `za` | Toggle fold |
| `zc` | Close fold |
| `zo` | Open fold |
| `zM` | Close all folds |
| `zR` | Open all folds |
| `zp` | Peek folded content |

### Picker Navigation (in snacks.picker)
| Key | Description |
|-----|-------------|
| `<C-f>` | Toggle focus between list and preview |
| `<C-p>` | Scroll preview up |
| `<C-n>` | Scroll preview down |
| `<Enter>` | Open selected file |
| `<Esc>` | Close picker |

### Text Editing
| Key | Description |
|-----|-------------|
| `gcc` | Comment/uncomment line |
| `gc` | Comment/uncomment selection (visual mode) |
| `cs"'` | Change surrounding quotes from " to ' |
| `ds"` | Delete surrounding quotes |
| `ysiw"` | Add quotes around word |

## Plugins Overview

### Core Plugins
- **lazy.nvim** - Plugin manager
- **snacks.nvim** - Collection of small useful plugins (picker, dashboard, notifications)
- **which-key.nvim** - Displays available keybindings
- **mini.icons** - File icons (lightweight alternative to nvim-web-devicons)

### Editor Enhancement
- **nvim-treesitter** - Better syntax highlighting and code understanding
- **nvim-autopairs** - Auto close brackets and quotes
- **nvim-surround** - Easily change surrounding characters
- **Comment.nvim** - Smart commenting
- **gitsigns.nvim** - Git integration and signs
- **stay-centered.nvim** - Keep cursor line centered
- **nvim-ufo** - Better code folding

### Development
- **nvim-lspconfig** - LSP configuration
- **mason.nvim** - LSP server installer
- **nvim-cmp** - Autocompletion
- **go.nvim** - Go development tools
- **nvim-dap** - Debugging support

### UI
- **catppuccin** - Beautiful pastel theme
- **lualine.nvim** - Statusline
- **indent-blankline.nvim** - Show indent guides
- **dressing.nvim** - Better UI for input/select

## Tips & Tricks

### Fuzzy Finding
- When in picker, type patterns like `models user` to find `models/user.go`
- Use `<C-f>` to preview files before opening

### Go Development
- Save files to auto-format and organize imports
- Use `<leader>gt` before committing to ensure tests pass
- Hover over any symbol with `K` for documentation

### Navigation
- Use `gd` to jump to definitions, `<C-o>` to jump back
- `<leader><space>` is your quick file finder
- `<leader>/` to search across all files

### Window Management
- Use `<C-w>` followed by `h/j/k/l` for window navigation
- `<leader>w` prefix for window operations

## Customization

### Adding New Plugins
Create a new file in `lua/plugins/` or add to existing category files:
```lua
return {
  {
    "username/plugin-name",
    event = "VeryLazy",  -- Lazy load
    config = function()
      require("plugin-name").setup({
        -- options
      })
    end,
  },
}
```

### Modifying Keybindings
Edit `lua/config/keymaps.lua` for general keybindings or add them in plugin specs.

### Changing Theme
Edit `lua/plugins/colorscheme.lua` and change the theme name and options.

## Troubleshooting

### Plugins not loading
1. Run `:Lazy sync` to ensure all plugins are installed
2. Check `:checkhealth` for any issues

### LSP not working
1. Run `:LspInfo` to check server status
2. Run `:Mason` to install/update language servers

### Go features not working
1. Ensure Go is installed: `go version`
2. Install Go tools: `:GoInstallBinaries`
3. Check gopls is running: `:LspInfo`

## Resources

- [Neovim Documentation](https://neovim.io/doc/)
- [Lazy.nvim Guide](https://github.com/folke/lazy.nvim)
- [Which-key Help](https://github.com/folke/which-key.nvim)
- [Go.nvim Documentation](https://github.com/ray-x/go.nvim)