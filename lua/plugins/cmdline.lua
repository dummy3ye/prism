return {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
        -- add any options here
    },
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    },
    config = function()
        -- colors-wal.vim is not produced by the matugen pipeline (and no longer
        -- exists), so sourcing it must not be fatal. Fall back to the dynamic
        -- palette for the cmdline/notify accent colours.
        pcall(vim.cmd, "source ~/.cache/wal/colors-wal.vim")
        local palette = require("dynamic").palette
        local color9 = vim.g.color9 or palette.tertiary
        local color5 = vim.g.color5 or palette.primary

        -- nvim-notify defaults background_colour to "NotifyBackground", which
        -- links to Normal. Normal is transparent here (bg = "none"; see
        -- lua/transparency.lua), so the group resolves with no bg and notify
        -- warns on first use. Pass a function instead of a highlight group so
        -- the value is read fresh each time and follows the dynamic palette
        -- (a plain hex would go stale on the next theme/wallpaper change).
        require("notify").setup({
            background_colour = function()
                return require("dynamic").palette.background
            end,
        })

        require("noice").setup({
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
            },
            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = false,
            },
        })
        vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { fg = color9 })
        vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = color5 })
        vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = color5 })
        vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = color9 })
        vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = color5 })
    end,
}

