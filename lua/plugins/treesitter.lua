-- treesitter.lua
--
-- This spec has no `branch` field, so lazy.nvim tracks the plugin's *default*
-- branch, which is `main`. As of 2026 that is the incompatible rewrite, and it
-- no longer reads the classic option keys. The `ensure_installed`,
-- `auto_install`, `highlight.enable` and `indent.enable` entries that used to
-- live here were therefore being accepted by Lua and then ignored -- they had
-- no effect at all.
--
-- How the rewrite actually works:
--   * Highlighting is Neovim's job, and turns itself on for any filetype that
--     has a parser. Neovim 0.12 bundles parsers for c, lua, markdown, query,
--     vimdoc and vim -- those six work with no setup.
--   * Everything else must be installed explicitly, either with
--     `:TSInstall <lang>` or `require("nvim-treesitter").install({ "<lang>" })`.
--     `latex` is installed; see below.
--   * Indentation is *not* enabled by the plugin. It stays off on purpose for
--     LaTeX: VimTeX's ftplugin sets `indentexpr = VimtexIndentExpr()`, which
--     understands \begin/\end nesting and is what you want in a .tex buffer.
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  init = function()
    -- The installed parser is called `latex` (tree-sitter-latex), but the
    -- filetype for a .tex file is `tex`. Without this registration Neovim looks
    -- for a parser named `tex`, does not find one, and silently leaves the
    -- buffer unhighlighted. This must run before the first .tex FileType.
    vim.treesitter.language.add("latex", { "tex" })
  end,
}
