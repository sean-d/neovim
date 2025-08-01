-- SQL-specific completion settings
-- This runs after the filetype is detected

-- Ensure completion triggers after SQL keywords
local cmp = require("cmp")

-- Get current buffer sources
local sources = cmp.get_config().sources or {}

-- Add our sources if not already present
local has_dadbod = false
for _, source in ipairs(sources) do
  if source.name == "vim-dadbod-completion" then
    has_dadbod = true
    break
  end
end

if not has_dadbod then
  cmp.setup.buffer({
    sources = cmp.config.sources({
      { name = "vim-dadbod-completion" },
      { name = "buffer" },
    }),
  })
end

-- Set up auto-trigger after specific SQL keywords
vim.api.nvim_create_autocmd("TextChangedI", {
  buffer = 0,
  callback = function()
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    local before_cursor = line:sub(1, col)
    
    -- Check if we just typed a SQL keyword that should trigger completion
    local triggers = {
      "FROM ",
      "JOIN ",
      "WHERE ",
      "SELECT ",
      "UPDATE ",
      "INSERT INTO ",
      "DELETE FROM ",
      "ALTER TABLE ",
      "CREATE TABLE ",
    }
    
    for _, trigger in ipairs(triggers) do
      if before_cursor:upper():match(trigger .. "$") then
        -- Force completion to open
        vim.schedule(function()
          cmp.complete()
        end)
        break
      end
    end
  end,
})