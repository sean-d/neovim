return {
  -- Render markdown in buffer with full styling
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" },
    config = function()
      require("render-markdown").setup({
        enabled = true,
        heading = {
          enabled = false,  -- Disable render-markdown heading to use treesitter highlights
        },
      })
      
      -- Set up custom highlights
      vim.cmd([[
        " Treesitter highlights for markdown headers with full-width backgrounds
        highlight @markup.heading.1.markdown guifg=#f5c2e7 guibg=#45475a gui=bold
        highlight @markup.heading.2.markdown guifg=#cba6f7 guibg=#494d64 gui=bold
        highlight @markup.heading.3.markdown guifg=#b4befe guibg=#585b70 gui=bold
        highlight @markup.heading.4.markdown guifg=#89b4fa guibg=#585b70 gui=bold
        highlight @markup.heading.5.markdown guifg=#94e2d5 guibg=#585b70 gui=bold
        highlight @markup.heading.6.markdown guifg=#a6e3a1 guibg=#585b70 gui=bold
        
        " Other render-markdown highlights
        highlight RenderMarkdownCode guibg=#313244
        highlight RenderMarkdownCodeInline guibg=#313244 guifg=#cdd6f4
        highlight RenderMarkdownBullet guifg=#f5c2e7
        highlight RenderMarkdownQuote guifg=#6c7086
        highlight RenderMarkdownDash guifg=#45475a
        highlight RenderMarkdownLink guifg=#89b4fa
        highlight RenderMarkdownChecked guifg=#a6e3a1
        highlight RenderMarkdownUnchecked guifg=#6c7086
        highlight RenderMarkdownTableHead guifg=#f5c2e7 gui=bold
        highlight RenderMarkdownTableRow guifg=#cdd6f4
        highlight RenderMarkdownTableFill guifg=#313244
      ]])
    end,
  },

  -- Preview markdown in browser
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    keys = {
      {
        "<leader>mp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    build = ":call mkdp#util#install()",
    init = function()
      vim.g.mkdp_page_title = "${name}"
      vim.g.mkdp_theme = 'dark'
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },

  -- Paste images into markdown
  {
    "HakonHarnes/img-clip.nvim",
    ft = { "markdown" },
    keys = {
      { "<leader>mi", "<cmd>PasteImage<cr>", desc = "Paste image from clipboard", ft = "markdown" },
    },
    opts = {
      -- Only process paste in markdown files
      process_cmd = function(cmd)
        if vim.bo.filetype ~= "markdown" then
          return nil
        end
        return cmd
      end,
      default = {
        dir_path = "images",
        file_name = "%Y-%m-%d-%H-%M-%S",
        prompt_for_file_name = true,
        show_dir_path_in_cmd = false,
        use_absolute_path = false,
        insert_mode_escape_with_esc = true,
      },
      filetypes = {
        markdown = {
          template = "![$FILE_NAME_NO_EXT]($FILE_PATH)",
          download_images = true,
        },
      },
    },
  },

  -- Smart bullet lists
  {
    "bullets-vim/bullets.vim",
    ft = { "markdown", "text", "gitcommit" },
    config = function()
      vim.g.bullets_enabled_file_types = {
        'markdown',
        'text',
        'gitcommit',
        'scratch'
      }
      vim.g.bullets_set_mappings = 1
      vim.g.bullets_mapping_leader = ''
      vim.g.bullets_checkbox_markers = ' .oOX'
      vim.g.bullets_renumber_on_change = 1
    end,
  },
}