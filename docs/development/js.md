# JavaScript/TypeScript Development

Modern JavaScript and TypeScript development in Neovim with support for Vue 3, React, and Electron applications.

## Overview

This guide covers the complete setup for JavaScript/TypeScript development in Neovim, including LSP configuration, debugging, formatting, and framework-specific support.

## Language Servers

### TypeScript/JavaScript

**1. typescript-tools.nvim (Recommended)**
- Modern TypeScript plugin with better performance than standard tsserver
- Repository: https://github.com/pmizio/typescript-tools.nvim
- Features:
  - Faster than nvim-typescript
  - Better inlay hints support
  - Improved diagnostics
  - Native Neovim integration

```lua
{
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {
    settings = {
      -- spawn additional tsserver instance to calculate diagnostics on it
      separate_diagnostic_server = true,
      -- "change"|"insert_leave" determine when the client asks the server about diagnostic
      publish_diagnostic_on = "insert_leave",
      -- specify a list of plugins to load by tsserver
      tsserver_plugins = {},
      -- described below
      tsserver_format_options = {},
      tsserver_file_preferences = {},
      -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
      complete_function_calls = false,
      include_completions_with_insert_text = true,
      -- CodeLens
      code_lens = "off", -- "off" | "all" | "implementations_only" | "references_only"
      -- Inlay Hints
      jsx_close_tag = {
        enable = true,
        filetypes = { "javascriptreact", "typescriptreact" },
      }
    },
  },
}
```

**2. Standard TypeScript Language Server**
- Fallback option using tsserver via Mason
- Install: `typescript-language-server` in Mason

### ESLint Integration

Direct LSP integration (no need for eslint_d):

```lua
require'lspconfig'.eslint.setup({
  settings = {
    packageManager = 'npm', -- or 'yarn', 'pnpm'
    format = true, -- Enable formatting
  },
  on_attach = function(client, bufnr)
    -- Auto-fix on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end,
})
```

### Biome (Alternative to ESLint + Prettier)

Fast, Rust-based formatter and linter:

```lua
require'lspconfig'.biome.setup({
  -- Biome can replace both ESLint and Prettier
  single_file_support = true,
  root_dir = require'lspconfig'.util.root_pattern('biome.json', 'biome.jsonc'),
})
```

## Vue 3 Support

### Modern Vue Language Server Setup (2024)

Based on the latest Volar v2.0+ configuration:

```lua
-- Get the path to Vue language server from Mason
local mason_registry = require('mason-registry')
local vue_language_server_path = mason_registry.get_package('vue-language-server'):get_install_path() .. '/node_modules/@vue/language-server'

-- Configure TypeScript to understand Vue files
require'lspconfig'.ts_ls.setup {
  init_options = {
    plugins = {
      {
        name = '@vue/typescript-plugin',
        location = vue_language_server_path,
        languages = { 'vue' },
      },
    },
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
}

-- Configure Vue language server
require'lspconfig'.volar.setup {
  -- Takeover mode: Volar handles both .vue and .ts files
  -- filetypes = { 'vue', 'typescript', 'javascript' },
  
  -- Standard mode: Only handles .vue files
  filetypes = { 'vue' },
}
```

### Takeover Mode

For projects where you want Volar to handle all TypeScript checking:

1. Create `.neoconf.json` in your project root:
```json
{
  "lspconfig": {
    "tsserver": {
      "disable": true
    }
  }
}
```

2. Use folke/neoconf.nvim to respect project settings

### Vue 3 Setup Resources

- Reddit discussion on Vue 3 setups: https://www.reddit.com/r/neovim/comments/1d5jv15/anyone_got_a_good_vue3_setup/
- Detailed Vue 3 + TypeScript + Inlay Hints guide: https://dev.to/danwalsh/solved-vue-3-typescript-inlay-hint-support-in-neovim-53ej

Key points from community discussions:
- Many users prefer Volar's takeover mode for Vue projects
- Inlay hints require Neovim 0.10.0+
- Some users report better performance with typescript-tools.nvim than standard tsserver

## Formatting

### Prettier via conform.nvim

```lua
{
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" },
      vue = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
}
```

### Prettierd (Faster Alternative)

Daemon version of Prettier for better performance:
```lua
-- Replace "prettier" with "prettierd" in the config above
javascript = { "prettierd" },
```

## Debugging

### nvim-dap with vscode-js-debug

Complete debugging setup for Node.js, Chrome, and Electron:

```lua
-- Install debugger
{
  "mxsdev/nvim-dap-vscode-js",
  dependencies = {
    "mfussenegger/nvim-dap",
    {
      "microsoft/vscode-js-debug",
      opt = true,
      run = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
    }
  },
  config = function()
    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { 'chrome', 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost', 'node', 'chrome' },
    })
  end,
}
```

### Debug Configurations

```lua
local js_based_languages = { "typescript", "javascript", "typescriptreact", "javascriptreact", "vue" }

for _, language in ipairs(js_based_languages) do
  require("dap").configurations[language] = {
    -- Node.js
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require'dap.utils'.pick_process,
      cwd = "${workspaceFolder}",
    },
    -- Chrome/Electron
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Start Chrome & Debug",
      url = "http://localhost:8080",
      webRoot = "${workspaceFolder}",
      userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir"
    },
    -- Jest
    {
      type = "pwa-node",
      request = "launch",
      name = "Jest: current file",
      program = "${workspaceFolder}/node_modules/.bin/jest",
      args = { "${fileBasename}", "--coverage=false" },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    }
  }
end
```

## Framework-Specific Support

### React

- Use typescript-tools.nvim for TSX support
- Enable `jsx_close_tag` in settings
- Consider @react/eslint-plugin for React-specific linting

### Vue 3

- Use vue-language-server (Volar v2)
- Configure TypeScript plugin for .vue files
- Consider takeover mode for better performance

### Electron

- Configure separate tsconfig for main/renderer processes
- Use different debug configurations:
  - `pwa-node` for main process
  - `pwa-chrome` for renderer process
- Set up proper source maps for debugging

## Treesitter Configuration

```lua
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "javascript",
    "typescript",
    "tsx",
    "vue",
    "html",
    "css",
    "json",
    "jsdoc",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  autotag = {
    enable = true,
  },
}
```

## Essential Plugins

### For JavaScript/TypeScript

1. **nvim-ts-autotag** - Auto close/rename HTML tags
2. **nvim-ts-context-commentstring** - Better comment strings in JSX/TSX
3. **package-info.nvim** - Show package.json dependency versions
4. **SchemaStore.nvim** - JSON schemas for package.json, tsconfig.json, etc.

### Comparison with WebStorm

**Features Neovim Provides Natively or via Plugins:**
- ✅ Code completion (LSP)
- ✅ Go to definition/references (LSP)
- ✅ Rename refactoring (LSP)
- ✅ Error highlighting (LSP)
- ✅ Debugging (nvim-dap)
- ✅ Git integration (fugitive/gitsigns)
- ✅ File explorer (neo-tree)
- ✅ Fuzzy finding (telescope)

**Features That Are Different:**
- Project-wide refactoring: More limited, but LSP rename works well
- Database tools: Use vim-dadbod instead
- REST client: Use kulala.nvim instead
- Advanced debugging UI: nvim-dap-ui provides similar features
- Integrated terminal: Native Neovim terminal

**Advantages Over WebStorm:**
- Much faster startup and runtime performance
- Lower memory usage
- Highly customizable
- Better Vim motions and text manipulation
- Free and open source
- Can run on servers/containers

## Mason Packages to Install

Essential packages:
```
typescript-language-server
vue-language-server
eslint-lsp
prettier
prettierd
js-debug-adapter
```

Optional packages:
```
tailwindcss-language-server
css-lsp
html-lsp
json-lsp
yaml-language-server
```

## Keybindings

Suggested keybinding prefix: `<leader>dj` for JavaScript/TypeScript

```lua
-- Run/Build
vim.keymap.set('n', '<leader>djr', ':!node %<CR>', { desc = 'Run current file' })
vim.keymap.set('n', '<leader>djb', ':!npm run build<CR>', { desc = 'Build project' })
vim.keymap.set('n', '<leader>djt', ':!npm test<CR>', { desc = 'Run tests' })
vim.keymap.set('n', '<leader>djd', ':!npm run dev<CR>', { desc = 'Start dev server' })

-- Package management
vim.keymap.set('n', '<leader>dji', ':!npm install<CR>', { desc = 'Install dependencies' })
vim.keymap.set('n', '<leader>dju', ':!npm update<CR>', { desc = 'Update dependencies' })
```

## Tips for Electron Development

1. **Project Structure:**
   ```
   ├── src/
   │   ├── main/          # Main process (Node.js)
   │   ├── renderer/      # Renderer process (Browser)
   │   └── preload/       # Preload scripts
   ├── tsconfig.json      # Base config
   ├── tsconfig.main.json # Main process config
   └── tsconfig.renderer.json # Renderer config
   ```

2. **Debugging Setup:**
   - Main process: Use Node.js debug configuration
   - Renderer process: Use Chrome debug configuration with proper webRoot

3. **Type Safety:**
   - Use proper IPC typing with TypeScript
   - Share types between main and renderer via a common types file

## Common Issues and Solutions

### Vue + TypeScript Issues

1. **Types not working in .vue files:**
   - Ensure @vue/typescript-plugin is properly configured
   - Check that TypeScript server includes 'vue' in filetypes

2. **Slow performance:**
   - Consider using takeover mode
   - Try typescript-tools.nvim instead of standard tsserver

### General Issues

1. **ESLint not auto-fixing:**
   - Ensure EslintFixAll autocmd is set up
   - Check that ESLint LSP has format capability enabled

2. **Prettier conflicts with LSP formatting:**
   - Disable LSP formatting when using Prettier
   - Use conform.nvim to manage formatters

3. **Debug adapter not working:**
   - Ensure vscode-js-debug is properly built
   - Check that adapter paths are correct