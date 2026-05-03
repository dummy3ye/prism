return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "moon",
      dark_sidebar = false,
      dark_float = false,
      styles = {
        transparency = true,
      },
      highlight_groups = {
        FloatBorder = { fg = "muted", bg = "none" },
        NormalFloat = { bg = "none" },
        WinSeparator = { fg = "muted", bg = "none" },
      },
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd.colorscheme "rose-pine"
    end,
  },
}
