return {
  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    ft = { 'rust' },
    init = function()
      -- Configure rustaceanvim before it loads
      vim.g.rustaceanvim = {
        -- DAP configuration
        dap = {
          adapter = function()
            local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
            
            return require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path)
          end,
        },
        -- LSP configuration
        server = {
          on_attach = function(client, bufnr)
            -- Rust-specific LSP setup handled here
            -- Keybindings are now in config.dev-keymaps
          end,
          settings = {
            ['rust-analyzer'] = {
              cargo = {
                features = "all",
              },
              check = {
                command = "clippy",
              },
              procMacro = {
                enable = true,
              },
            },
          },
        },
        tools = {
          hover_actions = {
            border = "rounded",
          },
        },
      }
    end,
  },
}