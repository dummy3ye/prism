return {
  -- File Tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    keys = {
      -- Bare `toggle` (no side argument) reopens wherever neo-tree was last
      -- shown. Passing "left"/"right" here is what used to yank the tree to
      -- the left on every reopen even though opts.window.position is "right".
      { "<C-n>", ":Neotree filesystem toggle<CR>", desc = "Toggle Neo-tree" },
      { "<leader>e", ":Neotree filesystem toggle<CR>", desc = "Toggle Neo-tree" },
      -- `show` opens on that side and moves an already-open tree; `toggle
      -- left` would instead close a tree that is currently on the right.
      { "<leader>el", ":Neotree filesystem show left<CR>", desc = "Show Neo-tree left" },
      { "<leader>er", ":Neotree filesystem show right<CR>", desc = "Show Neo-tree right" },
      {
        "<leader>es",
        function()
          local is_left_open = false
          local is_right_open = false
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "neo-tree" then
              if vim.api.nvim_win_get_position(win)[2] == 0 then
                is_left_open = true
              else
                is_right_open = true
              end
            end
          end
          -- If open on left, switch to right; if open on right, switch to
          -- left; otherwise open right.
          if is_left_open then
            vim.cmd("Neotree filesystem show right")
          elseif is_right_open then
            vim.cmd("Neotree filesystem show left")
          else
            vim.cmd("Neotree filesystem show right")
          end
        end,
        desc = "Swap Neo-tree side (left <-> right)",
      },
    },
    opts = {
      window = {
        position = "right",
        width = 30,
        mappings = {
          ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
        },
      },
      default_component_configs = {
        preview = {
          winhl = "Normal:Normal,FloatBorder:FloatBorder",
        },
        name = {
          use_git_status_colors = false,
        },
        git_status = {
          align = "right",
        },
      },
      event_handlers = {
        {
          event = "neo_tree_buffer_enter",
          handler = function()
            local untracked = vim.api.nvim_get_hl(0, { name = "NeoTreeGitUntracked" })
            if untracked and untracked.italic then
              vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", vim.tbl_extend("force", untracked, { italic = false }))
            end
            local conflict = vim.api.nvim_get_hl(0, { name = "NeoTreeGitConflict" })
            if conflict and (conflict.italic or conflict.bold) then
              vim.api.nvim_set_hl(0, "NeoTreeGitConflict", vim.tbl_extend("force", conflict, { italic = false, bold = false }))
            end
          end,
        },
      },
      filesystem = {
        hijack_netrw_behavior = "open_default",
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          always_show = {
            ".github",
            ".gitignore",
          },
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
    },
  },

  -- Status Line
  -- NOTE: lualine is configured in lua/plugins/lualine.lua. It used to be
  -- declared here too with `globalstatus = true`, but a plugin's `config`
  -- function takes precedence over `opts` in lazy.nvim, so lualine.lua won and
  -- this block was dead. Keep a single source of truth.

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
    },
  },
}
