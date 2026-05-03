return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
      'folke/lazydev.nvim', -- Better completion for Neovim config
    },
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      
      -- Setup lazydev
      require("lazydev").setup()

      -- System LSPs
      vim.lsp.config('clangd', { capabilities = capabilities })
      vim.lsp.enable('clangd')

      -- Mason LSPs
      local servers = {
        'lua_ls', 'pyright', 'rust_analyzer', 'gopls', 'ts_ls', 'html', 'cssls', 'jsonls',
      }

      require('mason-lspconfig').setup({ ensure_installed = servers })

      for _, server in ipairs(servers) do
        local config = { capabilities = capabilities }
        if server == 'lua_ls' then
          config.settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
        end
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },
}
