-- Basic Editor Options
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = false   -- reference uses absolute numbers (flip to true to restore)
vim.opt.laststatus = 3            -- Global statusline
vim.opt.tabstop = 4               
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.updatetime = 500          -- Faster completion and hover response
vim.opt.scrolloff = 8             -- Keep 8 lines visible above/below cursor
vim.opt.mouse = 'a'               -- Enable mouse support
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.fillchars = { eob = " " } -- Hide '~' at end of buffers

-- Dynamic-theme look (see lua/dynamic/ and lua/plugins/dynamic.lua)
vim.opt.showmode = false          -- mode lives in the statusline pill now
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"  -- highlight only the line NUMBER, not a bar
vim.opt.winblend = 10
vim.opt.pumblend = 10

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})
