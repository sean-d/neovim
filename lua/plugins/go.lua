return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("go").setup({
        -- Enable features
        goimports = "gopls", -- Use gopls for imports
        gofmt = "golines", -- Use golines for formatting with line length limit
        max_line_len = 120,
        tag_transform = false,
        tag_options = "json=omitempty",
        test_dir = "",
        comment_placeholder = " ",
        
        -- LSP config
        lsp_cfg = true, -- Use go.nvim's LSP configuration
        lsp_gofumpt = true, -- Use gofumpt through gopls
        lsp_on_attach = function(client, bufnr)
          -- Additional Go-specific keymaps
          local function map(mode, lhs, rhs, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, lhs, rhs, opts)
          end

          -- Go specific mappings
          map("n", "<leader>gt", "<cmd>GoTest<CR>", { desc = "Go Test" })
          map("n", "<leader>gT", "<cmd>GoTestFunc<CR>", { desc = "Go Test Function" })
          map("n", "<leader>gc", "<cmd>GoCoverage<CR>", { desc = "Go Coverage" })
          map("n", "<leader>gC", "<cmd>GoCoverageClear<CR>", { desc = "Go Coverage Clear" })
          map("n", "<leader>gi", "<cmd>GoImports<CR>", { desc = "Go Imports" })
          map("n", "<leader>gm", "<cmd>GoMod tidy<CR>", { desc = "Go Mod Tidy" })
          map("n", "<leader>gd", "<cmd>GoDoc<CR>", { desc = "Go Doc" })
          
          -- Debug mappings
          map("n", "<leader>gdb", "<cmd>GoDebug<CR>", { desc = "Go Debug" })
          map("n", "<leader>gds", "<cmd>GoDebug -s<CR>", { desc = "Go Debug Stop" })
          map("n", "<leader>gdt", "<cmd>GoDebug -t<CR>", { desc = "Go Debug Test" })
        end,
        lsp_keymaps = false, -- We'll use our own keymaps
        lsp_codelens = true,
        lsp_diag_hdlr = true,
        lsp_diag_underline = true,
        lsp_diag_virtual_text = { space = 0, prefix = "●" },
        lsp_diag_signs = true,
        lsp_inlay_hints = {
          enable = true,
          only_current_line = false,
          other_hints_prefix = "• ",
          parameter_hints_prefix = "󰊕 ",
          show_variable_name = true,
          parameter_hints_remove_colon_start = true,
          show_parameter_hints = true,
          highlight = "Comment",
        },
        
        -- Debugging
        dap_debug = true,
        dap_debug_keymap = true,
        dap_debug_gui = true,
        dap_debug_vt = true,
        
        -- Testing
        test_runner = "go",
        run_in_floaterm = false,
        floaterm = {
          position = "auto",
          width = 0.45,
          height = 0.98,
          title_colors = "nord",
        },
        
        -- Icons
        icons = { breakpoint = "🧘", currentpos = "🏃" },
        trouble = false,
        luasnip = true,
      })

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
          require("go.format").goimports()
        end,
        group = vim.api.nvim_create_augroup("GoFormat", {}),
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },
  
  -- Additional Go tools
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require("dap-go").setup()
    end,
  },
}