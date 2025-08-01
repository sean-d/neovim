-- Docker utilities - manual commands only, no auto-detection
local M = {}

-- Cached status for lualine (only updated manually)
M._cached_status = nil

-- Get Docker container name for current project
local function get_container_name()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  return "docker-" .. project_name
end

-- Get Docker compose file if exists (simple check, no system calls)
local function get_compose_file()
  local files = {"docker-compose.yml", "docker-compose.yaml", "compose.yml", "compose.yaml"}
  for _, file in ipairs(files) do
    if vim.fn.filereadable(file) == 1 then
      return file
    end
  end
  return nil
end

-- Get container state (running, exited, etc.)
local function get_container_state(container_name)
  local cmd = string.format("docker inspect -f '{{.State.Status}}' %s 2>/dev/null", container_name)
  local state = vim.fn.system(cmd)
  if vim.v.shell_error == 0 then
    return vim.trim(state)
  end
  return nil
end

-- Parse EXPOSE directives from Dockerfile
local function get_dockerfile_ports()
  local port_args = ""
  if vim.fn.filereadable("Dockerfile") == 1 then
    local dockerfile = vim.fn.readfile("Dockerfile")
    for _, line in ipairs(dockerfile) do
      local port = line:match("^EXPOSE%s+(%d+)")
      if port then
        port_args = port_args .. " -p " .. port .. ":" .. port
      end
    end
  end
  return port_args
end

-- Execute command with Snacks terminal for visual feedback
local function exec_with_terminal(cmd, opts)
  opts = opts or {}
  local Snacks = require("snacks")
  
  -- Create a script that runs the command and waits
  local script_content = string.format([[
#!/bin/sh
echo "🚀 Starting Docker operation..."
echo "====================================="
echo ""

# Run the actual command
%s

# Capture exit code
EXIT_CODE=$?

echo ""
echo "====================================="
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Operation completed successfully!"
else
    echo "❌ Operation failed with exit code: $EXIT_CODE"
fi
echo "====================================="
echo ""
echo "Press 'q' to close this window"

# Keep the terminal open
while true; do
    sleep 1
done
]], cmd)
  
  -- Write script to temp file
  local script_path = vim.fn.tempname() .. ".sh"
  vim.fn.writefile(vim.split(script_content, "\n"), script_path)
  vim.fn.system("chmod +x " .. script_path)
  
  -- Open floating terminal
  local terminal_opts = {
    win = {
      height = opts.height or 0.7,
      width = opts.width or 0.8,
      title = opts.title or " Docker Operation ",
    },
  }
  
  local term = Snacks.terminal.open(script_path, terminal_opts)
  
  -- Keep focus on the terminal window and switch to normal mode
  vim.defer_fn(function()
    -- Get the terminal window
    local win_id
    if type(term) == "number" then
      win_id = term
    elseif type(term) == "table" and term.win then
      win_id = type(term.win) == "function" and term:win() or term.win
    end
    
    if win_id and vim.api.nvim_win_is_valid(win_id) then
      vim.api.nvim_set_current_win(win_id)
      -- Switch to normal mode so 'q' works immediately
      vim.cmd("stopinsert")
      
      -- Set up 'q' to close the terminal in the buffer
      local buf_id = vim.api.nvim_win_get_buf(win_id)
      if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
        vim.api.nvim_buf_set_keymap(buf_id, 'n', 'q', '<cmd>close<CR>', { 
          noremap = true, 
          silent = true,
          nowait = true 
        })
      end
    end
  end, 100)
  
  -- Clean up script after terminal closes
  if term then
    vim.api.nvim_create_autocmd("BufDelete", {
      buffer = term.buf,
      once = true,
      callback = function()
        vim.fn.delete(script_path)
      end
    })
  end
  
  return term
end

-- Build Docker image
function M.build()
  local compose_file = get_compose_file()
  local cmd
  
  if compose_file then
    cmd = "docker-compose -f " .. compose_file .. " build"
  elseif vim.fn.filereadable("Dockerfile") == 1 then
    cmd = "docker build -t " .. get_container_name() .. ":latest ."
  else
    vim.notify("No Dockerfile or docker-compose.yml found", vim.log.levels.ERROR)
    return
  end
  
  -- Use floating terminal for visual feedback
  exec_with_terminal(cmd, {
    title = " 🔨 Building Docker Image ",
    height = 0.8,
    width = 0.9,
  })
end

-- Start Docker container
function M.start()
  local compose_file = get_compose_file()
  
  if compose_file then
    -- Docker compose path
    local cmd = "docker-compose -f " .. compose_file .. " up -d"
    vim.notify("Starting docker-compose...", vim.log.levels.INFO)
    
    -- Run in background and show result
    vim.fn.jobstart(cmd, {
      on_exit = function(_, code)
        if code == 0 then
          vim.notify("Docker compose started successfully", vim.log.levels.INFO)
        else
          vim.notify("Failed to start docker compose", vim.log.levels.ERROR)
        end
      end
    })
  elseif vim.fn.filereadable("Dockerfile") == 1 then
    -- Single container path with smart logic
    local container_name = get_container_name()
    local state = get_container_state(container_name)
    
    if state == "running" then
      vim.notify("Container already running: " .. container_name, vim.log.levels.INFO)
      return
    elseif state == "exited" or state == "created" then
      -- Container exists, just start it
      local cmd = "docker start " .. container_name
      vim.notify("Starting existing container...", vim.log.levels.INFO)
      
      vim.fn.jobstart(cmd, {
        on_exit = function(_, code)
          if code == 0 then
            vim.notify("Container started: " .. container_name, vim.log.levels.INFO)
          else
            vim.notify("Failed to start container", vim.log.levels.ERROR)
          end
        end
      })
    else
      -- Container doesn't exist, need to create and run
      -- First check if image exists
      local image_check = string.format("docker image inspect %s:latest >/dev/null 2>&1", container_name)
      vim.fn.system(image_check)
      
      if vim.v.shell_error ~= 0 then
        -- No image exists, need to build first
        vim.notify("No Docker image found. Please build first with <leader>cdb", vim.log.levels.ERROR)
        return
      end
      
      -- Image exists, create and run container with port mappings
      local port_args = get_dockerfile_ports()
      local cmd = string.format("docker run -d --name %s%s %s:latest", container_name, port_args, container_name)
      
      vim.notify("Creating and starting container...", vim.log.levels.INFO)
      
      vim.fn.jobstart(cmd, {
        on_exit = function(_, code)
          if code == 0 then
            if port_args ~= "" then
              vim.notify("Container started with port mappings: " .. container_name, vim.log.levels.INFO)
            else
              vim.notify("Container started: " .. container_name, vim.log.levels.INFO)
            end
          else
            vim.notify("Failed to create container", vim.log.levels.ERROR)
          end
        end
      })
    end
  else
    vim.notify("No Docker configuration found", vim.log.levels.ERROR)
    return
  end
end

-- Attach to Docker container (execute commands in container)
function M.attach(opts)
  opts = opts or {}
  local use_float = opts.float or false
  
  local exec_cmd
  
  if get_compose_file() then
    -- For docker-compose, find services
    local compose_file = get_compose_file()
    local service_cmd = string.format("docker-compose -f %s ps --services", compose_file)
    local services = vim.trim(vim.fn.system(service_cmd))
    
    if vim.v.shell_error ~= 0 or services == "" then
      vim.notify("No running services found in docker-compose", vim.log.levels.ERROR)
      return
    end
    
    local service_list = vim.split(services, "\n")
    
    -- If only one service, use it directly
    if #service_list == 1 then
      exec_cmd = string.format("docker-compose -f %s exec %s", compose_file, service_list[1])
    else
      -- Multiple services, let user choose
      vim.ui.select(service_list, {
        prompt = "Select service to attach to:",
        format_item = function(item)
          -- Add helpful icons/descriptions for common services
          local icons = {
            wordpress = "🌐 ",
            app = "📱 ",
            web = "🌐 ",
            api = "🔌 ",
            backend = "⚙️ ",
            frontend = "🎨 ",
            db = "🗄️ ",
            database = "🗄️ ",
            mysql = "🐬 ",
            postgres = "🐘 ",
            redis = "📮 ",
            mongo = "🍃 ",
            mailhog = "📧 ",
            phpmyadmin = "🗃️ ",
          }
          
          local icon = ""
          for pattern, emoji in pairs(icons) do
            if item:find(pattern) then
              icon = emoji
              break
            end
          end
          
          return icon .. item
        end
      }, function(choice)
        if not choice then
          -- User cancelled
          return
        end
        
        vim.notify("Attaching to service: " .. choice, vim.log.levels.INFO)
        
        local cmd = string.format("docker-compose -f %s exec %s", compose_file, choice)
        local shell_cmd = cmd .. " sh -c 'if command -v bash >/dev/null 2>&1; then exec bash; elif command -v ash >/dev/null 2>&1; then exec ash; else exec sh; fi'"
        
        if use_float then
          -- Use Snacks floating terminal
          local Snacks = require("snacks")
          Snacks.terminal.open(shell_cmd, {
            win = {
              height = 0.8,
              width = 0.8,
              title = " 🐳 Docker Shell (" .. choice .. ") ",
            }
          })
        else
          -- Use split window
          vim.cmd("split")
          vim.cmd("terminal " .. shell_cmd)
          vim.cmd("resize 15")  -- Make terminal window smaller
          
          -- Enter insert mode to interact with the terminal
          vim.defer_fn(function()
            vim.cmd("startinsert")
          end, 100)
        end
        
        vim.notify("Attached to container", vim.log.levels.INFO)
      end)
      return -- Exit early since vim.ui.select is async
    end
  else
    -- Regular docker
    local container_name = get_container_name()
    exec_cmd = "docker exec -it " .. container_name
  end
  
  -- Shell detection command - try bash first, then ash, then sh
  local shell_cmd = exec_cmd .. " sh -c 'if command -v bash >/dev/null 2>&1; then exec bash; elif command -v ash >/dev/null 2>&1; then exec ash; else exec sh; fi'"
  
  if use_float then
    -- Use Snacks floating terminal
    local Snacks = require("snacks")
    Snacks.terminal.open(shell_cmd, {
      win = {
        height = 0.8,
        width = 0.8,
        title = " 🐳 Docker Shell ",
      }
    })
  else
    -- Use split window
    vim.cmd("split")
    vim.cmd("terminal " .. shell_cmd)
    vim.cmd("resize 15")  -- Make terminal window smaller
    
    -- Enter insert mode to interact with the terminal
    vim.defer_fn(function()
      vim.cmd("startinsert")
    end, 100)
  end
  
  vim.notify("Attached to container", vim.log.levels.INFO)
end

-- Stop Docker container (without removing)
function M.stop()
  local compose_file = get_compose_file()
  local cmd
  
  if compose_file then
    cmd = "docker-compose -f " .. compose_file .. " stop"
    vim.notify("Stopping docker-compose...", vim.log.levels.INFO)
  else
    local container_name = get_container_name()
    cmd = "docker stop " .. container_name
    vim.notify("Stopping container...", vim.log.levels.INFO)
  end
  
  -- Run in background and show result
  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Container stopped successfully", vim.log.levels.INFO)
      else
        vim.notify("Failed to stop container", vim.log.levels.ERROR)
      end
    end
  })
end

-- Delete/Remove Docker container
function M.delete()
  local compose_file = get_compose_file()
  local cmd
  
  if compose_file then
    cmd = "docker-compose -f " .. compose_file .. " down -v"
    vim.notify("Removing docker-compose containers and volumes...", vim.log.levels.INFO)
  else
    local container_name = get_container_name()
    cmd = "docker stop " .. container_name .. " 2>/dev/null; docker rm " .. container_name
    vim.notify("Removing container...", vim.log.levels.INFO)
  end
  
  -- Run in background and show result
  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if code == 0 then
        vim.notify("Container removed successfully", vim.log.levels.INFO)
      else
        vim.notify("Failed to remove container (may not exist)", vim.log.levels.WARN)
      end
    end
  })
end

-- Show Docker container logs
function M.logs()
  local compose_file = get_compose_file()
  local cmd
  
  if compose_file then
    cmd = "docker-compose -f " .. compose_file .. " logs -f"
  else
    local container_name = get_container_name()
    cmd = "docker logs -f " .. container_name
  end
  
  -- Use Snacks terminal for floating logs window
  local Snacks = require("snacks")
  
  -- Temporarily disable notifications for exit code 130
  local original_notify = vim.notify
  
  local term = Snacks.terminal.open(cmd, {
    win = {
      height = 0.8,
      width = 0.8,
      title = " 📋 Docker Logs ",
    }
  })
  
  -- Keep focus on the terminal window and switch to normal mode
  vim.defer_fn(function()
    -- Get the terminal window
    local win_id
    if type(term) == "number" then
      win_id = term
    elseif type(term) == "table" and term.win then
      win_id = type(term.win) == "function" and term:win() or term.win
    end
    
    if win_id and vim.api.nvim_win_is_valid(win_id) then
      vim.api.nvim_set_current_win(win_id)
      -- Switch to normal mode so 'q' works immediately
      vim.cmd("stopinsert")
      
      -- Set up 'q' to stop logs and close the terminal
      local buf_id = vim.api.nvim_win_get_buf(win_id)
      if buf_id and vim.api.nvim_buf_is_valid(buf_id) then
        vim.api.nvim_buf_set_keymap(buf_id, 'n', 'q', '', { 
          noremap = true, 
          silent = true,
          nowait = true,
          callback = function()
            -- Temporarily suppress notifications
            local original_notify = vim.notify
            vim.notify = function(msg, level, opts)
              -- Ignore exit code 130 notifications
              if not (type(msg) == "string" and msg:match("exit.*130")) then
                original_notify(msg, level, opts)
              end
            end
            
            -- Send Ctrl-C to stop following logs
            vim.api.nvim_chan_send(vim.b[buf_id].terminal_job_id, "\x03")
            
            -- Wait a bit then close and restore notifications
            vim.defer_fn(function()
              if vim.api.nvim_win_is_valid(win_id) then
                vim.api.nvim_win_close(win_id, true)
              end
              -- Restore notifications after a delay
              vim.defer_fn(function()
                vim.notify = original_notify
              end, 500)
            end, 200)
          end
        })
      end
    end
  end, 100)
  
  vim.notify("Press 'q' to stop following logs and close", vim.log.levels.INFO)
end

-- Open LazyDocker in floating terminal
function M.lazydocker()
  if vim.fn.executable("lazydocker") == 0 then
    vim.notify("LazyDocker not installed. Install with: brew install lazydocker", vim.log.levels.ERROR)
    return
  end
  
  local Snacks = require("snacks")
  Snacks.terminal.open("lazydocker", {
    win = {
      height = 0.9,
      width = 0.9,
      title = " 🐳 LazyDocker ",
    }
  })
end

-- Check if Docker is available (cached for performance)
local function is_docker_available()
  local result = vim.fn.system("docker version --format '{{.Server.Version}}' 2>/dev/null")
  return vim.v.shell_error == 0 and result ~= ""
end

-- Check if this is a Docker project
local function is_docker_project()
  return vim.fn.filereadable("Dockerfile") == 1 or get_compose_file() ~= nil
end

-- Get current Docker status (for manual checking)
function M.get_status()
  -- Check if Docker is available
  if not is_docker_available() then
    return "🚫 Docker Off"
  end
  
  -- Check if this is a Docker project
  if not is_docker_project() then
    return "📦 No Docker"
  end
  
  -- Check for Docker Compose first
  if get_compose_file() then
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    -- Check if any containers from this compose project are running
    local check_cmd = string.format("docker ps --format '{{.Names}}' 2>/dev/null | grep -q '^%s-'", project_name)
    vim.fn.system(check_cmd)
    
    if vim.v.shell_error == 0 then
      return "🐳 Running"
    else
      -- Check if containers exist but are stopped
      local exists_cmd = string.format("docker ps -a --format '{{.Names}}' 2>/dev/null | grep -q '^%s-'", project_name)
      vim.fn.system(exists_cmd)
      
      if vim.v.shell_error == 0 then
        return "💤 Stopped"
      else
        return "📦 No Container"
      end
    end
  else
    -- Single container check
    local container_name = get_container_name()
    local state = get_container_state(container_name)
    
    if state == "running" then
      return "🐳 Running"
    elseif state == "exited" or state == "created" then
      return "💤 Stopped"
    else
      return "📦 No Container"
    end
  end
end

-- Cached status for lualine (safe - no system calls)
function M.status()
  return M._cached_status or ""
end

-- Show Docker info and update cached status
function M.info()
  local container_name = get_container_name()
  local status = M.get_status()
  
  -- Update cached status for lualine
  M._cached_status = status
  
  local info = {
    "Docker Status: " .. status,
    "Container Name: " .. container_name,
    "",
  }
  
  -- Get more detailed info if container exists
  if get_compose_file() then
    table.insert(info, "Using Docker Compose: " .. get_compose_file())
    
    -- Get running services
    local services_cmd = string.format("docker-compose -f %s ps --services 2>/dev/null", get_compose_file())
    local services = vim.fn.system(services_cmd)
    if vim.v.shell_error == 0 and services ~= "" then
      table.insert(info, "Services: " .. vim.trim(services):gsub("\n", ", "))
    end
  else
    -- Check for exposed ports in Dockerfile
    local ports = get_dockerfile_ports()
    if ports ~= "" then
      table.insert(info, "Exposed ports:" .. ports)
    end
  end
  
  -- Add keybinding hints based on status
  table.insert(info, "")
  if status == "🐳 Running" then
    table.insert(info, "Commands: <leader>cda (attach) | <leader>cdl (logs) | <leader>cdx (stop)")
  elseif status == "💤 Stopped" then
    table.insert(info, "Commands: <leader>cds (start) | <leader>cdd (delete)")
  elseif status == "📦 No Container" then
    table.insert(info, "Commands: <leader>cdb (build) | <leader>cds (start)")
  elseif status == "📦 No Docker" then
    table.insert(info, "Commands: <leader>cdi (init Dockerfile)")
  end
  
  vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
end

-- Setup function - only keymaps, no auto-detection
function M.setup()
  local keymap = vim.keymap.set
  
  -- Docker commands
  keymap("n", "<leader>cdb", M.build, { desc = "Build Docker image" })
  keymap("n", "<leader>cds", M.start, { desc = "Start Docker container" })
  keymap("n", "<leader>cdx", M.stop, { desc = "Stop Docker container" })
  keymap("n", "<leader>cda", M.attach, { desc = "Attach to Docker container" })
  keymap("n", "<leader>cdA", function() M.attach({ float = true }) end, { desc = "Attach to Docker (float)" })
  keymap("n", "<leader>cdd", M.delete, { desc = "Delete Docker container" })
  keymap("n", "<leader>cdl", M.logs, { desc = "Show Docker logs" })
  keymap("n", "<leader>cdL", M.lazydocker, { desc = "Open LazyDocker" })
  keymap("n", "<leader>cdi", M.info, { desc = "Docker info (updates status)" })
end

return M