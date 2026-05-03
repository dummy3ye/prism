return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    -- In the new version, the module is just nvim-treesitter
    main = "nvim-treesitter",
    opts = {
      ensure_installed = { 
        "c", "cpp", "lua", "vim", "vimdoc", "query", "python", "rust", "go", 
        "javascript", "typescript", "tsx", "html", "css", "json", "yaml", "bash", "markdown", "markdown_inline" 
      },
      auto_install = true,
      highlight = {
        enable = true,
        -- Disable standard vim highlighting to prevent conflicts with Treesitter
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Leader>ss",
          node_incremental = "<Leader>si",
          scope_incremental = "<Leader>sc",
          node_decremental = "<Leader>sd",
        },
      },
    },
    config = function(_, opts)
      -- Windows compatibility fix
      require('nvim-treesitter.install').prefer_git = true
      require("nvim-treesitter").setup(opts)
    end,
  },
}
