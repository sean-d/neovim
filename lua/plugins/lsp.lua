return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Setup mason first
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
      
      -- Auto-install DAP adapters and other tools
      local registry = require("mason-registry")
      local packages_to_install = { 
        "codelldb", 
        "debugpy", 
        "php-debug-adapter",
        "js-debug-adapter",
        "prettier",
        "prettierd",
      }
      
      for _, package_name in ipairs(packages_to_install) do
        local ok, pkg = pcall(registry.get_package, package_name)
        if ok and not pkg:is_installed() then
          vim.notify("Installing " .. package_name)
          pkg:install()
        end
      end

      -- Setup mason-lspconfig
      -- Only auto-install LSPs when not in a Docker container (container should have its own)
      local in_docker_container = vim.fn.filereadable("/.dockerenv") == 1 or vim.fn.filereadable("/run/.containerenv") == 1
      
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "gopls", -- Go language server
          "rust_analyzer", -- Rust language server (managed by rustaceanvim)
          "marksman", -- Markdown LSP
          "harper_ls", -- Markdown grammar/spelling
          "bashls", -- Bash language server
          "powershell_es", -- PowerShell Editor Services
          "pyright", -- Python type checker
          "ruff", -- Python linter/formatter
          "intelephense", -- PHP language server (better for WordPress)
          "vtsls", -- TypeScript language server with Vue support
          "eslint", -- ESLint language server
          "tailwindcss", -- Tailwind CSS language server
        },
        automatic_installation = not in_docker_container, -- Don't auto-install in containers
      })

      -- LSP keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Navigation
          -- gd is handled in keymaps.lua for custom preview
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")
          -- Use quickfix for implementations and references for consistency
          map("gI", function() 
            vim.lsp.buf.implementation({ 
              on_list = function(options) 
                vim.fn.setqflist({}, ' ', options) 
                vim.cmd('copen') 
              end 
            }) 
          end, "Goto Implementation")
          map("gr", function() 
            vim.lsp.buf.references(nil, { 
              on_list = function(options) 
                vim.fn.setqflist({}, ' ', options) 
                vim.cmd('copen') 
              end 
            }) 
          end, "References")
          map("gy", vim.lsp.buf.type_definition, "Goto Type Definition")
          
          -- Documentation
          -- Use custom hover that handles various formats better
          map("K", function() require("config.definition-preview").hover() end, "Hover Documentation")
          map("gK", vim.lsp.buf.signature_help, "Signature Help")
          
          -- Code actions
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")
          
          -- Diagnostics
          map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")
          map("[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
          map("]d", vim.diagnostic.goto_next, "Next Diagnostic")
        end,
      })

      -- Diagnostic config is now in options.lua for early loading

      -- LSP servers configuration
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  "${3rd}/luv/library",
                },
              },
              completion = {
                callSnippet = "Replace",
              },
              telemetry = { enable = false },
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
        -- gopls will be configured by go.nvim
        
        -- Markdown servers
        marksman = {}, -- Markdown LSP for completion and navigation
        harper_ls = {   -- Grammar and spell checking for markdown
          filetypes = { "markdown", "text", "gitcommit" },
          settings = {
            ["harper-ls"] = {
              linters = {
                spell_check = true,
                spelled_numbers = false,
                an_a = true,
                sentence_capitalization = true,
                unclosed_quotes = true,
                wrong_quotes = false,
                long_sentences = true,
                repeated_words = true,
                spaces = true,
                matcher = true,
                correct_number_suffix = true,
                number_suffix_capitalization = true,
                multiple_sequential_pronouns = true,
              },
            },
          },
        },
        
        -- Shell scripting
        bashls = {
          filetypes = { "sh", "bash", "zsh" },
          settings = {
            bashIde = {
              globPattern = "*@(.sh|.inc|.bash|.zsh|.command)",
            },
          },
        },
        
        -- PowerShell
        powershell_es = {
          filetypes = { "ps1", "psm1", "psd1" },
          bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
          settings = {
            powershell = {
              codeFormatting = {
                preset = "OTBS", -- One True Brace Style
                openBraceOnSameLine = true,
                newLineAfterOpenBrace = true,
                newLineAfterCloseBrace = true,
                whitespaceBeforeOpenBrace = true,
                whitespaceBeforeOpenParen = true,
                whitespaceAroundOperator = true,
                whitespaceAfterSeparator = true,
                ignoreOneLineBlock = true,
                alignPropertyValuePairs = true,
              },
              scriptAnalysis = {
                enable = true,
                settingsPath = "PSScriptAnalyzerSettings.psd1",
              },
              integratedConsole = {
                showBanner = false,
              },
            },
          },
        },
        
        -- Python
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "standard",
                -- Respect the venv
                venvPath = ".",
                venv = ".venv",
              },
            },
          },
        },
        
        ruff = {
          -- Ruff will automatically use the version from activated venv if available
          init_options = {
            settings = {
              -- Ruff replaces black, isort, flake8, and more
              lint = {
                enable = true,
                select = {
                  -- Pyflakes
                  "F",
                  -- Pycodestyle
                  "E", "W",
                  -- isort
                  "I",
                  -- pep8-naming  
                  "N",
                  -- pyupgrade
                  "UP",
                  -- flake8-bugbear
                  "B",
                  -- flake8-comprehensions
                  "C4",
                },
              },
              format = {
                enable = true,
              },
            },
          },
        },
        
        -- PHP
        intelephense = {
          filetypes = { "php" },
          settings = {
            intelephense = {
              -- WordPress stubs for better completions
              stubs = {
                "bcmath", "bz2", "calendar", "Core", "curl", "date", 
                "dba", "dom", "enchant", "exif", "fileinfo", "filter", 
                "ftp", "gd", "gettext", "hash", "iconv", "imap", "intl", 
                "json", "ldap", "libxml", "mbstring", "mcrypt", "mysql", 
                "mysqli", "password", "pcntl", "pcre", "PDO", "pdo_mysql", 
                "Phar", "readline", "recode", "Reflection", "regex", "session", 
                "SimpleXML", "soap", "sockets", "sodium", "SPL", "standard", 
                "superglobals", "tidy", "tokenizer", "xml", "xdebug", "xmlreader", 
                "xmlrpc", "xmlwriter", "yaml", "Zend OPcache", "zip", "zlib",
                "wordpress", "wordpress-globals", "wordpress-stubs", "wp-cli"
              },
              -- Files to exclude from indexing
              files = {
                exclude = {
                  "**/.git/**",
                  "**/.svn/**",
                  "**/.hg/**",
                  "**/vendor/**/{Tests,tests}/**",
                  "**/.history/**",
                  "**/node_modules/**",
                  "**/bower_components/**",
                  "**/wp-admin/**",
                  "**/wp-includes/**",
                },
              },
              -- Environment
              environment = {
                phpVersion = "8.2", -- WordPress 6.4+ recommends PHP 8.1+
              },
              -- WordPress specific settings
              wordpress = {
                enabled = true,
              },
              -- Format settings
              format = {
                enable = true,
                braces = "k&r", -- WordPress coding standards use K&R style
              },
              -- Completion settings
              completion = {
                insertUseDeclaration = true,
                fullyQualifyGlobalConstantsAndFunctions = false,
                triggerParameterHints = true,
                maxItems = 100,
              },
              -- Diagnostics
              diagnostics = {
                enable = true,
                run = "onType",
                undefinedSymbols = true,
                undefinedVariables = true,
                undefinedTypes = true,
                undefinedFunctions = true,
                undefinedConstants = true,
                undefinedClassConstants = true,
                undefinedMethods = true,
                undefinedProperties = true,
                unreachableCode = true,
                unusedSymbols = true,
                languageConstraints = true,
                deprecation = true,
              },
            },
          },
        },
        
        -- JavaScript/TypeScript with Vue support
        vtsls = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = "",  -- Will be set in before_init
                languages = { "javascript", "typescript", "vue" },
              },
            },
          },
          on_attach = function(client, bufnr)
            -- Disable formatting (we'll use prettier)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            -- Disable document highlight for Vue files to avoid errors
            if vim.bo[bufnr].filetype == "vue" then
              client.server_capabilities.documentHighlightProvider = false
            end
          end,
          -- This is critical for Vue support
          before_init = function(_, config)
            -- Get the project root
            local root = vim.fn.getcwd()
            local vue_plugin_path = root .. "/node_modules/@vue/typescript-plugin"
            
            -- Check if plugin exists and update init_options
            if vim.fn.isdirectory(vue_plugin_path) == 1 then
              config.init_options = config.init_options or {}
              config.init_options.plugins = config.init_options.plugins or {}
              -- Update the plugin location
              for _, plugin in ipairs(config.init_options.plugins) do
                if plugin.name == "@vue/typescript-plugin" then
                  plugin.location = vue_plugin_path
                end
              end
            end
          end,
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                parameterNames = { enabled = "literals" },
                parameterTypes = { enabled = true },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                enumMemberValues = { enabled = true },
              },
            },
          },
        },
        
        -- ESLint
        eslint = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
          on_attach = function(client, bufnr)
            -- Auto fix on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
          settings = {
            format = true,
            packageManager = "npm", -- or "yarn", "pnpm"
          },
        },
        
        -- Tailwind CSS
        tailwindcss = {
          filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                  { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                  { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                },
              },
            },
          },
        },
        
      }

      -- Setup servers
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        require("lspconfig")[server].setup(config)
      end
      
      -- Note: rust_analyzer is handled by rustaceanvim plugin, not here
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      
      -- Load friendly snippets
      require("luasnip.loaders.from_vscode").lazy_load()
      
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.kind = string.format("%s %s", vim_item.kind, entry.source.name)
            return vim_item
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      })

      -- Command line completion
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      -- Search completion
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })
    end,
  },

  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
}