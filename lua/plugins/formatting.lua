return {
  -- Formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        -- JavaScript/TypeScript
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        
        -- Web
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        
        -- Other languages (already configured elsewhere)
        lua = { "stylua" },
        python = { "ruff_format" },
        go = { "gofmt", "goimports" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        
        -- Use the "_" filetype to run formatters on filetypes that don't have other formatters
        ["_"] = { "trim_whitespace" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters = {
        prettier = {
          -- Use prettierd for better performance
          command = "prettierd",
          condition = function(self, ctx)
            -- Only use prettier if config file exists
            return vim.fs.find({
              ".prettierrc",
              ".prettierrc.json",
              ".prettierrc.yml",
              ".prettierrc.yaml",
              ".prettierrc.json5",
              ".prettierrc.js",
              ".prettierrc.cjs",
              ".prettierrc.mjs",
              ".prettierrc.toml",
              "prettier.config.js",
              "prettier.config.cjs",
              "prettier.config.mjs",
            }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
    init = function()
      -- Format on save
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}