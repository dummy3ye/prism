return {
  -- Sticky Scroll: Keeps the function name at the top of the screen
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPost",
    opts = { mode = "cursor", max_lines = 3 },
  },

  -- Rainbow Brackets: Colors matching brackets
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
  },

  -- Indent Guides: Vertical lines for indentation
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    opts = {
      indent = { 
        char = "│",
        tab_char = "│",
      },
      scope = { 
        enabled = true, 
        show_start = false, 
        show_end = false,
        -- Smooth out the "glowing" effect on Windows
        highlight = { "Function", "Label" },
      },
    },
  },

  -- Todo Comments: Highlight TODO, FIXME, etc.
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    opts = {},
  },
}
