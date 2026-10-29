# Prism

a pretty cool neovim configuration

<img src="https://github.com/dummy3ye/rosevim/blob/master/assets/openeditor.png" alt ="editor">

## What it is

- **Dynamic theming.** `pywal` or anu wall-t-pallet generator writes the palette, `colors/dynamic.lua` maps it
  into editor highlights, and the accent colours are re-derived per wallpaper
  rather than hardcoded.
- **15 palettes**, switchable at runtime without restarting.
- **Documented keybinds.** [`keybinds.md`](keybinds.md)

## Requirements

| Dependency | Needed for |
| --- | --- |
| Neovim `>= 0.12.4` | everything (developed on `0.12.6`) |
| `git` | plugin management (lazy.nvim) |
| `rg` | Telescope live grep |
| A Nerd Font | icons (mini.icons, web-devicons) |

Optional:

| Dependency | Needed for |
| --- | --- |
| `wal` (pywal) | the `dynamic` / `pywal` themes |
| TeX Live + `latexmk` + `zathura` | LaTeX buffers |
| `node` + a Copilot subscription | Copilot and CopilotChat |
| LSP servers via `:Mason` | completion, diagnostics, formatting |

## Install

```sh
git clone https://github.com/dummy3ye/prism ~/.config/nvim
nvim
```

lazy.nvim bootstraps itself on first start. Then run `:Mason` to install the
language servers, or let `mason-lspconfig` fetch the ones listed in
`lua/plugins/lsp.lua`.

## Layout

```text
init.lua              entry point (leader keys, lazy bootstrap)
lua/config/           options, keymaps, autocommands
lua/plugins/          plugin specs, one file per area
lua/uitheme.lua       theme registry, :Theme* commands, pywal integration
lua/settingsstate.lua persisted settings (theme, completion mode, wrap, spell)
colors/dynamic.lua    wallpaper-derived colorscheme
colors/               plain colorscheme files
```

## Theming

`:ThemeDynamic` follows the wallpaper. `:ThemePywal` applies a pywal palette
once. The rest are fixed palettes:

```text
:ThemeFileTokyo            :ThemeFileGruvbox
:ThemeFileKanagawa         :ThemeFileCatppuccin
:ThemeFileRosePine         :ThemeFileNord
:ThemeFileEverforest       :ThemeFileOneDark
:ThemeFileCarbonfox        :ThemeFileGithub
:ThemeFileVSCode           :ThemeFileGruvboxMaterial
:ThemeFileMonoGlow
```

## State

The chosen theme, completion mode, preview and hybrid toggles, `wrap` and
`spell` are written to `stdpath("state")/settings_state.json` and restored on
startup, so theme choice survives restarts.

## Keybinds

[`keybinds.md`](keybinds.md) — leader groups, editing, LSP, LaTeX, themes and
the built-in defaults this config inherits.

## Licence

Plugin code belongs to its respective authors. The configuration files here are
yours to reuse.
