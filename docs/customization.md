# Customization Guide

Learn how to customize and extend this Neovim configuration to suit your needs.

## Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Entry point, bootstraps lazy.nvim
├── lua/
│   ├── config/
│   │   ├── options.lua     # Neovim options
│   │   ├── keymaps.lua     # Global keymappings
│   │   ├── dev-keymaps.lua # Language development keymaps
│   │   ├── docker.lua      # Docker integration
│   │   ├── definition-preview.lua # Custom LSP preview
│   │   └── *-dev-windows.lua # Language-specific windows
│   ├── plugins/            # Plugin configurations
│   │   ├── lsp.lua         # Language server setup
│   │   ├── colorscheme.lua # Theme configuration
│   │   └── ...             # Other plugin configs
│   └── util/               # Utility modules
│       ├── lsp.lua         # LSP utilities
│       └── docker.lua      # Docker utilities
└── docs/                   # Documentation
```

## Adding Plugins

### 1. Create Plugin Spec
Create a new file in `lua/plugins/` or add to existing:

```lua
-- lua/plugins/my-plugin.lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",  -- Lazy load
    dependencies = {
      "required/dependency",
    },
    opts = {
      -- Plugin options
      setting1 = true,
      setting2 = "value",
    },
    config = function(_, opts)
      require("plugin-name").setup(opts)
      -- Additional configuration
    end,
    keys = {
      { "<leader>mp", "<cmd>PluginCommand<cr>", desc = "Plugin command" },
    },
  },
}
```

### 2. Loading Strategies

#### Lazy Loading Events
- `VeryLazy` - After UI loads
- `BufReadPre` - Before reading buffer
- `InsertEnter` - When entering insert mode
- `CmdlineEnter` - When entering command line

#### Filetype Loading
```lua
ft = { "go", "lua" },  -- Load for specific filetypes
```

#### Command Loading
```lua
cmd = { "PluginCommand" },  -- Load when command used
```

#### Key Loading
```lua
keys = {
  { "<leader>x", desc = "Load and run" },
},
```

## Adding Language Support

### 1. Install LSP Server
Add to `lua/plugins/lsp.lua`:

```lua
ensure_installed = {
  "gopls",
  "lua_ls",
  "pyright",  -- Add Python support
},
```

### 2. Configure LSP
Add to the servers table in `lua/plugins/lsp.lua`:

```lua
local servers = {
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "basic",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
        },
      },
    },
  },
  -- Other servers...
}
```

The servers are automatically configured with capabilities and keymaps via the LspAttach autocmd.

### 3. Add Debug Support
Create debug adapter configuration:

```lua
-- In lua/plugins/dap.lua or new file
local dap = require("dap")
dap.adapters.python = {
  type = "executable",
  command = "python",
  args = { "-m", "debugpy.adapter" },
}
```

### 4. Language-Specific Plugins
```lua
-- lua/plugins/python.lua
return {
  {
    "python-specific/plugin",
    ft = "python",
    config = function()
      -- Python-specific setup
    end,
  },
}
```

## Customizing Keybindings

### Global Keymaps
Edit `lua/config/keymaps.lua`:

```lua
-- The config uses a map wrapper function
local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Your custom mapping
map("n", "<leader>xx", "<cmd>YourCommand<cr>", { desc = "Your description" })

-- With function
map("n", "<leader>xy", function()
  -- Your Lua code here
  print("Custom action!")
end, { desc = "Custom action" })
```

### Plugin-Specific Keymaps
In plugin spec:

```lua
keys = {
  { "<leader>ab", "<cmd>PluginCmd<cr>", desc = "Description" },
  { "<leader>ac", function() require("plugin").action() end, desc = "Action" },
},
```

### Which-key Groups
Add groups in `lua/plugins/which-key.lua` using the v3 spec format:

```lua
opts = {
  spec = {
    {
      mode = { "n", "v" },
      { "<leader>a", group = "ai" },
      { "<leader>ab", desc = "Browse models" },
      { "<leader>ac", desc = "Chat with AI" },
    },
  },
}
```

## Customizing UI

### Changing Colors
Override highlights after colorscheme:

```lua
-- In colorscheme config function
vim.api.nvim_set_hl(0, "Normal", { bg = "#1a1a2e" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#your-color" })
```

### Status Line
Modify `lua/plugins/lualine.lua`:

```lua
sections = {
  lualine_a = { "mode" },
  lualine_b = { "branch", "diff" },
  lualine_c = { "filename" },
  lualine_x = { "filetype" },
  lualine_y = { "progress" },
  lualine_z = { "location" },
}
```

### Dashboard
Edit `lua/plugins/snacks.lua`:

```lua
dashboard = {
  preset = {
    header = [[
      Your ASCII art
    ]],
    keys = {
      { icon = "icon", key = "x", desc = "Action", action = ":command" },
    },
  },
}
```

## Creating Custom Commands

### Vim Commands
```lua
vim.api.nvim_create_user_command("MyCommand", function(opts)
  -- Command logic
  print("Args:", opts.args)
end, {
  nargs = "*",  -- Number of args
  desc = "My custom command",
})
```

### Lua Functions
```lua
-- In lua/config/commands.lua
_G.my_custom_function = function()
  -- Your code
end

-- Use in mapping
keymap("n", "<leader>z", "<cmd>lua my_custom_function()<cr>")
```

## Auto Commands

Create autocmds directly in your plugin configs or in a dedicated file:

```lua
-- In plugin config or separate file
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
  end,
  group = vim.api.nvim_create_augroup("PythonSettings", { clear = true }),
})

-- LspAttach is commonly used for LSP keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    -- Buffer-local LSP keymaps
  end,
})
```

## Performance Tips

### Lazy Loading
- Use events wisely
- Load on specific filetypes
- Defer non-essential plugins

### Optimize Startup
```vim
:Lazy profile  " Check load times
```

### Disable Features
In plugin opts:
```lua
enabled = false,  -- Disable specific features
```

## Debugging Configuration

### Check Health
```vim
:checkhealth
:checkhealth plugin-name
```

### View Logs
```vim
:Lazy log
:LspLog
:messages
```

### Test in Isolation
```bash
nvim -u NONE  # Start without config
nvim --clean  # Start with defaults
```

## Development Keymaps System

This configuration uses a global development keymap system for language-specific commands:

### Adding Language Keymaps
Edit `lua/config/dev-keymaps.lua`:

```lua
-- Define language-specific keymaps
local lang_keymaps = {
  python = {
    { "r", ":TermExec cmd='python %'<CR>", "Run file" },
    { "t", ":TermExec cmd='pytest %'<CR>", "Test file" },
    -- Add more...
  },
}

-- Register with prefix
setup_language_keymaps("py", lang_keymaps.python, "Python")
```

### Language Development Windows
Create custom tool windows in `lua/config/python-dev-windows.lua`:

```lua
return {
  {
    key = "p",
    cmd = "pip list",
    title = "Installed Packages",
    syntax = "text",
  },
  {
    key = "r",
    cmd = "python -m pytest",
    title = "Run Tests",
    syntax = "python",
  },
}
```

## Debug Adapter Configuration

### Adding a New Debugger
Configure in your language plugin or DAP config:

```lua
local dap = require("dap")

-- Python example
dap.adapters.python = {
  type = "executable",
  command = vim.fn.exepath("debugpy-adapter"),
}

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return vim.fn.exepath("python")
    end,
  },
}
```

## Session Management

Sessions are automatically saved every 30 seconds. Customize in plugin config:

```lua
-- In auto-session plugin config
opts = {
  auto_save = true,
  auto_restore = true,
  auto_session_suppress_dirs = { "~/", "/" },
}
```

## Mason Package Management

Mason handles installation of LSP servers, formatters, linters, and debuggers:

### Installing Additional Tools
```lua
-- In lua/plugins/lsp.lua
opts = {
  ensure_installed = {
    -- LSP servers
    "lua_ls",
    "pyright",
    
    -- Formatters
    "prettier",
    "stylua",
    "black",
    
    -- Debuggers
    "debugpy",
    "codelldb",
  },
}
```

### Manual Installation
```vim
:Mason              " Open Mason UI
:MasonInstall black " Install specific tool
:MasonUpdate       " Update all tools
```

## Docker Integration

The configuration includes async Docker operations. Customize in `lua/config/docker.lua`:

```lua
-- Add custom Docker commands
vim.keymap.set("n", "<leader>cdp", function()
  require("util.docker").docker_command("ps -a", "Docker Processes")
end, { desc = "Docker processes" })
```

## Best Practices

1. **Modular Configuration** - One file per plugin/feature
2. **Use Lazy Loading** - Don't load everything at startup
3. **Document Changes** - Add descriptions to mappings
4. **Version Control** - Commit your customizations
5. **Test Changes** - Use `:source %` to test without restart

## Sharing Configuration

### Fork and Customize
1. Fork the repository
2. Make your changes
3. Push to your fork
4. Share your fork URL

### Extract Modules
Create reusable plugin specs:
```lua
-- my-module.lua
return {
  setup = function()
    -- Module setup
  end,
  plugins = {
    -- Plugin specs
  },
}
```

---
[← Back to Installation](installation.md) | [Navigation →](navigation.md)