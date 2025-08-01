return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      scratch = { 
        enabled = true,
        ft = "markdown",  -- Default scratch buffers to markdown
        win = {
          border = {
            { '╭', 'ScratchBorder' },
            { '─', 'ScratchBorder' },
            { '╮', 'ScratchBorder' },
            { '│', 'ScratchBorder' },
            { '╯', 'ScratchBorder' },
            { '─', 'ScratchBorder' },
            { '╰', 'ScratchBorder' },
            { '│', 'ScratchBorder' },
          },
          title = function(scratch)
            return { { ' ' .. (scratch.name or 'Scratch') .. ' ', 'ScratchTitle' } }
          end,
          title_pos = 'center',
          footer = { { ' q: close ', 'ScratchFooter' } },
          footer_pos = 'center',
        },
      },
      explorer = {
        enabled = true,
        win = {
          position = "left",
          width = 30,
          border = "rounded",
        },
        -- Show hidden files by default
        filters = {
          dotfiles = false, -- false means show dotfiles
          custom = {}, -- No custom filters
        },
      },
      lazygit = {
        enabled = true,
        win = {
          border = "rounded",
        },
      },
      dim = {
        enabled = false, -- Disabled for now as it affects treesitter
      },
      styles = {
        notification = {
          wo = { wrap = true },
        },
        lazygit = {
          wo = {
            winhighlight = "Normal:Normal,FloatBorder:LazyGitBorder,WinBar:LazyGitBorder",
          },
        },
        scratch = {
          border = {
            { '╭', 'ScratchBorder' },
            { '─', 'ScratchBorder' },
            { '╮', 'ScratchBorder' },
            { '│', 'ScratchBorder' },
            { '╯', 'ScratchBorder' },
            { '─', 'ScratchBorder' },
            { '╰', 'ScratchBorder' },
            { '│', 'ScratchBorder' },
          },
        },
      },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = "󰮗", key = "f", desc = "Find File", action = ":lua Snacks.picker.files()" },
            { icon = "", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = "", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
            { icon = "", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
            { icon = "", key = "c", desc = "Config", action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
            { icon = "󰩈", key = "q", desc = "Quit", action = ":qa" },
            { icon = "󰘥", key = "h", desc = "Help (Local Docs)", action = function() 
                local docs_path = vim.fn.stdpath("config") .. "/docs/book/index.html"
                if vim.fn.filereadable(docs_path) == 1 then
                  vim.fn.system("open " .. vim.fn.shellescape(docs_path))
                else
                  vim.notify("Documentation not built. Run 'mdbook build' in the config directory first.", vim.log.levels.WARN)
                end
              end },
            { icon = "󰮦", key = "H", desc = "Help (GitHub Pages)", action = function()
                vim.fn.system("open https://sean-d.github.io/neovim/")
              end },
          },
          header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⡀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣤⠤⠴⠖⠚⠛⠉⠉⠉⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⢰⣸⣶⣇⠀⢰⣿⣿⣷⣤⠤⠴⠖⠒⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⣀⣀⣤⠤⠶⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣰⣴⣇⠀⢰⣾⣿⣄⣼⡿⠿⢿⡟⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⣀⣀⣠⠤⠤⠖⠚⠛⠉⠉⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣠⣤⢾⣿⠽⢼⡛⠋⠉⠉⠁⢸⠀⠀⠈⢻⣄⣀⣠⠤⠤⣶⠒⠚⠋⢉⣉⣠⣤⠤⠤⠤⣤⣀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠟⠋⠉⠉⠀⠀⣾⠃⠀⠈⢻⣀⣠⠤⢤⣿⠀⠀⠀⠀⢿⡇⠀⢀⣤⡿⠗⠒⢚⣏⠉⠱⡄⠀⠀⠀⢸⠈⠙⠲⣄⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣤⣀⣀⡤⠤⠶⡿⠀⠀⠀⠀⣿⠀⠀⠀⢿⠀⠀⠀⠀⠘⣇⣴⠃⠀⠻⢤⡸⣿⡿⠏⢀⡿⠀⠀⢠⣏⡀⠀⠀⠈⢷⡀⠀⠀
⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⢰⡇⠀⠀⠀⠀⠸⡆⠀⠀⢸⡁⠀⠀⠀⠀⢹⡏⠀⠀⠀⣰⣿⣗⠓⠒⠛⠀⠀⠀⠀⠀⠉⠓⢦⡀⠀⢳⡄⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⢳⠒⠒⢙⡇⠀⠀⠀⠀⠀⣧⠀⠀⠀⢿⣧⣽⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⡀⠀⢷⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠈⠁⠀⠘⠃⠀⠀⠀⠀⠀⢻⡀⠀⠀⠈⠛⠛⠀⣠⠞⡉⠉⠳⣄⠀⠀⠀⠀⠀⢳⠀⠘⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣧⠀⠀⠀⠀⠀⢠⠇⣴⣿⣷⠀⠸⡆⠀⠀⠀⠀⢸⠀⠀⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⠀⠀⠀⠀⢸⡄⠉⠋⠉⠀⠀⢷⠀⠀⠀⠀⣸⠀⢠⡇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣆⠀⠀⠀⡼⠁⠀⠀⠀⠀⠀⢸⠀⠀⠀⣰⠃⠀⡼⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⡀⢀⠇⠀⠀⠀⠀⠀⠀⣸⠀⣠⠞⠁⠀⡼⠃⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠾⣄⣀⡀⢀⣀⣀⡠⠷⠚⠁⠀⣠⠞⠁⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠁⠀⠀⠀⢀⣠⠞⠃⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⠖⠋⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⠴⠒⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠒⠲⠤⠤⠤⠤⠤⠤⠦⠶⠖⠚⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
        },
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          { section = "startup" },
        },
      },
      picker = {
        -- Show hidden and ignored files by default
        hidden = true,
        ignored = true,
        win = {
          input = {
            keys = {
              ["<C-p>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<C-n>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<C-f>"] = { "toggle_focus", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<C-p>"] = { "preview_scroll_up", mode = { "i", "n" } },
              ["<C-n>"] = { "preview_scroll_down", mode = { "i", "n" } },
              ["<C-f>"] = { "toggle_focus", mode = { "i", "n" } },
            },
          },
        },
      },
    },
    keys = {
      { "<leader>e", function() Snacks.explorer.open() end, desc = "Toggle Explorer" },
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>ba", function() Snacks.bufdelete.all() end, desc = "Delete All Buffers" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit Log (cwd)" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      
      -- Scratch buffers
      { "<leader>xn", function()
        -- Create a new scratch buffer (always ask for name)
        local name = vim.fn.input("Scratch name (empty for timestamp): ")
        if name == "" then
          name = "scratch_" .. os.date("%Y%m%d_%H%M%S")
        end
        Snacks.scratch({ name = name })
      end, desc = "New Scratch Buffer" },
      { "<leader>xa", function()
        -- Simple scratch manager with delete functionality
        local items = Snacks.scratch.list()
        if #items == 0 then
          vim.notify("No scratch buffers found", vim.log.levels.INFO)
          return
        end
        
        -- Create a new buffer for scratch selection
        local buf = vim.api.nvim_create_buf(false, true)
        local lines = {}
        local file_map = {}
        
        for i, item in ipairs(items) do
          local name = item.name or vim.fn.fnamemodify(item.file, ":t:r")
          table.insert(lines, string.format("%d. %s", i, name))
          file_map[i] = { file = item.file, name = name }
        end
        
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
        
        -- Calculate window size
        local width = math.max(40, math.min(60, vim.o.columns - 20))
        local height = math.min(#lines + 4, vim.o.lines - 10)
        
        -- Create highlight groups for the scratch window
        vim.api.nvim_set_hl(0, 'ScratchBorder', { fg = '#ca9ee6' }) -- Mauve
        vim.api.nvim_set_hl(0, 'ScratchTitle', { fg = '#ca9ee6', bold = true }) -- Mauve bold
        vim.api.nvim_set_hl(0, 'ScratchFooter', { fg = '#8087a2' }) -- Surface2 (muted)
        
        -- Create floating window with border highlights
        local win = vim.api.nvim_open_win(buf, true, {
          relative = 'editor',
          width = width,
          height = height,
          col = math.floor((vim.o.columns - width) / 2),
          row = math.floor((vim.o.lines - height) / 2),
          style = 'minimal',
          border = {
            { '╭', 'ScratchBorder' },
            { '─', 'ScratchBorder' },
            { '╮', 'ScratchBorder' },
            { '│', 'ScratchBorder' },
            { '╯', 'ScratchBorder' },
            { '─', 'ScratchBorder' },
            { '╰', 'ScratchBorder' },
            { '│', 'ScratchBorder' },
          },
          title = { { ' Scratch Buffers ', 'ScratchTitle' } },
          title_pos = 'center',
          footer = { { ' <Enter>: Open | d: Delete | q: Close ', 'ScratchFooter' } },
          footer_pos = 'center',
        })
        
        -- Set keymaps for this buffer
        local function get_selection()
          local line = vim.api.nvim_win_get_cursor(win)[1]
          return file_map[line]
        end
        
        -- Open scratch
        vim.keymap.set('n', '<CR>', function()
          local selection = get_selection()
          if selection then
            vim.api.nvim_win_close(win, true)
            Snacks.scratch.open({ file = selection.file })
          end
        end, { buffer = buf })
        
        -- Delete scratch
        vim.keymap.set('n', 'd', function()
          local selection = get_selection()
          if selection then
            local confirm = vim.fn.confirm("Delete scratch '" .. selection.name .. "'?", "&Yes\n&No", 2)
            if confirm == 1 then
              -- Close buffer if it's open
              for _, b in ipairs(vim.api.nvim_list_bufs()) do
                if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_name(b) == selection.file then
                  vim.api.nvim_buf_delete(b, { force = true })
                end
              end
              -- Delete the file
              os.remove(selection.file)
              vim.notify("Deleted scratch: " .. selection.name, vim.log.levels.INFO)
              vim.api.nvim_win_close(win, true)
              -- Refresh the list
              vim.schedule(function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<leader>xa", true, false, true), "n", false)
              end)
            end
          end
        end, { buffer = buf })
        
        -- Close window
        vim.keymap.set('n', 'q', function()
          vim.api.nvim_win_close(win, true)
        end, { buffer = buf })
        
        vim.keymap.set('n', '<Esc>', function()
          vim.api.nvim_win_close(win, true)
        end, { buffer = buf })
      end, desc = "All Scratch Buffers" },
      { "<leader>xx", function() Snacks.scratch() end, desc = "Open Last Scratch" },
      
      -- Picker keymaps
      { "<leader><leader>", function() Snacks.picker.buffers() end, desc = "Switch Buffer" },
      { "<leader>bD", function()
        -- Get list of all buffers
        local buffers = vim.fn.getbufinfo({ buflisted = 1 })
        if #buffers <= 1 then
          vim.notify("Only one buffer open", vim.log.levels.INFO)
          return
        end
        
        -- Create a simple picker for buffer deletion
        local items = {}
        for _, buf in ipairs(buffers) do
          local name = buf.name ~= "" and vim.fn.fnamemodify(buf.name, ":~:.") or "[No Name]"
          local modified = buf.changed == 1 and " [+]" or ""
          table.insert(items, {
            display = string.format("%d: %s%s", buf.bufnr, name, modified),
            bufnr = buf.bufnr,
          })
        end
        
        vim.ui.select(items, {
          prompt = "Delete buffer:",
          format_item = function(item) return item.display end,
        }, function(choice)
          if choice then
            vim.cmd("bd " .. choice.bufnr)
            -- Recursively call to delete more if needed
            vim.schedule(function()
              local remaining = vim.fn.getbufinfo({ buflisted = 1 })
              if #remaining > 1 then
                vim.fn.feedkeys("<leader>bD", "n")
              end
            end)
          end
        end)
      end, desc = "Delete buffers (one by one)" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep (Root Dir)" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      
      -- find
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fF", function() Snacks.picker.files({ cwd = vim.uv.cwd() }) end, desc = "Find Files (cwd)" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
      
      -- git
      { "<leader>gc", function() Snacks.picker.git_commits() end, desc = "Commits" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Status" },
      
      -- Grep
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sG", function() Snacks.picker.grep({ cwd = vim.uv.cwd() }) end, desc = "Grep (cwd)" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      
      -- search
      { "<leader>s\"", function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      
      -- LSP
      -- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" }, -- Using custom preview instead
      -- { "gr", function() Snacks.picker.lsp_references() end, desc = "References", nowait = true }, -- Using quickfix instead
      -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" }, -- Using quickfix instead
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd
          
          -- Fix for dashboard file opening - ensure filetype detection
          vim.api.nvim_create_autocmd("BufEnter", {
            callback = function()
              if vim.bo.filetype == "" then
                vim.cmd("filetype detect")
              end
            end,
          })
          
          -- Set dashboard colors
          vim.api.nvim_set_hl(0, 'SnacksDashboardHeader', { fg = '#cba6f7' })
          vim.api.nvim_set_hl(0, 'SnacksDashboardTitle', { fg = '#cba6f7', bold = true })
          vim.api.nvim_set_hl(0, 'SnacksDashboardDesc', { fg = '#b4befe' })  -- Lavender for menu items
          vim.api.nvim_set_hl(0, 'SnacksDashboardKey', { fg = '#f5c2e7' })  -- Pink for shortcut keys
          vim.api.nvim_set_hl(0, 'LazyGitBorder', { fg = '#f5c2e7' })  -- Pink border for lazygit
          
          -- Toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.inlay_hints():map("<leader>uh")
        end,
      })
    end,
  },
}
