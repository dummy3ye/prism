local M = {}
local state = require("settingsstate")

local function refresh_bars()
    vim.cmd("redrawstatus")
    local ok_lualine, lualine = pcall(require, "lualine")
    if ok_lualine and lualine.refresh then
        lualine.refresh({
            place = { "statusline", "tabline", "winbar" },
            trigger = "colorscheme",
        })
    end
end

local function sync_lualine_theme(theme_name)
    local ok_lualine, lualine = pcall(require, "lualine")
    if not ok_lualine or not lualine.get_config or not lualine.setup then
        return
    end

    local cfg = lualine.get_config()
    if not cfg or type(cfg) ~= "table" then
        return
    end

    cfg.options = cfg.options or {}
    cfg.options.theme = theme_name
    lualine.setup(cfg)
end

local function apply_pywal_plugin_overrides()
    local color_fg = vim.g.foreground or "#ffffff"
    local color1 = vim.g.color1 or color_fg
    local color5 = vim.g.color5 or color_fg
    local color9 = vim.g.color9 or color_fg

    -- These are configured during startup in cmdline/noice config and need to
    -- be reapplied when returning to pywal.
    vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = color9 })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = color5 })
    vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = color5 })
    vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = color9 })
    vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = color5 })

    -- Neo-tree groups are not covered by pywal.nvim (it supports nvim-tree).
    -- bg stays "none" so the terminal background shows through; see
    -- lua/transparency.lua.
    vim.api.nvim_set_hl(0, "NeoTreeNormal", { fg = color_fg, bg = "none" })
    vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { fg = color_fg, bg = "none" })
    vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = color1, bg = "none" })

    -- This runs in vim.schedule after the ColorScheme autocmds, so it can
    -- reintroduce solid backgrounds. Re-assert transparency last.
    require("transparency").apply()
end

local function set_colorscheme(theme)
    local ok, err = pcall(vim.cmd, "colorscheme " .. theme)
    if not ok then
        vim.notify("Theme not available: " .. theme .. " (" .. tostring(err) .. ")", vim.log.levels.ERROR)
        return false
    end
    return true
end

function M.apply_theme(theme)
    if not set_colorscheme(theme) then
        return
    end

    vim.g.current_theme = theme
    state.set("theme", theme)
    -- lualine has no "auto" theme; use the real colorscheme name so the bar
    -- keeps matching instead of falling back to lualine's default.
    sync_lualine_theme(vim.g.colors_name or theme)
    refresh_bars()
    -- The colorscheme just repainted solid backgrounds. Re-assert transparency
    -- after the event queue drains, so ours are the values that stick.
    vim.schedule(function()
        require("transparency").apply()
    end)
end

function M.use_pywal()
    vim.cmd("source ~/.cache/wal/colors-wal.vim")

    -- Prefer official colorscheme path so plugins listening to ColorScheme update.
    if not set_colorscheme("pywal") then
        -- Fallback for pywal.nvim variants that only expose setup().
        local ok, pywal = pcall(require, "pywal")
        if ok and pywal.setup then
            pywal.setup()
            vim.g.colors_name = "pywal"
            vim.api.nvim_exec_autocmds("ColorScheme", { pattern = "pywal" })
        else
            return
        end
    end

    -- colors-wal.vim defines its highlight groups inline and never assigns
    -- g:colors_name, so :colorscheme leaves that variable pointing at whatever
    -- colorscheme ran before it. Anything keyed off colors_name then reads a
    -- stale name: lualine highlights the old theme, and lua/transparency.lua's
    -- disable path re-applies that old theme via `colorscheme <colors_name>`.
    -- Set it here so colors_name and current_theme always agree.
    vim.g.colors_name = "pywal"

    vim.g.current_theme = "pywal"
    state.set("theme", "pywal")

    -- Schedule once to run after colorscheme listeners from other plugins.
    vim.schedule(function()
        apply_pywal_plugin_overrides()
        sync_lualine_theme("pywal-nvim")
        refresh_bars()
    end)
end

function M.init()
    vim.g.current_theme = state.get("theme", nil)

    vim.api.nvim_create_user_command("ThemePywal", function()
        M.use_pywal()
    end, { desc = "Use pywal for all highlights" })

    vim.api.nvim_create_user_command("ThemeFileTokyo", function()
        M.apply_theme("tokyonight")
    end, { desc = "Switch full theme to tokyonight" })

    vim.api.nvim_create_user_command("ThemeFileGruvbox", function()
        M.apply_theme("gruvbox")
    end, { desc = "Switch full theme to gruvbox" })

    vim.api.nvim_create_user_command("ThemeFileKanagawa", function()
        M.apply_theme("kanagawa")
    end, { desc = "Switch full theme to kanagawa" })

    vim.api.nvim_create_user_command("ThemeFileCatppuccin", function()
        M.apply_theme("catppuccin-macchiato")
    end, { desc = "Switch full theme to catppuccin macchiato" })

    vim.api.nvim_create_user_command("ThemeFileRosePine", function()
        M.apply_theme("rose-pine")
    end, { desc = "Switch full theme to rose-pine" })

    vim.api.nvim_create_user_command("ThemeFileNord", function()
        M.apply_theme("nord")
    end, { desc = "Switch full theme to nord" })

    vim.api.nvim_create_user_command("ThemeFileEverforest", function()
        M.apply_theme("everforest")
    end, { desc = "Switch full theme to everforest" })

    vim.api.nvim_create_user_command("ThemeFileOneDark", function()
        M.apply_theme("onedark")
    end, { desc = "Switch full theme to onedark" })

    vim.api.nvim_create_user_command("ThemeFileCarbonfox", function()
        M.apply_theme("carbonfox")
    end, { desc = "Switch full theme to carbonfox" })

    vim.api.nvim_create_user_command("ThemeFileGithub", function()
        M.apply_theme("github_dark_dimmed")
    end, { desc = "Switch full theme to github dark dimmed" })

    vim.api.nvim_create_user_command("ThemeFileVSCode", function()
        M.apply_theme("vscode")
    end, { desc = "Switch full theme to vscode" })

    vim.api.nvim_create_user_command("ThemeFileGruvboxMaterial", function()
        M.apply_theme("gruvbox-material")
    end, { desc = "Switch full theme to gruvbox material" })

    vim.api.nvim_create_user_command("ThemeDynamic", function()
        M.apply_theme("dynamic")
    end, { desc = "Follow the wallpaper palette (colorscheme 'dynamic')" })

    -- Monoglow ships several styles. "monoglow" is the default ("z") style;
    -- the others are monoglow-lack, monoglow-void and monoglow-light.
    vim.api.nvim_create_user_command("ThemeFileMonoGlow", function()
        M.apply_theme("monoglow")
    end, { desc = "Switch full theme to monoglow" })

    vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("ui-theme-refresh-bars", { clear = true }),
        callback = function()
            refresh_bars()
        end,
    })

    vim.schedule(function()
        -- Deliberately no default here. If nothing is saved, we must not fall
        -- back to a name and then persist it: use_pywal() and apply_theme() both
        -- write state.set("theme", ...), so passing a default would turn a
        -- transient empty/unreadable state file into a permanent pywal choice
        -- that silently overwrites whatever the user had actually selected.
        -- Only a theme that is genuinely recorded gets applied and re-saved.
        local saved = state.get("theme", nil)

        if saved == nil then
            -- Nothing recorded yet: pick a starting point and record it, which
            -- is the one case where writing a default is correct.
            saved = "dynamic"
            vim.g.current_theme = saved
            state.set("theme", saved)
        end

        if saved == "pywal" then
            M.use_pywal()
        else
            M.apply_theme(saved)
        end
    end)
end

return M
