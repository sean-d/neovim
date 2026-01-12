-- Theme-aware color system
local M = {}

-- Define Catppuccin Macchiato colors
M.colors = {
  pink = "#f5c2e7",
  mauve = "#cba6f7", 
  purple = "#ca9ee6",
  lavender = "#b4befe",
  blue = "#89b4fa",
  sky = "#89dceb",
  sapphire = "#74c7ec",
  teal = "#94e2d5",
  green = "#a6e3a1",
  yellow = "#f9e2af",
  peach = "#fab387",
  marmalade = "#ef9f76",
  red = "#f38ba8",
  surface0 = "#313244",
  surface1 = "#45475a",
  surface2 = "#585b70",
  overlay0 = "#6c7086",
  overlay1 = "#7f849c",
  overlay2 = "#9399b2",
  subtext0 = "#a6adc8",
  subtext1 = "#bac2de",
  text = "#cdd6f4",
  base = "#1e1e2e",
  mantle = "#181825",
  crust = "#11111b",
}

-- Get colors (always returns Catppuccin Macchiato colors)
function M.get_colors()
  return M.colors
end

-- Apply theme-aware highlights
function M.apply_custom_highlights()
  local c = M.get_colors()
  
  -- Border highlights
  vim.api.nvim_set_hl(0, 'FloatBorder', { fg = c.pink })
  vim.api.nvim_set_hl(0, 'HarpoonBorder', { fg = c.pink })
  vim.api.nvim_set_hl(0, 'WhichKeyBorder', { fg = c.purple })
  vim.api.nvim_set_hl(0, 'LazyGitBorder', { fg = c.pink })
  vim.api.nvim_set_hl(0, 'ScratchBorder', { fg = c.purple })
  
  -- DAP highlights
  vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = c.pink })
  vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = c.blue })
  vim.api.nvim_set_hl(0, 'DapStopped', { fg = c.green })
  vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = c.surface1 })
  
  -- Indent highlights
  vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { fg = c.mauve })
  vim.api.nvim_set_hl(0, 'IblIndent', { fg = c.surface2 })
  vim.api.nvim_set_hl(0, 'IblScope', { fg = c.mauve })
  
  -- Git highlights
  vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { fg = c.pink })
  
  -- Dashboard highlights
  vim.api.nvim_set_hl(0, 'SnacksDashboardHeader', { fg = c.mauve })
  vim.api.nvim_set_hl(0, 'SnacksDashboardTitle', { fg = c.mauve, bold = true })
  vim.api.nvim_set_hl(0, 'SnacksDashboardDesc', { fg = c.lavender })
  vim.api.nvim_set_hl(0, 'SnacksDashboardKey', { fg = c.pink })
  
  -- Outline highlights
  vim.api.nvim_set_hl(0, 'OutlineGuides', { fg = c.surface2 })
  vim.api.nvim_set_hl(0, 'OutlineFoldMarker', { fg = c.mauve })
  vim.api.nvim_set_hl(0, 'OutlineCurrent', { fg = c.pink, bold = true })
  
  -- TreeSitter Context
  vim.api.nvim_set_hl(0, 'TreesitterContext', { bg = c.surface0 })
  vim.api.nvim_set_hl(0, 'TreesitterContextLineNumber', { fg = c.overlay0, bg = c.surface0 })
  vim.api.nvim_set_hl(0, 'TreesitterContextSeparator', { fg = c.surface2 })
  
  -- Flash highlights
  vim.api.nvim_set_hl(0, 'FlashBackdrop', { fg = c.overlay0 })
  vim.api.nvim_set_hl(0, 'FlashMatch', { bg = c.surface1, fg = c.text })
  vim.api.nvim_set_hl(0, 'FlashCurrent', { bg = c.surface1, fg = c.text })
  vim.api.nvim_set_hl(0, 'FlashLabel', { bg = c.pink, fg = c.crust, bold = true })
  
  -- Cursor column
  vim.api.nvim_set_hl(0, 'CursorColumn', { bg = c.surface0 })
  
  -- Markdown highlights
  vim.cmd(string.format([[
    highlight @markup.heading.1.markdown guifg=%s guibg=%s gui=bold
    highlight @markup.heading.2.markdown guifg=%s guibg=%s gui=bold
    highlight @markup.heading.3.markdown guifg=%s guibg=%s gui=bold
    highlight @markup.heading.4.markdown guifg=%s guibg=%s gui=bold
    highlight @markup.heading.5.markdown guifg=%s guibg=%s gui=bold
    highlight @markup.heading.6.markdown guifg=%s guibg=%s gui=bold
    highlight RenderMarkdownCode guibg=%s
    highlight RenderMarkdownCodeInline guibg=%s guifg=%s
    highlight RenderMarkdownBullet guifg=%s
    highlight RenderMarkdownQuote guifg=%s
    highlight RenderMarkdownDash guifg=%s
    highlight RenderMarkdownLink guifg=%s
    highlight RenderMarkdownChecked guifg=%s
    highlight RenderMarkdownUnchecked guifg=%s
    highlight RenderMarkdownTableHead guifg=%s gui=bold
    highlight RenderMarkdownTableRow guifg=%s
    highlight RenderMarkdownTableFill guifg=%s
  ]], 
    c.pink, c.surface1,
    c.mauve, c.surface2,
    c.lavender, c.surface2,
    c.blue, c.surface2,
    c.teal, c.surface2,
    c.green, c.surface2,
    c.surface0,
    c.surface0, c.text,
    c.pink,
    c.overlay0,
    c.surface1,
    c.blue,
    c.green,
    c.overlay0,
    c.pink,
    c.text,
    c.surface0
  ))
end

-- Setup autocmd to reapply on colorscheme change
function M.setup()
  vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
      M.apply_custom_highlights()
    end,
  })
  
  -- Apply immediately
  M.apply_custom_highlights()
end

return M