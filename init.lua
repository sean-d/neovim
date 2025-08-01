-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load core settings first
require("config.options")

-- Setup lazy.nvim
require("lazy").setup("plugins", {
  defaults = {
    lazy = false,
    version = false,
  },
  change_detection = {
    notify = false,
  },
})

-- Load keymaps after plugins
vim.schedule(function()
  require("config.keymaps")
  require("config.dev-keymaps").setup()
  
  -- Load docker commands
  local ok, docker = pcall(require, "config.docker")
  if ok then
    docker.setup()
  else
    vim.notify("Failed to load docker module: " .. tostring(docker), vim.log.levels.WARN)
  end
end)

print("Config loaded successfully")