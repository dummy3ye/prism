-- Transparency: make nvim's backgrounds transparent so kitty's translucent
-- window background (pywal sets `background_opacity 0.70` in
-- ~/.config/kitty/current-theme.conf) shows through.
--
-- How this works: kitty fills any cell whose colour nvim leaves unset with its
-- own background, which is translucent. So for a group to look transparent,
-- nvim must not set an explicit background on it, i.e. `bg = "none"`.
--
-- Three buckets:
--   TRANSPARENT  - chrome, floats, borders, bars, gutters. No background at all.
--   PATTERNS     - same, but for whole plugin families whose group names share
--                  a prefix, so new groups/plugins are covered automatically.
--   BLENDED      - groups where a solid block carries meaning (selection,
--                  search, diffs, virtual text). These keep a background, mixed
--                  toward the terminal background so they read as a tint.
--
-- NOTE: nvim_set_hl only accepts 24-bit RGB (a 6-digit hex string or an
-- integer); it rejects 8-digit hex and `{r,g,b,a}` tables. Per-cell
-- translucency is therefore unreachable from Lua, and BLENDED approximates it
-- by mixing toward the terminal background.

local M = {}

M.enabled = true

-- Background removed entirely; the terminal background shows through.
local TRANSPARENT = {
  -- core window
  "Normal", "NormalNC", "NormalSB", "NormalFloat", "FloatBorder", "FloatTitle",
  "FloatFooter", "MsgArea", "MsgSeparator", "MoreMsg", "Question", "WarningMsg",
  "StatusLine", "StatusLineNC", "StatusLineTerm", "StatusLineTermNC",
  "TabLine", "TabLineSel", "TabLineFill", "WinBar", "WinBarNC",
  "WinSeparator", "VertSplit", "FloatShadow", "FloatShadowThrough",

  -- nvim renamed ColorColumn to CursorColumn in 0.11; set both so neither
  -- paints a solid column.
  "ColorColumn", "CursorColumn",

  -- core message groups; the theme gives these an opaque background
  "ErrorMsg", "Error", "ModeMsg", "Ignore", "Todo", "QuickFixLine",
  "LspFloatWinNormal", "IndentBlanklineChar",

  -- gutters, filler, cursor decoration
  "SignColumn", "SignColumnSB", "FoldColumn", "Folded", "LineNr", "LineNrAbove",
  "LineNrBelow", "CursorLineNr", "CursorLineSign", "CursorLineFold", "Cursor",
  "EndOfBuffer", "NonText", "SpecialKey", "Whitespace", "Conceal",
  "TermCursor", "TermCursorNC", "CursorIM",

  -- completion / popup menus
  "Pmenu", "PmenuSbar", "PmenuThumb", "PmenuExtra", "PmenuExtraSel",
  "PmenuKind", "PmenuKindSel", "PmenuMatch", "PmenuMatchSel",
  "WildMenu", "ComplMatchIns", "PmenuEndOfBuffer",

  -- diagnostics / LSP float chrome
  "LspInfoBorder", "LspInfoTitle", "LspInlayHint", "LspCodeLens",
  "LspSignatureActiveParameter", "LspSignatureActiveParameterBorder",
  "DiagnosticFloatingHint", "DiagnosticSignHint", "DiagnosticUnnecessaryHint",
  "DiagnosticVirtualLines", "QuickFixLineNr", "qfLineNr", "qfFile",
  "qfSeparator",

  -- help / man / gitcommit / diff window chrome
  "helpHeader", "helpSectionDelim", "helpHyperTextJump", "helpHyperTextEntry",
  "helpExample", "helpCode", "helpURL", "Man", "ManBold", "ManItalic",
  "diffAdded", "diffRemoved", "diffChanged", "diffOldFile", "diffNewFile",
  "diffFile", "diffLine", "diffIndexLine", "NonText",

  -- health
  "healthError", "healthSuccess", "healthWarning", "helpGroup",

  -- terminal buffers
  "terminal", "terminalColor",
}

-- Whole families cleared by name prefix. This is what keeps coverage broad
-- without listing every group of every plugin by hand.
local PATTERNS = {
  "^Alpha",             -- alpha-nvim dashboard
  "^Blink",             -- blink.cmp
  "^Buffer",            -- bufferline.nvim (BufferLine*, BufferCurrent*)
  "^CopilotChat",       -- copilot chat
  "^Cmp",               -- nvim-cmp
  "^Diff",              -- diff / diffview style diffs
  "^Flash",             -- flash.nvim jump labels
  "^GrugFar",           -- grug-far
  "^Hop",               -- hop.nvim
  "^Lazy",              -- lazy.nvim UI
  "^LspTrouble",        -- trouble.nvim's LSP error list
  "^Markview",          -- markview
  "^Mason",             -- mason.nvim UI
  "^NeoTree",           -- neo-tree
  "^Neogit",            -- neogit
  "^Noice",             -- noice cmdline
  "^Nui",               -- nui.nvim (borders/lines used by pickers)
  "^NvimTree",          -- legacy tree, harmless if unused
  "^Packer",            -- packer legacy
  "^Pounce",            -- pounce.nvim
  "^qf",                -- quickfix
  "^RainbowDelimiter",  -- rainbow-delimiters
  "^Saga",              -- saga
  "^Snacks",            -- snacks.nvim
  "^tabline_",          -- kdheepak/tabline.nvim: the TOP bar's section groups
  "^Telescope",         -- telescope
  "^TodoComment",       -- todo-comments
  "^ToggleTerm",        -- toggleterm
  "^TreesitterContext", -- nvim-treesitter-context
  "^Trouble",           -- trouble.nvim
  "^WhichKey",          -- which-key
  "^colorizer",         -- nvim-colorizer
  "^Mini",              -- mini.* statusline/tabline/icons
  -- NOTE: indent-blankline is deliberately NOT listed. Its setup() calls
  -- get() on the configured group and calls error() when it comes back empty,
  -- so clearing IblIndent made it fail with
  -- "No highlight group 'IblIndent' found" on every FileType. It has no
  -- background to begin with, so nothing is lost by leaving it alone.
}

-- Background kept, but mixed toward the terminal background. Ratio is how much
-- of the terminal background to blend in: 0.0 keeps the theme colour, 1.0 makes
-- it indistinguishable from the terminal background.
local BLENDED = {
  Visual = 0.62,
  ["VisualNOS"] = 0.62,
  Search = 0.55,
  IncSearch = 0.35,
  Substitute = 0.45,
  CurSearch = 0.8,
  CursorLine = 0.84,
  MatchParen = 0.6,
  -- Selected entry in the completion menu. Tinted rather than cleared so the
  -- selection is still obvious; clearing it made the active item unreadable.
  PmenuSel = 0.5,
  DiffAdd = 0.55,
  DiffChange = 0.55,
  DiffDelete = 0.55,
  DiffText = 0.4,
  Added = 0.55,
  Changed = 0.55,
  Removed = 0.55,
  ["@diff.plus"] = 0.5,
  ["@diff.minus"] = 0.5,
  ["@diff.delta"] = 0.5,
  ["@text.diff.add"] = 0.5,
  ["@text.diff.delete"] = 0.5,
  ["@text.diff"] = 0.5,
  ["DiagnosticVirtualTextError"] = 0.5,
  ["DiagnosticVirtualTextWarn"] = 0.5,
  ["DiagnosticVirtualTextInfo"] = 0.5,
  ["DiagnosticVirtualTextHint"] = 0.5,
  ["DiagnosticVirtualTextOk"] = 0.5,
  ["@lsp.type.class.underline"] = 0.5,
  ["@lsp.type.parameter.underline"] = 0.5,
  ["@lsp.type.variable.underline"] = 0.5,
  ["@lsp.type.property.underline"] = 0.5,
  ["@lsp.type.typedef.underline"] = 0.5,
  ["@lsp.type.enum.underline"] = 0.5,
  ["@lsp.type.function.underline"] = 0.5,
  ["@lsp.type.method.underline"] = 0.5,
  ["@lsp.type.keyword.underline"] = 0.5,
  ["@lsp.type.comment.underline"] = 0.5,
  ["@lsp.type.string.underline"] = 0.5,
  ["@lsp.type.number.underline"] = 0.5,
  ["@lsp.type.operator.underline"] = 0.5,
  ["@lsp.mod.deprecated"] = 0.5,
  ["@comment.hint"] = 0.5,
  ["@comment.info"] = 0.5,
  ["@comment.note"] = 0.5,
  ["@comment.todo"] = 0.5,
  ["@comment.error"] = 0.5,
  ["@comment.warning"] = 0.5,
  ["@markup.heading.1.markdown"] = 0.75,
  ["@markup.heading.2.markdown"] = 0.75,
  ["@markup.heading.3.markdown"] = 0.75,
  ["@markup.heading.4.markdown"] = 0.75,
  ["@markup.heading.5.markdown"] = 0.75,
  ["@markup.heading.6.markdown"] = 0.75,
  ["@markup.strong.markdown"] = 0.75,
  ["@markup.italic.markdown"] = 0.75,
  ["@markup.link.markdown"] = 0.75,
  ["@markup.link.text.markdown"] = 0.75,
  ["@markup.link.label.markdown"] = 0.75,
  ["@markup.link.url.markdown"] = 0.75,
  ["@markup.quote.markdown"] = 0.75,
  ["@markup.list.markdown"] = 0.75,
  ["@markup.raw.markdown"] = 0.75,
  ["@markup.raw.block.markdown"] = 0.75,
  ["@markup.math.markdown"] = 0.75,
  TodoCommentTodo = 0.5,
  TodoCommentDone = 0.5,

  -- Content that uses a background to mean something. Clearing these would
  -- remove a feature (a callout box with no fill is just text, a heading with
  -- no fill loses its level cue), so they keep a background, just a fainter one
  -- close to the terminal background.
  ["@markup.list.checked"] = 0.6,
  LspReferenceText = 0.5,
  LspReferenceRead = 0.5,
  LspReferenceWrite = 0.5,
  TSDanger = 0.5,
  TSNote = 0.5,
  TSWarning = 0.5,
  MarkviewCode = 0.6,
  MarkviewCodeInfo = 0.6,
  MarkviewInlineCode = 0.6,
  MarkviewIcon0 = 0.6,
  MarkviewIcon1 = 0.6,
  MarkviewIcon2 = 0.6,
  MarkviewIcon3 = 0.6,
  MarkviewIcon4 = 0.6,
  MarkviewIcon5 = 0.6,
  MarkviewIcon6 = 0.6,
  MarkviewPalette0 = 0.45,
  MarkviewPalette0Bg = 0.45,
  MarkviewPalette1 = 0.45,
  MarkviewPalette1Bg = 0.45,
  MarkviewPalette2 = 0.45,
  MarkviewPalette2Bg = 0.45,
  MarkviewPalette3 = 0.45,
  MarkviewPalette3Bg = 0.45,
  MarkviewPalette4 = 0.45,
  MarkviewPalette4Bg = 0.45,
  MarkviewPalette5 = 0.45,
  MarkviewPalette5Bg = 0.45,
  MarkviewPalette6 = 0.45,
  MarkviewPalette6Bg = 0.45,
  MarkviewPalette7 = 0.45,
  MarkviewPalette7Bg = 0.45,
  RenderMarkdownCode = 0.6,
  RenderMarkdownCodeInline = 0.6,
  RenderMarkdownH1Bg = 0.6,
  RenderMarkdownH2Bg = 0.6,
  RenderMarkdownH3Bg = 0.6,
  RenderMarkdownH4Bg = 0.6,
  RenderMarkdownH5Bg = 0.6,
  RenderMarkdownH6Bg = 0.6,
}

--- Resolve the terminal background colour, used as the blend target.
local function terminal_bg()
  -- pywal exports this, and it matches kitty's `background` in
  -- current-theme.conf. Without pywal, fall back to that same value.
  return tonumber(vim.g.background) or 0x11131c
end

--- Linearly interpolate two packed 24-bit RGB colours.
local function mix(a, b, t)
  local ar, ag, ab = (a >> 16) & 0xff, (a >> 8) & 0xff, a & 0xff
  local br, bg_, bb = (b >> 16) & 0xff, (b >> 8) & 0xff, b & 0xff
  local r = math.floor(ar + (br - ar) * t + 0.5)
  local g = math.floor(ag + (bg_ - ag) * t + 0.5)
  local bl = math.floor(ab + (bb - ab) * t + 0.5)
  return (r << 16) + (g << 8) + bl
end

--- Remove the background from a highlight group.
--- nvim_set_hl *replaces* a group, so it must be handed the group's other
--- attributes too -- writing only `{ bg = "none" }` also wipes the fg, which
--- left line numbers (LineNr/CursorLineNr) and other chrome without the fg
--- colours the colorscheme had set.
local function clear_bg(group)
  local current = vim.api.nvim_get_hl(0, { name = group })
  if current.link then
    return
  end
  current.bg = "none"
  current.ctermbg = "none"
  pcall(vim.api.nvim_set_hl, 0, group, current)
end

--- Blending is lossy, so it must not run twice on the same value. Caching by
--- "which theme are we on" is too coarse: a plugin such as cmp or blink
--- re-paints PmenuSel after our pass, and a stale cache entry would then leave
--- it opaque forever. Instead remember the exact value we last wrote and skip
--- only when the group still holds that value. Anything else means somebody
--- overwrote it, so re-blend from their new value.
local last_blended = {}

local function reset_blends()
  last_blended = {}
end

--- Mix a group's background toward the terminal background.
local function blend_bg(group, t)
  local current = vim.api.nvim_get_hl(0, { name = group })
  if type(current.bg) ~= "number" then
    return
  end
  if last_blended[group] == current.bg then
    return
  end
  local blended = mix(current.bg, terminal_bg(), t)
  last_blended[group] = blended
  if blended == current.bg then
    return
  end
  -- Re-assert the group's other attributes so only the background changes.
  vim.api.nvim_set_hl(0, group, {
    fg = current.fg,
    bg = string.format("#%06x", blended),
    ctermbg = "NONE",
    blend = current.blend,
    bold = current.bold,
    italic = current.italic,
    underline = current.underline,
    undercurl = current.undercurl,
    strikethrough = current.strikethrough,
    nocombine = current.nocombine,
  })
end

--- Clear every group whose name matches one of the family prefixes.
local function clear_patterns()
  local highlights = vim.api.nvim_get_hl(0, {})
  for name in pairs(highlights) do
    for _, pattern in ipairs(PATTERNS) do
      if name:match(pattern) then
        -- Skip groups the BLENDED table handles, so a family prefix cannot
        -- silently undo a deliberate tint (e.g. "^Diff" vs DiffAdd).
        if not BLENDED[name] then
          pcall(clear_bg, name)
        end
        break
      end
    end
  end
end

--- Apply transparency to every known group.
function M.apply()
  if not M.enabled then
    return
  end

  for _, group in ipairs(TRANSPARENT) do
    pcall(clear_bg, group)
  end

  clear_patterns()

  for group, ratio in pairs(BLENDED) do
    pcall(blend_bg, group, ratio)
  end

  -- The area past end-of-buffer should not draw "~" on a transparent bg.
  pcall(function()
    vim.opt_local.fillchars:append({ eob = " " })
  end)
end

--- Restore solid backgrounds by re-applying the active colorscheme.
function M.disable()
  M.enabled = false
  pcall(vim.cmd, "colorscheme " .. (vim.g.colors_name or "rose-pine"))
  pcall(function()
    vim.api.nvim_exec_autocmds("ColorScheme", { pattern = vim.g.colors_name or "" })
  end)
end

function M.enable()
  M.enabled = true
  reset_blends()
  M.apply()
end

function M.toggle()
  if M.enabled then
    M.disable()
    vim.notify("Transparency: off", vim.log.levels.INFO)
  else
    M.enable()
    vim.notify("Transparency: on", vim.log.levels.INFO)
  end
end

--- Register the autocmds that keep transparency applied.
function M.setup()
  local group = vim.api.nvim_create_augroup("transparency", { clear = true })

  vim.api.nvim_create_autocmd({ "VimEnter", "WinNew", "FileType", "BufWinEnter" }, {
    group = group,
    callback = function()
      M.apply()
    end,
  })

  -- A new colorscheme means new background values to blend, so forget which
  -- groups were already processed.
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      reset_blends()
      M.apply()
      -- Theme and plugin ColorScheme handlers run in registration order, and
      -- lualine/pywal also write highlights from a vim.schedule callback.
      -- Apply again once the event queue drains so our values are the ones
      -- that stick.
      vim.schedule(M.apply)
    end,
  })

  -- Plugins that finish loading after VimEnter and paint their own chrome
  -- back in. bufhidden/timers of a few hundred ms cover the usual stragglers.
  for _, delay in ipairs({ 50, 250, 800, 1500 }) do
    vim.defer_fn(M.apply, delay)
  end

  vim.api.nvim_create_user_command("Transparency", function()
    M.toggle()
  end, { desc = "Toggle nvim background transparency" })

  M.apply()
end

return M
