-- ~/.config/nvim/lua/plugins/alpha.lua
return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local dashboard = require("alpha.themes.dashboard")

        -- Define color groups once (used by programmatic highlight)
        vim.api.nvim_set_hl(0, "AlphaA", { fg = "#a6e3a1" })
        vim.api.nvim_set_hl(0, "AlphaB", { fg = "#89b4fa" })
        vim.api.nvim_set_hl(0, "AlphaC", { fg = "#f38ba8" })
        vim.api.nvim_set_hl(0, "AlphaD", { fg = "#cba6f7" })
        vim.api.nvim_set_hl(0, "AlphaE", { fg = "#f9e2af" })

        local function colorize(lines, groups)
            local hl = {}
            for i, line in ipairs(lines) do
                local row = {}
                local len = #line
                local n = #groups
                local step = math.ceil(len / n)
                for g = 1, n do
                    local s = (g - 1) * step
                    local e = math.min(g * step, len)
                    if s < len then
                        table.insert(row, { groups[g], s, e })
                    end
                end
                table.insert(hl, row)
            end
            return hl
        end

        -- Dashboard header (new figlet)
        local logo = {
            [[██▀███   ▒█████    ██████ ▓█████ ██▒   █▓ ██▓ ███▄ ▄███▓]],
            [[▓██ ▒ ██▒▒██▒  ██▒▒██    ▒ ▓█   ▀▓██░   █▒▓██▒▓██▒▀█▀ ██▒]],
            [[▓██ ░▄█ ▒▒██░  ██▒░ ▓██▄   ▒███   ▓██  █▒░▒██▒▓██    ▓██░]],
            [[▒██▀▀█▄  ▒██   ██░  ▒   ██▒▒▓█  ▄  ▒██ █░░░██░▒██    ▒██ ]],
            [[░██▓ ▒██▒░ ████▓▒░▒██████▒▒░▒████▒  ▒▀█░  ░██░▒██▒   ░██▒]],
            [[░ ▒▓ ░▒▓░░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░░░ ▒░ ░  ░ ▐░  ░▓  ░ ▒░   ░  ░]],
            [[░▒ ░ ▒░  ░ ▒ ▒░ ░ ░▒  ░ ░ ░ ░  ░  ░ ░░   ▒ ░░      ░   ]],
            [[░         ░ ░        ░     ░  ░     ░   ░         ░   ]],
            [[                                                 ░ ]],
        }

        dashboard.section.header.val = logo
        dashboard.section.header.opts.hl = colorize(logo, {
            "AlphaA", "AlphaB", "AlphaC", "AlphaD", "AlphaE",
        })

        -- Refresh palette when colorscheme changes (optional)
        local function refresh_alpha_palette()
            vim.api.nvim_set_hl(0, "AlphaA", { fg = "#a6e3a1" })
            vim.api.nvim_set_hl(0, "AlphaB", { fg = "#89b4fa" })
            vim.api.nvim_set_hl(0, "AlphaC", { fg = "#f38ba8" })
            vim.api.nvim_set_hl(0, "AlphaD", { fg = "#cba6f7" })
            vim.api.nvim_set_hl(0, "AlphaE", { fg = "#f9e2af" })
            pcall(vim.cmd, "AlphaRedraw")
        end

        -- Dashboard buttons
        dashboard.section.buttons.val = {
            dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("f", "󰱼  > Find file", ":lua require('telescope.builtin').find_files({ hidden = true, no_ignore = true })<CR>"),
            dashboard.button("F", "󰥨  > Find folder", ":lua _G.search_and_scope_into_directory()<CR>"),
            dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
            dashboard.button("c", "  > Config", ":cd ~/.config/nvim | Telescope find_files<CR>"),
            dashboard.button("l", "󰒲 > Lazy", ":Lazy<CR>"),
            dashboard.button("h", "  > Settings", ":cd ~/.config/hypr | Telescope find_files<CR>"),
            dashboard.button("q", "  > Quit", ":qa<CR>"),
        }

        dashboard.section.footer.val = { "", "" }

        -- Finally setup Alpha
        require("alpha").setup({
            layout = {
                { type = "padding", val = 6 },
                dashboard.section.header,
                { type = "padding", val = 2 },
                dashboard.section.buttons,
                { type = "padding", val = 1 },
                dashboard.section.footer,
            },
            opts = {
                margin = 5,
                setup = function()
                    vim.api.nvim_create_autocmd("ColorScheme", {
                        group = vim.api.nvim_create_augroup("alpha-theme-palette", { clear = true }),
                        callback = refresh_alpha_palette,
                    })
                end,
            },
        })

        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("alpha-theme-palette", { clear = true }),
            callback = refresh_alpha_palette,
        })
    end,
}
