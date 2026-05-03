return {
  -- Snacks.nvim: A collection of high-quality small plugins
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      bigfile = { enabled = true },
      dashboard = { 
        enabled = true,
        preset = {
          header = [[
   ██████╗  ██████╗ ███████╗███████╗██╗   ██╗██║███╗   ███╗
   ██╔══██╗██╔═══██╗██╔════╝██╔════╝██║   ██║██║████╗ ████║
   ██████╔╝██║   ██║███████╗█████╗  ██║   ██║██║██╔████╔██║
   ██╔══██╗██║   ██║╚════██║██╔══╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
   ██║  ██║╚██████╔╝███████║███████╗ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { 
              icon = "󰛐 ", key = "p", desc = "Projects", 
              action = function() 
                Snacks.picker.projects({
                  confirm = function(picker, item)
                    picker:close()
                    -- Snacks projects usually store the path in item.file or item.path
                    local path = item.path or item.file
                    if path then
                      vim.cmd("cd " .. path)
                      require("neo-tree.command").execute({ action = "focus", dir = path })
                      vim.notify("Switched to " .. path)
                    end
                  end
                })
              end
            },
            { icon = " ", key = "c", desc = "Config", action = ":e $MYVIMRC" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = true }, 
      statuscolumn = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>pp", function() 
          Snacks.picker.projects({
            confirm = function(picker, item)
              picker:close()
              local path = item.path or item.file
              if path then
                vim.cmd("cd " .. path)
                require("neo-tree.command").execute({ action = "focus", dir = path })
              end
            end
          })
      end, desc = "Find Projects" },
    },
  },
}
