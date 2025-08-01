-- Rust development output windows
local M = {}

-- Reuse the create_float function pattern
local function create_float(content, opts)
  opts = opts or {}
  
  -- Create buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
  
  -- Calculate window size
  local width = opts.width or math.min(120, vim.o.columns - 10)
  local height = opts.height or math.min(40, #content + 2)
  
  -- Calculate position (centered)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  
  -- Create window with nice borders and title
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = opts.title,
    title_pos = "center",
  }
  
  -- Check if footer is supported (Neovim 0.9+)
  local has_footer = vim.fn.has("nvim-0.9") == 1
  if opts.footer and has_footer then
    win_opts.footer = opts.footer
    win_opts.footer_pos = "center"
  end
  
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  
  -- If footer wasn't supported, add it as buffer content
  if opts.footer and not has_footer then
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
      string.rep("─", width),
      opts.footer
    })
    vim.bo[buf].modifiable = false
  end
  
  -- Set buffer options
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].modifiable = false
  
  -- Add keymaps to close
  local close_keys = {"q", "<Esc>", "<C-c>"}
  for _, key in ipairs(close_keys) do
    vim.api.nvim_buf_set_keymap(buf, "n", key, "", {
      callback = function()
        vim.api.nvim_win_close(win, true)
      end,
      noremap = true,
      silent = true,
    })
  end
  
  -- Set filetype for syntax highlighting
  if opts.filetype then
    vim.bo[buf].filetype = opts.filetype
  end
  
  return buf, win
end

-- Run a cargo command and show output in float
local function run_cargo_command(cmd, title)
  local output = vim.fn.systemlist(cmd .. " 2>&1")
  local success = vim.v.shell_error == 0
  
  -- Add status to output
  table.insert(output, 1, "")
  table.insert(output, 1, "$ " .. cmd)
  table.insert(output, "")
  if success then
    table.insert(output, "✅ " .. title .. " completed successfully!")
  else
    table.insert(output, "❌ " .. title .. " failed with exit code: " .. vim.v.shell_error)
  end
  
  create_float(output, {
    title = " 🦀 " .. title .. " ",
    footer = " Press q to close ",
    filetype = "rust",
  })
end

-- Test current file
function M.test_current_file()
  local file = vim.fn.expand("%:t:r")
  run_cargo_command("cargo test --lib " .. file, "Test: " .. file)
end

-- Test current function
function M.test_current_function()
  -- Get current function name using treesitter
  local ts_utils = require('nvim-treesitter.ts_utils')
  local node = ts_utils.get_node_at_cursor()
  
  while node do
    if node:type() == 'function_item' then
      local name_node = node:field('name')[1]
      if name_node then
        local func_name = vim.treesitter.get_node_text(name_node, 0)
        run_cargo_command("cargo test " .. func_name, "Test: " .. func_name)
        return
      end
    end
    node = node:parent()
  end
  
  vim.notify("No test function found at cursor", vim.log.levels.WARN)
end

-- Test all
function M.test_all()
  run_cargo_command("cargo test", "Test All")
end

-- Run clippy
function M.clippy_check()
  run_cargo_command("cargo clippy -- -W clippy::all", "Clippy Check")
end

-- Format check
function M.fmt_check()
  local output = vim.fn.systemlist("cargo fmt -- --check 2>&1")
  local success = vim.v.shell_error == 0
  
  if success then
    create_float({"✅ Code is properly formatted!"}, {
      title = " 🦀 Format Check ",
      footer = " Press q to close ",
    })
  else
    -- Show formatting diff
    local diff_output = vim.fn.systemlist("cargo fmt -- --check --color=always 2>&1")
    table.insert(diff_output, 1, "❌ Code needs formatting. Run 'cargo fmt' to fix.")
    table.insert(diff_output, 2, "")
    
    create_float(diff_output, {
      title = " 🦀 Format Check ",
      footer = " Press q to close ",
      filetype = "diff",
    })
  end
end

-- Build project
function M.build_window()
  run_cargo_command("cargo build", "Build")
end

-- Build release
function M.build_release_window()
  run_cargo_command("cargo build --release", "Build Release")
end

-- Run project
function M.run_window()
  run_cargo_command("cargo run", "Run")
end

-- Check project (fast type checking)
function M.check_window()
  run_cargo_command("cargo check", "Check")
end

-- Show documentation for symbol under cursor
function M.doc_window()
  local word = vim.fn.expand("<cword>")
  run_cargo_command("cargo doc --open", "Documentation")
end

-- Update dependencies
function M.update_window()
  run_cargo_command("cargo update", "Update Dependencies")
end

-- Clean build artifacts
function M.clean_window()
  run_cargo_command("cargo clean", "Clean")
end

return M