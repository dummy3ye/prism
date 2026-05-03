-- Basic Editor Options
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 3            -- Global statusline
vim.opt.tabstop = 4               
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.updatetime = 500          -- Faster completion and hover response
vim.opt.scrolloff = 8             -- Keep 8 lines visible above/below cursor
vim.opt.mouse = 'a'               -- Enable mouse support
vim.opt.clipboard = 'unnamedplus' -- Use system clipboard
vim.opt.fillchars = { eob = " " } -- Hide '~' at end of buffers

-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})
