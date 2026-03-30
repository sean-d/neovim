return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufWritePost", "BufNewFile", "VeryLazy" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    config = function()
      -- New API: setup() only accepts install_dir
      require("nvim-treesitter").setup()

      -- Install parsers that are not yet installed
      local ensure_installed = {
        "bash", "go", "gomod", "gosum", "gowork", "html",
        "javascript", "json", "lua", "luadoc", "luap",
        "markdown", "markdown_inline", "query", "regex",
        "toml", "tsx", "typescript", "vim", "vimdoc",
        "xml", "yaml", "vue", "css", "scss", "jsdoc",
      }
      local installed = require("nvim-treesitter.config").get_installed()
      local to_install = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, ensure_installed)
      if #to_install > 0 then
        require("nvim-treesitter.install").install(to_install)
      end

      -- Enable treesitter highlighting (replaces the old highlight module)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- Enable treesitter indentation (replaces the old indent module)
      -- Skip python as it has issues with treesitter indent
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
          if vim.bo.filetype ~= "python" then
            local ok = pcall(vim.treesitter.get_parser, 0)
            if ok then
              vim.opt_local.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
            end
          end
        end,
      })
    end,
  },

  -- Show context of the current function
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = false, -- Temporarily disabled
    event = "VeryLazy",
    opts = {
      max_lines = 3,
      multiline_threshold = 20,
      trim_scope = "outer",
    },
  },
}
