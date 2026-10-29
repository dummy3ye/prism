-- Dynamic statusline + plugin switches.
--
-- The pill statusline is built entirely from lua/dynamic/palette.lua, so it
-- recolours with the rest of the editor on every theme change.
--
-- NOTE: this config is NOT the LazyVim distribution (LazyVim is not installed),
-- so the usual `{ "LazyVim/LazyVim", opts = { colorscheme = "dynamic" } }` spec
-- is omitted. "dynamic" is selected as the startup colorscheme by
-- lua/uitheme.lua and re-applied live by lua/dynamic/init.lua's watcher.

local function P() return require("dynamic").palette end

-- Choose high-contrast text (black/white) against the pill's background colour.
local function pill(color_key)
  return function()
    local bg = P()[color_key]
    local function lum(hex)
      local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
      return (0.299 * tonumber(r, 16) + 0.587 * tonumber(g, 16) + 0.114 * tonumber(b, 16)) / 255
    end
    local luminance = lum(bg)
    local fg = luminance > 0.5 and "#000000" or "#ffffff"
    return { fg = fg, bg = bg, gui = "bold" }
  end
end

local sep = { left = "\u{e0b6}", right = "\u{e0b4}" }

local mode_color = {
  n = "primary", i = "secondary", v = "tertiary", V = "tertiary", ["\22"] = "tertiary",
  R = "error", c = "tertiary", t = "secondary", s = "tertiary",
}

return {
  -- Reference layout: no bufferline, no tabline (single global statusline).
  { "akinsho/bufferline.nvim", enabled = false },
  { "kdheepak/tabline.nvim", enabled = false },

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "dynamic",
        globalstatus = true,
        icons_enabled = true,
        component_separators = "",
        section_separators = "",
        disabled_filetypes = { statusline = {}, winbar = {} },
        ignore_focus = {},
        always_divide_middle = true,
        refresh = { statusline = 100, tabline = 100, winbar = 100 },
      },
      sections = {
        lualine_a = {
          {
            "mode", icon = "\u{e62b}", separator = sep, padding = { left = 1, right = 1 },
            color = function()
              return { fg = P().background, bg = P()[mode_color[vim.fn.mode():sub(1, 1)] or "primary"], gui = "bold" }
            end,
          },
        },
        lualine_b = {
          { "filetype", icon_only = true, colored = true, padding = { left = 1, right = 0 } },
          { "filename", file_status = false, color = function() return { fg = P().text, bg = "NONE" } end },
        },
        lualine_c = { { "diagnostics", color = { bg = "NONE" } } },
        lualine_x = {},
        lualine_y = {
          {
            function() return vim.fs.basename(vim.uv.cwd() or "") end,
            icon = "\u{f07b}", separator = sep, padding = { left = 1, right = 1 }, color = pill("error"),
          },
        },
        lualine_z = {
          {
            function() return vim.fn.line(".") .. "/" .. vim.fn.line("$") end,
            icon = "\u{f0c9}", separator = sep, padding = { left = 1, right = 1 }, color = pill("secondary"),
          },
        },
      },
      winbar = {},
      extensions = {},
    },
  },
}
