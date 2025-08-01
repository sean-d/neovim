-- Standalone definition preview and hover functionality
local M = {}

-- Create a floating window
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
  
  -- Set window options
  vim.wo[win].cursorline = true
  vim.wo[win].wrap = false
  vim.wo[win].signcolumn = "no"
  vim.wo[win].foldcolumn = "0"
  vim.wo[win].number = opts.show_numbers ~= false
  vim.wo[win].relativenumber = false
  
  -- Set buffer options
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"
  
  -- Basic keymaps
  vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
  vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win, true) end, { buffer = buf })
  
  -- Scrolling keymaps
  vim.keymap.set("n", "<C-d>", function()
    local height = vim.api.nvim_win_get_height(win)
    vim.cmd("normal! " .. math.floor(height / 2) .. "j")
  end, { buffer = buf })
  
  vim.keymap.set("n", "<C-u>", function()
    local height = vim.api.nvim_win_get_height(win)
    vim.cmd("normal! " .. math.floor(height / 2) .. "k")
  end, { buffer = buf })
  
  return buf, win
end

-- Show definition preview
function M.show_definition()
  -- For Vue files, try the definition but warn about limitations
  local filetype = vim.bo.filetype
  if filetype == "vue" then
    -- Get cursor position to check if we're in script section
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = cursor[1]
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    
    -- Simple check if we're in a script section
    local in_script = false
    local script_start = false
    for i = 1, line do
      if lines[i]:match("^<script") then
        script_start = true
      elseif lines[i]:match("^</script>") and i < line then
        script_start = false
      end
    end
    in_script = script_start
    
    if not in_script then
      vim.notify("Vue: gd only works in <script> sections. See :help vue-limitations", vim.log.levels.WARN)
      return
    end
  end
  
  vim.lsp.buf.definition({
    on_list = function(options)
      local items = options.items
      if not items or #items == 0 then
        vim.notify("No definition found", vim.log.levels.INFO)
        return
      end
      
      -- Handle multiple definitions
      if #items > 1 then
        local content = {"Multiple definitions found:", ""}
        for i, item in ipairs(items) do
          table.insert(content, string.format("%d. %s", i, vim.trim(item.text or "")))
          table.insert(content, "   " .. item.filename .. ":" .. item.lnum)
          table.insert(content, "")
        end
        
        local buf, win = create_float(content, {
          title = " Multiple Definitions ",
          footer = " Press 1-9 to select │ q/<Esc>: close ",
          show_numbers = false
        })
        
        -- Add number key bindings
        for i = 1, math.min(9, #items) do
          vim.keymap.set("n", tostring(i), function()
            vim.api.nvim_win_close(win, true)
            M.show_single_definition(items[i])
          end, { buffer = buf })
        end
        
        return
      end
      
      -- Show single definition
      M.show_single_definition(items[1])
    end
  })
end

-- Show a single definition
function M.show_single_definition(item)
  local filename = item.filename
  local lnum = item.lnum
  
  -- Read file content
  local lines = vim.fn.readfile(filename)
  if not lines then
    vim.notify("Cannot read file: " .. filename, vim.log.levels.ERROR)
    return
  end
  
  -- Calculate preview range
  local start_line = math.max(1, lnum - 10)
  local end_line = math.min(#lines, lnum + 30)
  
  -- Get just the code lines
  local content = {}
  for i = start_line, end_line do
    table.insert(content, lines[i] or "")
  end
  
  -- Create title with file info
  local relative_path = vim.fn.fnamemodify(filename, ":~:.")
  local symbol = vim.fn.expand("<cword>")
  local title = string.format(" %s → %s:%d ", symbol or "Definition", relative_path, lnum)
  
  -- Create floating window with footer
  local buf, win = create_float(content, {
    title = title,
    footer = " q: close │ <CR>: jump │ <C-v>: vsplit │ <C-x>: split │ <C-t>: tab ",
    show_numbers = true
  })
  
  -- Set proper filetype for syntax highlighting
  local ft = vim.filetype.match({ filename = filename })
  if ft then
    vim.bo[buf].filetype = ft
  else
    -- Fallback: determine filetype from extension
    local ext = filename:match("%.([^%.]+)$")
    if ext then
      local ext_to_ft = {
        js = "javascript",
        jsx = "javascriptreact", 
        ts = "typescript",
        tsx = "typescriptreact",
        php = "php",
        vue = "vue",
        mjs = "javascript",
        cjs = "javascript"
      }
      ft = ext_to_ft[ext] or ext
      if ft then
        vim.bo[buf].filetype = ft
      end
    end
  end
  
  -- Enable treesitter if filetype is set
  if vim.bo[buf].filetype ~= "" then
    pcall(vim.treesitter.start, buf, vim.bo[buf].filetype)
  end
  
  -- Adjust line numbers to match source file
  vim.wo[win].statuscolumn = string.format("%%=%d%%s", start_line - 1) .. "%l │ "
  
  -- Move cursor to definition line
  local cursor_line = lnum - start_line + 1
  vim.api.nvim_win_set_cursor(win, { cursor_line, 0 })
  
  -- Add navigation keybindings
  local function jump_to_definition(cmd)
    vim.api.nvim_win_close(win, true)
    if cmd then
      vim.cmd(cmd .. " " .. filename)
    else
      vim.cmd("edit " .. filename)
    end
    vim.api.nvim_win_set_cursor(0, { lnum, 0 })
    vim.cmd("normal! zz")
  end
  
  vim.keymap.set("n", "<CR>", function() jump_to_definition() end, { buffer = buf })
  vim.keymap.set("n", "<C-v>", function() jump_to_definition("vsplit") end, { buffer = buf })
  vim.keymap.set("n", "<C-x>", function() jump_to_definition("split") end, { buffer = buf })
  vim.keymap.set("n", "<C-t>", function() jump_to_definition("tabedit") end, { buffer = buf })
end

-- Custom hover handler
function M.hover()
  -- Get the current buffer and client
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  
  if #clients == 0 then
    vim.notify("No LSP client attached", vim.log.levels.WARN)
    return
  end
  
  -- For Vue files, check if we're in script section
  local filetype = vim.bo[bufnr].filetype
  if filetype == "vue" then
    local cursor = vim.api.nvim_win_get_cursor(0)
    local line = cursor[1]
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    
    local in_script = false
    local script_start = false
    for i = 1, line do
      if lines[i]:match("^<script") then
        script_start = true
      elseif lines[i]:match("^</script>") and i < line then
        script_start = false
      end
    end
    in_script = script_start
    
    if not in_script then
      vim.notify("Vue: K only works in <script> sections. See :help vue-limitations", vim.log.levels.WARN)
      return
    end
  end
  
  local client = clients[1]
  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  
  vim.lsp.buf_request(bufnr, "textDocument/hover", params, function(err, result, ctx, config)
    if err then
      vim.notify("Error getting hover info: " .. err.message, vim.log.levels.ERROR)
      return
    end
    
    if not result or not result.contents then
      vim.notify("No hover information available", vim.log.levels.INFO)
      return
    end
    
    -- Parse the hover content
    local contents = result.contents
    local lines = {}
    
    -- Handle different content formats
    if type(contents) == "string" then
      lines = vim.split(contents, "\n", { plain = true })
    elseif type(contents) == "table" then
      if contents.kind == "markdown" or contents.language == "markdown" then
        lines = vim.split(contents.value or "", "\n", { plain = true })
      elseif contents.value then
        lines = vim.split(contents.value, "\n", { plain = true })
      else
        -- Array of strings or MarkupContent
        for _, item in ipairs(contents) do
          if type(item) == "string" then
            vim.list_extend(lines, vim.split(item, "\n", { plain = true }))
          elseif item.value then
            vim.list_extend(lines, vim.split(item.value, "\n", { plain = true }))
          end
        end
      end
    end
    
    if #lines == 0 then
      vim.notify("No hover content to display", vim.log.levels.INFO)
      return
    end
    
    -- Get the word under cursor for the title
    local word = vim.fn.expand("<cword>")
    local filetype = vim.bo.filetype
    
    -- Create the floating window
    local buf, win = create_float(lines, {
      title = string.format(" %s Documentation ", word or "Hover"),
      footer = " q/<Esc>: close │ <C-d>/<C-u>: scroll │ j/k: navigate ",
      show_numbers = false
    })
    
    -- For hover, we want to detect if it's pure Go code or markdown
    local is_pure_code = true
    for _, line in ipairs(lines) do
      -- Check for markdown indicators
      if line:match("^```") or line:match("^##?#?%s") or line:match("^%s*%*%s") or line:match("^%s*%-%s") then
        is_pure_code = false
        break
      end
    end
    
    -- Set appropriate filetype
    if is_pure_code and filetype ~= "" then
      -- Pure code documentation (like Go's hover showing just the type/function signature)
      vim.bo[buf].filetype = filetype
    else
      -- Markdown documentation
      vim.bo[buf].filetype = "markdown"
      vim.wo[win].conceallevel = 3
      vim.wo[win].concealcursor = "n"
    end
    
    -- Enable treesitter for proper syntax highlighting
    pcall(vim.treesitter.start, buf, vim.bo[buf].filetype)
    
    -- Make the buffer truly read-only
    vim.bo[buf].modifiable = false
    vim.bo[buf].readonly = true
  end)
end

return M