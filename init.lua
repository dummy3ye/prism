-- Path for lazy.nvim plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.cmd("set number")
-- Fix vim.tbl_flatten deprecation warning for nvim 0.12+
if vim.tbl_flatten then
    local orig = vim.tbl_flatten
    vim.tbl_flatten = function(t)
        if vim.iter and vim.iter(t) and vim.iter(t).flatten then
            return vim.iter(t):flatten(math.huge):totable()
        else
            return orig(t)
        end
    end
end
require("vimoptions")

-- These set editor options, keymaps and autocmds, so they must run before
-- lazy.setup() finishes loading plugins that read them (lualine reads
-- 'laststatus', and the keymaps below override plugin defaults).
require("config.options")
require("config.keymaps")
require("config.autocmds")

require("uisettings").init()
require("lazy").setup("plugins")
vim.opt.termguicolors = true
require("transparency").setup()
