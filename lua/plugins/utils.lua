return {
  -- Fast jumping/navigation
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
  },

  -- Auto-formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "isort", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
  },

  -- Find and Replace
  {
    "magicduck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    keys = {
      { "<leader>sr", function() require("grug-far").open() end, desc = "Search and Replace" },
    },
  },

  -- Keybinding guide
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto pairs for brackets
  {
    "echasnovski/mini.pairs",
    version = false,
    event = "InsertEnter",
    opts = {},
  },

  -- Session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = { options = { "buffers", "curdir", "tabpages", "winsize" } },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },
}
