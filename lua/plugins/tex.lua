-- LaTeX: VimTeX for editing/compiling, zathura for viewing.
--
-- VimTeX must NOT be lazy loaded. It self-loads as a filetype plugin, and
-- forcing it behind the plugin manager breaks :VimtexInverseSearch, which
-- inverse search from zathura depends on (it is a global command, so it has to
-- exist before any .tex buffer opens).
--
-- Requires Neovim >= 0.12.4; this config runs 0.12.5.
return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      -- Viewer: zathura, with forward + inverse search wired up.
      vim.g.vimtex_view_method = "zathura"

      -- latexmk is VimTeX's default backend and the one to use: it detects
      -- which engine the document needs and how many passes it requires.
      -- Comes from the texlive-bin package.
      vim.g.vimtex_compiler_method = "latexmk"

      -- latexmk figures out how many passes the document needs, so the
      -- defaults below are all we need: \ll compiles, \lv opens the viewer,
      -- \lt does both.
      --
      -- 'continuous' (VimTeX's name for compile-on-save) is left at 1, so
      -- saving the .tex with :w recompiles through latexmk. Zathura watches
      -- the PDF and reloads it by itself, so a save is enough to see the
      -- change in the viewer: no need to reach for \ll each time. Set
      -- continuous = 0 if you would rather compile only on demand.
      --
      -- NOTE: this must be a *dictionary* with an 'options' list, not a bare
      -- list of flags. VimTeX runs extend() on this value, and extend() errors
      -- with "E712: Argument of extend() must be a List or Dictionary" if you
      -- hand it a List. That error aborts ftplugin/tex.vim, which leaves you
      -- with no \ll, no \lv and no :VimtexCompile at all.
      vim.g.vimtex_compiler_latexmk = {
        executable = "latexmk",
        -- Compile on save. Zathura auto-reloads the PDF when it changes, so
        -- :w is the whole loop.
        continuous = 1,
        options = {
          "-pdf",
          "-synctex=1", -- required for forward/inverse search to work at all
          "-interaction=nonstopmode", -- never stop on a missing package
          "-file-line-error", -- errors as file:line: so quickfix jumps work
        },
      }
      vim.g.vimtex_aux_dir = "." -- keep .aux/.log/.fls next to the .tex

      -- Folding ships disabled in VimTeX; this turns it on using each
      -- document's own structure (sections, environments, lists).
      vim.g.vimtex_fold_enabled = 1
      vim.g.vimtex_fold_level = 99

      -- SyncTeX is compiled into the Arch zathura package: `libsynctex` is a
      -- hard dependency of `zathura`, and the binary links against it. There is
      -- no separate synctex plugin to install on Arch. These are the extra
      -- argv only; VimTeX appends the file and the src:LINE position itself.
      --
      -- VimTeX's built-in zathura viewer already opens the PDF with synctex
      -- enabled and reloads it on recompile, so \lv and forward search work
      -- without any of this.
      vim.g.vimtex_zathura = { "zathura" }
    end,
  },

  -- Leader-prefixed aliases. VimTeX's own mappings are on <localleader> (\),
  -- which VimTeX's docs assume you keep. These are the same actions under
  -- <leader>tx for anyone who prefers not to reach for the backslash.
  --
  -- ft = "tex" rather than any/all: these only make sense inside a document.
  {
    "lervag/vimtex",
    lazy = false,
    keys = {
      {
        "<leader>txc",
        function()
          vim.cmd("VimtexCompile")
        end,
        desc = "LaTeX: compile document",
        ft = "tex",
      },
      {
        "<leader>txv",
        function()
          vim.cmd("VimtexView")
        end,
        desc = "LaTeX: view PDF in zathura",
        ft = "tex",
      },
    },
  },
}
