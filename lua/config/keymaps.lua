vim.keymap.set('n', '<C-n>', ':Neotree toggle<CR>', { silent = true })

-- Buffer Navigation (Tabs)
vim.keymap.set('n', '<S-h>', ':BufferLineCyclePrev<CR>', { silent = true, desc = 'Previous Tab' })
vim.keymap.set('n', '<S-l>', ':BufferLineCycleNext<CR>', { silent = true, desc = 'Next Tab' })
vim.keymap.set('n', '<leader>x', ':bd<CR>', { silent = true, desc = 'Close Current Tab' })

-- Diagnostic Navigation (Bugs/Errors)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to Previous Error' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to Next Error' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show Error Details' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open Error List' })

-- Quick Project Shortcuts
vim.keymap.set('n', '<leader>wd', function() vim.cmd("cd " .. vim.fn.getcwd()) end, { desc = 'Reset Working Dir' })

-- LSP Keybinds (Helper function to be called on LspAttach)
local M = {}

function M.on_attach(ev)
  local opts = { buffer = ev.buf }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = M.on_attach,
})

return M
