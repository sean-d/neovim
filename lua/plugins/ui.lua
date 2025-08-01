return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "bwpge/lualine-pretty-path",
    },
    opts = function()
      local icons = {
        diagnostics = {
          Error = "󰅚 ", -- nf-md-close_circle
          Warn = "󰀪 ", -- nf-md-alert  
          Hint = "󰌶 ", -- nf-md-lightbulb
          Info = "󰋽 ", -- nf-md-information
        },
        git = {
          added = " ",
          modified = " ",
          removed = " ",
        },
      }

      -- Custom function to show attached LSP clients
      local function clients_lsp()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr })
        if next(clients) == nil then
          return ""
        end

        local c = {}
        for _, client in pairs(clients) do
          table.insert(c, client.name)
        end
        return " " .. table.concat(c, " | ")
      end

      -- Custom Catppuccin theme with proper colors
      local custom_catppuccin = require("lualine.themes.catppuccin")
      -- Override the blue with Catppuccin mauve
      custom_catppuccin.normal.a.bg = "#cba6f7"
      custom_catppuccin.normal.b.fg = "#cad3f5"
      custom_catppuccin.normal.c.fg = "#cad3f5"

      return {
        options = {
          theme = custom_catppuccin,
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              "pretty_path",
              highlights = {
                modified = { fg = "#f38ba8" }, -- Catppuccin red for modified
                directory = { fg = "#6c7086" }, -- Catppuccin overlay0 (dimmed)
                filename = { fg = "#cdd6f4" }, -- Catppuccin text (bright)
                path_sep = { fg = "#6c7086" }, -- Same as directory
              },
            },
          },
          lualine_x = {
            {
              -- Docker container status (cached, safe)
              function()
                -- Only show cached status, never call system commands
                local ok, docker = pcall(require, "config.docker")
                if ok and docker.status then
                  return docker.status()
                end
                return ""
              end,
              cond = function()
                -- Only show if docker module is loaded and has cached status
                local ok, docker = pcall(require, "config.docker")
                return ok and docker._cached_status ~= nil
              end,
              color = { fg = "#89dceb" }, -- Catppuccin Sky
              padding = { left = 1, right = 1 },
            },
            {
              -- Python virtual environment indicator
              function()
                if vim.bo.filetype ~= "python" then
                  return ""
                end
                
                local venv = vim.env.VIRTUAL_ENV
                if venv then
                  local venv_name = vim.fn.fnamemodify(venv, ":t")
                  -- If venv name is generic (.venv), use the parent directory name
                  if venv_name == ".venv" or venv_name == "venv" then
                    local project_dir = vim.fn.fnamemodify(venv, ":h")
                    venv_name = vim.fn.fnamemodify(project_dir, ":t")
                  end
                  
                  -- Try to get Python version efficiently
                  local python = venv .. "/bin/python"
                  local handle = io.popen(python .. " --version 2>&1")
                  local version = handle:read("*a"):gsub("Python ", ""):gsub("\n", "")
                  handle:close()
                  
                  return string.format("🐍 %s (%s)", version, venv_name)
                end
                
                -- No venv active
                return "🐍 No venv"
              end,
              cond = function()
                return vim.bo.filetype == "python"
              end,
              color = { fg = "#f9e2af" }, -- Catppuccin Yellow
              padding = { left = 1, right = 1 },
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            },
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            },
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            },
          },
          lualine_y = {
            {
              -- Language version component
              function()
                -- Cache versions to avoid repeated system calls
                if not _G.lang_versions then
                  _G.lang_versions = {}
                end
                
                local ft = vim.bo.filetype
                if ft == "go" then
                  if not _G.lang_versions.go then
                    local version = vim.fn.system("go version 2>/dev/null"):match("go(%d+%.%d+%.?%d*)")
                    _G.lang_versions.go = version and ("󰟓 " .. version) or ""
                  end
                  return _G.lang_versions.go
                elseif ft == "python" then
                  if not _G.lang_versions.python then
                    local version = vim.fn.system("python3 --version 2>&1"):match("Python (%d+%.%d+%.?%d*)")
                    _G.lang_versions.python = version and (" " .. version) or ""
                  end
                  return _G.lang_versions.python
                elseif ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
                  if not _G.lang_versions.node then
                    local version = vim.fn.system("node --version 2>/dev/null"):match("v(%d+%.%d+%.%d+)")
                    _G.lang_versions.node = version and ("󰎙 " .. version) or ""
                  end
                  return _G.lang_versions.node
                elseif ft == "rust" then
                  if not _G.lang_versions.rust then
                    local version = vim.fn.system("rustc --version 2>/dev/null"):match("rustc (%d+%.%d+%.%d+)")
                    _G.lang_versions.rust = version and ("󱘗 " .. version) or ""
                  end
                  return _G.lang_versions.rust
                elseif ft == "lua" then
                  if not _G.lang_versions.lua then
                    local version = vim.fn.system("lua -v 2>/dev/null"):match("Lua (%d+%.%d+%.?%d*)")
                    _G.lang_versions.lua = version and (" " .. version) or ""
                  end
                  return _G.lang_versions.lua
                elseif ft == "php" then
                  if not _G.lang_versions.php then
                    local version = vim.fn.system("php --version 2>/dev/null"):match("PHP (%d+%.%d+%.?%d*)")
                    _G.lang_versions.php = version and (" " .. version) or ""
                  end
                  return _G.lang_versions.php
                end
                return ""
              end,
              cond = function()
                local ft = vim.bo.filetype
                return ft == "go" or ft == "python" or ft == "javascript" or ft == "typescript" or 
                       ft == "javascriptreact" or ft == "typescriptreact" or ft == "rust" or ft == "lua" or ft == "php"
              end,
              color = { fg = "#f5c2e7" }, -- Pink to match your theme
              padding = { left = 1, right = 1 },
            },
            {
              -- Filetype with icon for non-programming languages
              function()
                local ft = vim.bo.filetype
                local filetype_icons = {
                  markdown = " ",      -- nf-md-language_markdown
                  ps1 = " ",           -- nf-md-powershell  
                  perl = " ",           -- nf-md-perl  
                  sh = "󱆃 ",            -- nf-md-bash
                  bash = "󱆃 ",          -- nf-md-bash
                  zsh = "󱆃 ",           -- nf-md-bash (using same icon)
                  fish = "󰈺 ",          -- nf-md-fish
                  vim = " ",           -- nf-dev-vim
                  json = " ",          -- nf-md-code_json
                  yaml = "󰬆 ",          -- nf-md-file_document_outline
                  toml = "󰬁 ",          -- nf-md-file_document_outline
                  xml = "󰗀 ",           -- nf-md-xml
                  html = " ",          -- nf-md-language_html5
                  css = " ",           -- nf-md-language_css3
                  sql = " ",           -- nf-md-database
                  dockerfile = " ",    -- nf-md-docker
                  docker = " ",        -- nf-md-docker
                  ["docker-compose"] = " ", -- nf-md-docker
                }
                
                local icon = filetype_icons[ft]
                if icon then
                  return icon .. ft
                end
                return ""
              end,
              cond = function()
                local ft = vim.bo.filetype
                -- Show for file types that don't have language version display
                local has_version = ft == "go" or ft == "python" or ft == "javascript" or ft == "typescript" or 
                                   ft == "javascriptreact" or ft == "typescriptreact" or ft == "rust" or ft == "lua" or ft == "php"
                return not has_version and ft ~= ""
              end,
              color = { fg = "#89dceb" }, -- Catppuccin Sky
              padding = { left = 1, right = 1 },
            },
          },
          lualine_z = {
            { "location", padding = { left = 1, right = 1 } },
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },

  -- Better UI elements
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

}
