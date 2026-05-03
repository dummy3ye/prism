return {
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    lazy = false,
    opts = {
      options = {
        mode = "buffers",
        -- Remove all visual borders/slants
        separator_style = "none", 
        -- Hide the 'x' close button on buffers for a cleaner look
        show_buffer_close_icons = false,
        show_close_icon = false,
        -- Disable the "indicator" (the line/bar showing the active tab)
        indicator = {
          style = 'none',
        },
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "left",
            -- No separator for the offset either
            separator = false,
          }
        },
      }
    },
    config = function(_, opts)
      require("bufferline").setup(opts)
    end,
  },
}
