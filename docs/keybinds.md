# Neovim Keybinds

Leader: `<Space>`  ·  Local leader (LaTeX): `\`

Everything below was read from a live session (`:verbose map` + buffer-local
maps for LSP, Markdown and `.tex` buffers), not copied from plugin docs.

Mode column: `normal`, `visual`, `select`, `operator-pending`, `insert`. These
name Vim's modes, not keys. Vim separates Visual from Select mode, and a mapping
created with `:vmap` applies to both, so many rows list the two together.

Pressing `x` in normal mode is a *key*, not a mode: it is Vim's built-in
delete-character command (in visual mode it deletes the selection). This config
does not remap it.

## Leader groups (which-key)

| Prefix | Group |
| --- | --- |
| `<leader>a` | AI (Copilot) |
| `<leader>f` | Find (Telescope) |
| `<leader>l` | LSP |
| `<leader>g` | Git |
| `<leader>e` | Neo-tree |
| `<leader>u` | UI (`uc` completion, `um` markdown, `ut` theme) |
| `<leader>q` | Quit / sessions |
| `<leader>w` | Write / working dir |
| `<leader>x` | Tools (Trouble, Lazy, Mason) |
| `<leader>tx` | LaTeX (VimTeX) |

`<leader>?` shows the buffer-local keymaps with which-key.

## Clipboard and common editing

These use the real system clipboard (`clipboard=unnamedplus`), so plain `y`,
`d` and `p` already go through it.

| Key | Mode | Action |
| --- | --- | --- |
| `<C-a>` | normal, visual, select | Select all |
| `<C-c>` | normal, visual, select | Copy line / selection |
| `<C-v>` | normal, visual, select, operator-pending | Paste (replaces selection in visual mode) |
| `<C-x>` | normal, visual, select | Cut line / selection |
| `<C-z>` | normal | Undo |
| `<C-y>` | normal | Redo |
| `<C-s>` | normal, insert, visual, select | Save buffer |
| `<Middle-Release>` | normal | Paste from clipboard |
| `<Esc>` | normal, visual, select | Clear search highlight |
| `Q` | normal | Quit window |

Notes:

- `<C-c>` in **insert** mode exits to normal mode instead of copying.
- `<C-x>` in insert mode is left alone (delete char before cursor).
- `<C-a>` is select-all, so the numeric increment is no longer on `<C-a>`
  (it is still `g<C-a>` in visual mode).
- `<C-v>` is paste, so blockwise visual is on `<C-q>`.
- `<C-s>` in insert mode does not leave insert mode.

## Windows

| Key | Mode | Action |
| --- | --- | --- |
| `<A-h>` / `<M-h>` | normal | Window left |
| `<A-j>` / `<M-j>` | normal | Window down |
| `<A-k>` / `<M-k>` | normal | Window up |
| `<A-l>` / `<M-l>` | normal | Window right |

Alt is used instead of `<C-h/j/k/l>` because `<C-j>`/`<C-k>` still mean line
down / undo line.

## Buffers and sessions

| Key | Mode | Action |
| --- | --- | --- |
| `H` (`<S-h>`) | normal | Previous buffer |
| `L` (`<S-l>`) | normal | Next buffer |
| `<leader>qs` | normal | Restore session (current dir) |
| `<leader>ql` | normal | Restore last session |
| `<leader>qd` | normal | Don't save the current session |

`H`/`L` take over Vim's "top / bottom of screen" (use `gg`/`G`).

## File tree (Neo-tree)

| Key | Mode | Action |
| --- | --- | --- |
| `<C-n>` | normal | Toggle tree (reopens on the side it was last shown) |
| `<leader>e` | normal | Toggle tree |
| `<leader>el` | normal | Show tree on the left (moves it if open) |
| `<leader>er` | normal | Show tree on the right (moves it if open) |
| `<leader>es` | normal | Swap side (left <-> right) |

Default position is the right side. `<leader>el`/`er` move an open tree; they
do not close it.

## Find (Telescope)

| Key | Mode | Action |
| --- | --- | --- |
| `<C-p>` | normal | Find files |
| `<A-f>` | normal | Live grep |
| `<A-d>` | normal | Pick a directory and `cd` into it |
| `<leader>/` | normal | Fuzzy find in the current buffer |
| `<leader>ff` | normal | Find files |
| `<leader>fg` | normal | Live grep |
| `<leader>fb` | normal | Find open buffers |
| `<leader>fh` | normal | Help tags |
| `<leader>fo` | normal | Recent files |
| `<leader>fr` | normal | Resume last picker |
| `<leader>fk` | normal | Find keymaps |
| `<leader>fc` | normal | Find commands |
| `<leader>fd` | normal | Find diagnostics |
| `<leader>fD` | normal | Find directory and `cd` |

## Jump and search-replace

| Key | Mode | Action |
| --- | --- | --- |
| `s` | normal, visual, operator-pending | Flash jump |
| `S` | normal, visual, operator-pending | Flash Treesitter |
| `<leader>sr` | normal | Search and replace (grug-far) |

`s` is taken by Flash, so substituting a character is `cl`.

## LSP (buffer-local, active after a server attaches)

| Key | Mode | Action |
| --- | --- | --- |
| `gd` | normal | Go to definition |
| `gr` | normal | References |
| `gI` | normal | Go to implementation |
| `K` | normal | Hover documentation |
| `<leader>rn` | normal | Rename symbol |
| `<leader>ca` | normal | Code action |
| `<leader>lf` | normal | Format buffer |
| `<leader>ld` | normal | Diagnostic float for the current line |
| `[d` / `]d` | normal | Previous / next diagnostic (buffer) |

Neovim's own LSP defaults remain available: `gra`, `grn`, `grr`, `gri`, `grt`,
`grx`, `gO`, and `<C-w>d`.

## Diagnostics and lists

| Key | Mode | Action |
| --- | --- | --- |
| `[d` / `]d` | normal | Previous / next diagnostic |
| `[D` / `]D` | normal | First / last diagnostic in buffer (built-in) |
| `<leader>ll` | normal | Send diagnostics to the location list |
| `<leader>xx` | normal | Diagnostics (Trouble) |
| `<leader>xX` | normal | Buffer diagnostics (Trouble) |
| `<leader>cs` | normal | Symbols (Trouble) |
| `<leader>cl` | normal | LSP definitions / references (Trouble, right split) |
| `<leader>xL` | normal | Location list (Trouble) |
| `<leader>xQ` | normal | Quickfix list (Trouble) |

## Git

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>gg` | normal | Lazygit |
| `<leader>gl` | normal | Lazygit log (cwd) |
| `<leader>gf` | normal | Lazygit current file history |
| `<leader>gb` | normal | Git blame line |
| `<leader>gB` | normal, visual, select | Git browse (open in browser) |

gitsigns is installed and shows signs, but this config defines **no** gitsigns
keymaps. Use its commands, e.g. `:Gitsigns diffthis`,
`:Gitsigns toggle_current_line_blame`, `:Gitsigns reset_hunk`.

## Markdown (buffer-local, Markview)

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>umt` | normal | Toggle preview (persistent) |
| `<leader>umh` | normal | Toggle hybrid mode (persistent) |
| `<leader>umr` | normal | Re-render all |
| `gO` | normal | Outline of the buffer (Markview) |
| `[[` / `]]` | normal | Previous / next section (Markview) |
| `gx` | normal | Open the link under the cursor (Markview) |

## Completion

Insert / select mode mappings from nvim-cmp:

| Key | Mode | Action |
| --- | --- | --- |
| `<C-Space>` | insert | Trigger completion |
| `<C-e>` | insert | Abort completion |
| `<C-b>` / `<C-f>` | insert | Scroll docs up / down |
| `<C-y>` | insert | Confirm selected item |
| `<CR>` | insert | Confirm only an explicitly selected item |
| `<Tab>` | insert, select | Confirm / expand snippet / jump, else insert tab |
| `<S-Tab>` | insert, select | Previous item, else jump back in the snippet |

Modes are switched with:

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>ucc` | normal | Cycle: inline -> menu + inline -> off |
| `<leader>uci` | normal | Inline-only |
| `<leader>ucm` | normal | Menu + inline |
| `<leader>uco` | normal | Off |

## UI and tools

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>us` | normal | Toggle spelling |
| `<leader>uw` | normal | Toggle line wrap |
| `<leader>z` | normal | Zen mode |
| `<leader>s` | normal | Scratch buffer |
| `<leader>S` | normal | Select scratch buffer |
| `<leader>ih` | normal | Image hover |
| `<leader>N` | normal | Neovim news |
| `<C-/>` | normal | Floating terminal (Snacks) |
| `<C-\>` | normal, insert | Floating terminal (toggleterm) |
| `<leader>xl` | normal | Open Lazy |
| `<leader>xm` | normal | Open Mason |
| `<leader>ws` | normal | Write buffer |
| `<leader>qq` | normal | Quit all |
| `<leader>qQ` | normal | Force quit all |
| `<leader>wd` | normal | Reset working directory to cwd |

## Themes

| Key | Mode | Theme |
| --- | --- | --- |
| `<leader>utp` | normal | Full pywal |
| `<leader>utt` | normal | TokyoNight |
| `<leader>utg` | normal | Gruvbox |
| `<leader>utk` | normal | Kanagawa |
| `<leader>utc` | normal | Catppuccin Macchiato |
| `<leader>utr` | normal | Rose Pine |
| `<leader>utn` | normal | Nord |
| `<leader>ute` | normal | Everforest |
| `<leader>uto` | normal | OneDark |
| `<leader>utf` | normal | Carbonfox |
| `<leader>uth` | normal | GitHub Dark Dimmed |
| `<leader>utv` | normal | VSCode |
| `<leader>utm` | normal | Gruvbox Material |

Monoglow and the dynamic (wallpaper) theme are commands only:
`:ThemeFileMonoGlow`, `:ThemeDynamic`.

## AI (CopilotChat)

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>aa` | normal | Authenticate Copilot |
| `<leader>ap` | normal | Toggle right panel |
| `<leader>ao` | normal | Open right panel |
| `<leader>ac` | normal | Close panel |
| `<leader>ar` | normal | Reset chat |
| `<leader>as` | normal | Stop response |

## LaTeX (`.tex` buffers)

VimTeX's own mappings are on the local leader `\`:

| Key | Action |
| --- | --- |
| `\ll` | Compile (latexmk) |
| `\lv` | View PDF in zathura |
| `\lt` | Open table of contents |
| `\lT` | Toggle table of contents |
| `\lk` | Stop compilation |
| `\lK` | Stop all |
| `\lo` | Show compiler output |
| `\le` | Errors |
| `\lq` | Log |
| `\lc` | Clean aux files |
| `\lC` | Full clean (removes the PDF too) |
| `\li` | Info |
| `\lI` | Full info |
| `\lg` | Status |
| `\lG` | Status (all) |
| `\lx` | Reload VimTeX state |
| `\lX` | Reload VimTeX state for all |
| `\ls` | Toggle "main" document |
| `\lL` | Compile the selected file |
| `\lS` | Compile with `-ss` |
| `\lm` | Show `imaps` mappings |
| `\la` | Context menu |

Leader aliases:

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>txc` | normal | Compile document |
| `<leader>txv` | normal | View PDF in zathura |

Saving a `.tex` file recompiles automatically (`continuous = 1`), and zathura
reloads the PDF itself. `\lt` is the table of contents, **not** compile+view.

## Dashboard (Alpha start screen)

These only work on the empty start screen, not globally:

| Key | Action |
| --- | --- |
| `e` | New file |
| `f` | Find file |
| `F` | Find folder |
| `r` | Recent files |
| `c` | Neovim config search |
| `l` | Open Lazy |
| `h` | Hypr config search |
| `q` | Quit |

## Useful built-in Neovim defaults (not configured here)

- `gc` / `gcc` — toggle comment (line / selection)
- `gra`, `grn`, `grr`, `gri`, `grt`, `grx` — LSP actions
- `gx` — open file/URL under cursor with the system handler
- `[d` / `]d`, `[D` / `]D` — diagnostics navigation
- `[q` / `]q`, `[l` / `]l`, `[t` / `]t`, `[b` / `]b`, `[a` / `]a` — quickfix,
  location list, tags, buffers, argument list
- `[<Space>` / `]<Space>` — add an empty line above / below

## Commands (not keybinds)

Themes: `:ThemePywal`, `:ThemeDynamic`, `:ThemeFileTokyo`,
`:ThemeFileGruvbox`, `:ThemeFileKanagawa`, `:ThemeFileCatppuccin`,
`:ThemeFileRosePine`, `:ThemeFileNord`, `:ThemeFileEverforest`,
`:ThemeFileOneDark`, `:ThemeFileCarbonfox`, `:ThemeFileGithub`,
`:ThemeFileVSCode`, `:ThemeFileGruvboxMaterial`, `:ThemeFileMonoGlow`.

Completion: `:CmpToggleMenu`, `:CmpToggleMode`, `:CmpModeInline`,
`:CmpModeMenu`, `:CmpModeOff`.

Tools: `:Lazy`, `:Mason`, `:ConformInfo`, `:Typr`, `:TyprStats`,
`:Gitsigns`, `:Copilot auth`, `:CopilotChat`, `:CopilotChatOpen`,
`:CopilotChatToggle`, `:Markview Render`, `:Markview Toggle`,
`:Markview HybridToggle`.

LaTeX: `:VimtexCompile`, `:VimtexView`, `:VimtexInverseSearch`,
`:VimtexErrors`, `:VimtexInfo`, `:VimtexClean`, `:VimtexStop`.

## Mouse

- `mouse=a`: click to move, drag to select, wheel to scroll, middle click to
  paste.
- Mouse reporting is disabled while the `:` command line is open, so text can be
  selected and copied natively there, then restored on exit.

## Persistent state

Restored on startup from `stdpath("state")/settings_state.json`:

- theme (including `pywal` and `dynamic`)
- completion mode
- markview preview / hybrid toggles
- `wrap` and `spell`
