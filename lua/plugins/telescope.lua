return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local telescope = require('telescope')
      local builtin = require('telescope.builtin')

      -- Professional Root Detection using Neovim's built-in FS API
      local function get_project_root()
        local markers = { '.git', 'package.json', 'Makefile', 'go.mod', 'Cargo.toml', '.nvim' }
        -- Find the nearest parent containing one of the markers
        local root = vim.fs.root(0, markers)
        
        -- If no root found, or if we hit the Home directory (common on Windows)
        -- default to the directory of the current file to avoid "searching everything"
        if not root or root == vim.fn.expand('~') then
          local current_file = vim.api.nvim_buf_get_name(0)
          if current_file == "" then return vim.fn.getcwd() end
          return vim.fn.fnamemodify(current_file, ":p:h")
        end
        
        return root
      end

      -- Project-aware Find Files with Notification
      vim.keymap.set('n', '<leader>ff', function()
        local root = get_project_root()
        vim.notify("Searching: " .. root, vim.log.levels.INFO)
        builtin.find_files({ cwd = root })
      end, { desc = 'Find Project Files' })

      -- Project-aware Live Grep with Notification
      vim.keymap.set('n', '<leader>sg', function()
        local root = get_project_root()
        vim.notify("Searching text in: " .. root, vim.log.levels.INFO)
        builtin.live_grep({ cwd = root })
      end, { desc = 'Search Project by Grep' })

      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find Help' })

      telescope.setup({
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          path_display = { "smart" },
          preview = { treesitter = false },
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            -- Strictly ignore these massive folders
            '--glob', '!{.git,node_modules,target,build,vendor,dist,AppData,Downloads,Pictures,Videos,Music}/*'
          },
        },
      })
      
      pcall(telescope.load_extension, 'fzf')
    end,
  },
}
