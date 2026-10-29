-- Dynamic colorscheme engine.
--
-- Every highlight is derived from lua/dynamic/palette.lua -- the single palette
-- file rewritten on each theme/wallpaper change (by ~/.config/themes/*.sh and by
-- matugen via matugen/templates/colors-nvim.lua). No theme colour is hardcoded
-- here except the fallback table used before the first palette has been written.
--
-- Transparent editor background on purpose: kitty supplies the blur behind it.

local M = {}
local uv = vim.uv or vim.loop

local fallback = {
  background = "#1a1b26", surface = "#16161e", surfaceLow = "#1a1b26", surfaceC = "#1f2335",
  surfaceHigh = "#292e42", surfaceTop = "#3b4261", text = "#c0caf5", textVar = "#a9b1d6",
  textPrimary = "#1a1b26", primary = "#7aa2f7", primaryC = "#2f3549", secondary = "#bb9af7",
  tertiary = "#7dcfff", outline = "#565f89", outlineVar = "#3b4261", error = "#f7768e",
}

local function load_palette()
  package.loaded["dynamic.palette"] = nil
  local ok, p = pcall(require, "dynamic.palette")
  return (ok and type(p) == "table") and p or fallback
end

M.palette = load_palette()

local function lum(hex)
  local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
  return (0.299 * tonumber(r, 16) + 0.587 * tonumber(g, 16) + 0.114 * tonumber(b, 16)) / 255
end

local function blend(fg, bg, a)
  local function ch(h, i) return tonumber(h:sub(i, i + 1), 16) end
  local out = "#"
  for _, i in ipairs({ 2, 4, 6 }) do
    out = out .. string.format("%02x", math.floor(ch(fg, i) * a + ch(bg, i) * (1 - a) + 0.5))
  end
  return out
end

function M.setup()
  local c = load_palette()
  M.palette = c
  local want = lum(c.background) > 0.5 and "light" or "dark"
  if vim.o.background ~= want then vim.o.background = want end -- guard: setting it can re-source the scheme
  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") == 1 then vim.cmd("syntax reset") end
  vim.o.termguicolors = true
  vim.g.colors_name = "dynamic"

  local function hl(g, o) vim.api.nvim_set_hl(0, g, o) end
  local N = "NONE"

  -- editor (transparent)
  hl("Normal", { fg = c.text, bg = N }); hl("NormalNC", { fg = c.text, bg = N })
  hl("SignColumn", { bg = N }); hl("FoldColumn", { fg = c.outline, bg = N })
  hl("NormalFloat", { fg = c.text, bg = c.surfaceLow }); hl("FloatBorder", { fg = c.outlineVar, bg = c.surfaceLow })
  hl("FloatTitle", { fg = c.primary, bg = c.surfaceLow, bold = true })
  hl("LineNr", { fg = c.outlineVar, bg = N }); hl("CursorLineNr", { fg = c.text, bg = N, bold = true })
  hl("CursorLine", { bg = N }); hl("ColorColumn", { bg = c.surfaceLow })
  hl("Visual", { bg = c.surfaceTop }); hl("Search", { fg = c.text, bg = blend(c.primary, c.background, 0.35) })
  hl("CurSearch", { fg = c.textPrimary, bg = c.primary }); hl("IncSearch", { fg = c.textPrimary, bg = c.primary })
  hl("MatchParen", { fg = c.primary, bg = c.surfaceHigh, bold = true })
  hl("WinSeparator", { fg = c.outlineVar, bg = N }); hl("VertSplit", { fg = c.outlineVar, bg = N })
  hl("StatusLine", { fg = c.textVar, bg = N }); hl("StatusLineNC", { fg = c.outline, bg = N })
  hl("Pmenu", { fg = c.text, bg = c.surfaceLow }); hl("PmenuSel", { fg = c.text, bg = c.surfaceHigh, bold = true })
  hl("PmenuSbar", { bg = c.surfaceHigh }); hl("PmenuThumb", { bg = c.outline })
  hl("Folded", { fg = c.textVar, bg = c.surfaceLow }); hl("NonText", { fg = c.outlineVar })
  hl("Whitespace", { fg = c.outlineVar }); hl("SpecialKey", { fg = c.outlineVar })
  hl("Directory", { fg = c.primary }); hl("Title", { fg = c.primary, bold = true })
  hl("ErrorMsg", { fg = c.error }); hl("WarningMsg", { fg = c.tertiary }); hl("MoreMsg", { fg = c.secondary })
  hl("Question", { fg = c.secondary }); hl("WildMenu", { bg = c.surfaceHigh })
  hl("TabLine", { fg = c.textVar, bg = N }); hl("TabLineFill", { bg = N }); hl("TabLineSel", { fg = c.text, bg = c.surfaceHigh })

  -- syntax
  hl("Comment", { fg = c.outline, italic = true })
  hl("Constant", { fg = c.tertiary }); hl("String", { fg = c.secondary }); hl("Character", { fg = c.secondary })
  hl("Number", { fg = c.tertiary }); hl("Boolean", { fg = c.tertiary }); hl("Float", { fg = c.tertiary })
  hl("Identifier", { fg = c.text }); hl("Function", { fg = c.primary })
  hl("Statement", { fg = c.tertiary }); hl("Keyword", { fg = c.tertiary }); hl("Conditional", { fg = c.tertiary })
  hl("Repeat", { fg = c.tertiary }); hl("Operator", { fg = c.textVar }); hl("Exception", { fg = c.error })
  hl("PreProc", { fg = c.secondary }); hl("Include", { fg = c.tertiary }); hl("Define", { fg = c.tertiary })
  hl("Type", { fg = c.primary }); hl("StorageClass", { fg = c.tertiary }); hl("Structure", { fg = c.primary })
  hl("Special", { fg = c.secondary }); hl("Delimiter", { fg = c.textVar }); hl("SpecialComment", { fg = c.outline, italic = true })
  hl("Todo", { fg = c.textPrimary, bg = c.tertiary, bold = true }); hl("Underlined", { underline = true })
  hl("Error", { fg = c.error })
  hl("@variable", { fg = c.text }); hl("@variable.builtin", { fg = c.error, italic = true })
  hl("@variable.parameter", { fg = c.text, italic = true }); hl("@property", { fg = c.text })
  hl("@constructor", { fg = c.primary }); hl("@punctuation", { fg = c.textVar })
  hl("@tag", { fg = c.tertiary }); hl("@tag.attribute", { fg = c.primary }); hl("@tag.delimiter", { fg = c.textVar })
  hl("@markup.heading", { fg = c.primary, bold = true }); hl("@markup.link", { fg = c.secondary, underline = true })
  hl("@markup.italic", { italic = true }); hl("@markup.strong", { bold = true })

  -- diagnostics / git / diff
  for name, col in pairs({ Error = c.error, Warn = c.tertiary, Info = c.primary, Hint = c.secondary, Ok = c.secondary }) do
    hl("Diagnostic" .. name, { fg = col })
    hl("DiagnosticVirtualText" .. name, { fg = col, bg = N })
    hl("DiagnosticUnderline" .. name, { undercurl = true, sp = col })
    hl("DiagnosticSign" .. name, { fg = col, bg = N })
  end
  hl("DiffAdd", { bg = blend(c.secondary, c.background, 0.18) }); hl("DiffChange", { bg = blend(c.primary, c.background, 0.15) })
  hl("DiffDelete", { bg = blend(c.error, c.background, 0.18) }); hl("DiffText", { bg = blend(c.primary, c.background, 0.30) })
  hl("Added", { fg = c.secondary }); hl("Changed", { fg = c.primary }); hl("Removed", { fg = c.error })
  hl("GitSignsAdd", { fg = c.secondary }); hl("GitSignsChange", { fg = c.primary }); hl("GitSignsDelete", { fg = c.error })

  -- plugin groups this config ships: link them to the base groups so no stale
  -- colours survive a palette change.
  local links = {
    SnacksPicker = "NormalFloat", SnacksPickerBorder = "FloatBorder", SnacksPickerTitle = "FloatTitle",
    BlinkCmpMenu = "Pmenu", BlinkCmpMenuSelection = "PmenuSel", BlinkCmpMenuBorder = "FloatBorder",
    BlinkCmpDoc = "NormalFloat", BlinkCmpDocBorder = "FloatBorder",
    WhichKeyFloat = "NormalFloat", WhichKeyBorder = "FloatBorder",
    NoicePopup = "NormalFloat", NoiceCmdlinePopup = "NormalFloat", NoiceCmdlinePopupBorder = "FloatBorder",
    LazyNormal = "NormalFloat", MasonNormal = "NormalFloat",
    TreesitterContext = "NormalFloat", FlashLabel = "IncSearch",
  }
  for from, to in pairs(links) do hl(from, { link = to }) end

  M.watch()
end

-- live reload: watch the DIRECTORY (matugen may replace the file, which would
-- kill a file watcher pointed at the file itself)
local watcher, timer
function M.reload()
  package.loaded["lualine.themes.dynamic"] = nil
  vim.cmd.colorscheme("dynamic")
  pcall(function() require("lualine").setup(require("lualine").get_config()) end)
  pcall(function() require("lualine").refresh() end)
  vim.cmd("redraw!")
end

function M.watch()
  if watcher then return end
  watcher, timer = uv.new_fs_event(), uv.new_timer()
  local dir = vim.fn.stdpath("config") .. "/lua/dynamic"
  watcher:start(dir, {}, function(_, fname)
    if fname ~= "palette.lua" then return end
    timer:stop()
    timer:start(120, 0, vim.schedule_wrap(M.reload))
  end)
end

return M
