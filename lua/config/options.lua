-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Neovim options
local opt = vim.opt

-- UI
opt.number = true              -- Show line numbers
opt.relativenumber = true      -- Relative line numbers
opt.termguicolors = true       -- True color support
opt.signcolumn = "yes"         -- Always show sign column

-- Tmux compatibility
if vim.env.TMUX then
  vim.g.tmux_navigator_no_mappings = 0  -- Use default mappings
  vim.g.tmux_navigator_save_on_switch = 2  -- Save on switch
end
opt.cursorline = true          -- Highlight current line
opt.cursorcolumn = true        -- Highlight current column
opt.laststatus = 3             -- Global statusline
opt.pumheight = 10             -- Popup menu height
opt.showmode = false           -- Don't show mode (handled by statusline)
opt.ruler = false              -- Don't show ruler (handled by statusline)
opt.wrap = false               -- Disable line wrap
opt.scrolloff = 8              -- Lines to keep above/below cursor
opt.sidescrolloff = 8          -- Columns to keep left/right of cursor

-- Editing
opt.expandtab = true           -- Use spaces instead of tabs
opt.shiftwidth = 2             -- Size of indent
opt.tabstop = 2                -- Number of spaces tabs count for
opt.smartindent = true         -- Smart autoindenting
opt.shiftround = true          -- Round indent to multiple of shiftwidth
opt.formatoptions = "jcroqlnt"

-- Search
opt.ignorecase = true          -- Ignore case in search
opt.smartcase = true           -- Don't ignore case with capitals
opt.hlsearch = true            -- Highlight search results
opt.incsearch = true           -- Show search results while typing
opt.grepprg = "rg --vimgrep"   -- Use ripgrep for :grep
opt.grepformat = "%f:%l:%c:%m"

-- Performance
opt.updatetime = 200           -- Faster completion
opt.timeout = true             -- Enable timeout
opt.timeoutlen = 300           -- Time to wait for mapped sequence
opt.ttimeoutlen = 10           -- Time to wait for key code sequence

-- Files
opt.undofile = true            -- Persistent undo
opt.undolevels = 10000         -- Maximum undo levels
opt.backup = false             -- Don't create backup files
opt.writebackup = false        -- Don't backup before overwriting
opt.swapfile = false           -- Don't create swap files

-- Splits
opt.splitbelow = true          -- Split below current window
opt.splitright = true          -- Split right of current window
opt.splitkeep = "screen"       -- Keep screen position when splitting

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full"

-- Folding (handled by nvim-ufo plugin)

-- Misc
opt.confirm = true             -- Confirm to save changes before exiting
opt.mouse = "a"                -- Enable mouse support
opt.clipboard = "unnamedplus"  -- Use system clipboard
opt.fillchars = {
  foldopen = "▾",
  foldclose = "▸",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Filetype detection
vim.filetype.add({
  extension = {
    go = "go",
    mod = "gomod",
    sum = "gosum",
  },
  filename = {
    ["go.mod"] = "gomod",
    ["go.sum"] = "gosum",
  },
})

-- Cursor settings
opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
  .. ",a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor"
  .. ",sm:block-blinkwait175-blinkoff150-blinkon175"

-- Set cursor column highlight to be visible but not too bright
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    -- Make cursor column more visible
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#363849" })
  end,
})

-- Apply immediately
vim.api.nvim_set_hl(0, "CursorColumn", { bg = "#363849" })

-- Diagnostic configuration (moved here from lsp.lua for early loading)
vim.diagnostic.config({
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚 ", -- nf-md-close_circle (U+F059A)
      [vim.diagnostic.severity.WARN] = "󰀪 ", -- nf-md-alert (U+F002A)
      [vim.diagnostic.severity.HINT] = "󰌶 ", -- nf-md-lightbulb (U+F0336)
      [vim.diagnostic.severity.INFO] = "󰋽 ", -- nf-md-information (U+F02FD)
    },
  },
})

-- Disable builtin plugins
local disabled_built_ins = {
  "netrw",
  "netrwPlugin",
  "netrwSettings",
  "netrwFileHandlers",
}

for _, plugin in ipairs(disabled_built_ins) do
  vim.g["loaded_" .. plugin] = 1
end