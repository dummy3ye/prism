-- --- 0. PRE-INITIALIZATION ---
-- Leader must be set before any plugins are loaded
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- --- 1. BOOTSTRAP LAZY.NVIM ---
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- --- 2. LOAD CORE CONFIGS ---
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- --- 3. SETUP PLUGINS ---
require("lazy").setup("plugins", {
  change_detection = {
    notify = false, -- Stop the "config changed" popup
  },
})
