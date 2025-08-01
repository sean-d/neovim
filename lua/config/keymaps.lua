-- Keymaps are automatically loaded after lazy.nvim
-- This file is loaded by init.lua

local keymap = vim.keymap.set

-- Definition preview (moved to autocmd to ensure it loads after LSP)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    keymap("n", "gd", function()
      require("config.definition-preview").show_definition()
    end, { desc = "Show definition preview", buffer = 0 })
  end,
})

-- Window navigation is handled by vim-tmux-navigator plugin
-- which provides seamless navigation between tmux panes and vim splits

-- Move lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Clear search with <esc>
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Better indenting
keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Indent right" })

-- Save file
keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Quit
keymap("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
keymap("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all" })

-- UI toggles
keymap("n", "<leader>ub", function()
  if vim.g.bufferline_enabled == nil then
    vim.g.bufferline_enabled = true
  end
  vim.g.bufferline_enabled = not vim.g.bufferline_enabled
  
  if vim.g.bufferline_enabled then
    vim.cmd("set showtabline=2")
    vim.notify("Bufferline enabled", vim.log.levels.INFO)
  else
    vim.cmd("set showtabline=0")
    vim.notify("Bufferline disabled", vim.log.levels.INFO)
  end
end, { desc = "Toggle bufferline" })

-- Buffer navigation
keymap("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
keymap("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
keymap("n", "<leader>bb", "<cmd>b#<cr>", { desc = "Switch to last buffer" })
keymap("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Pin/unpin buffer" })
keymap("n", "<leader>bP", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
keymap("n", "<leader>bl", "<cmd>BufferLinePick<cr>", { desc = "Pick buffer" })
keymap("n", "<leader>bc", "<cmd>BufferLinePickClose<cr>", { desc = "Pick buffer to close" })
keymap("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Previous buffer" })
keymap("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
keymap("n", "<A-h>", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer left" })
keymap("n", "<A-l>", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer right" })

-- Windows
keymap("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
keymap("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
keymap("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })

-- Terminal mode mappings
keymap("t", "<C-q>", "<cmd>close<CR>", { desc = "Hide terminal" })

-- Reload bufferline config
keymap("n", "<leader>br", "<cmd>source ~/.config/nvim/lua/plugins/bufferline.lua | Lazy reload bufferline.nvim<CR>", { desc = "Reload bufferline config" })

-- Source current file
keymap("n", "<leader><leader>s", "<cmd>source %<CR>", { desc = "Source current file" })

-- Markdown keybindings are now in config.dev-keymaps

-- Additional keymaps will be added as we configure plugins