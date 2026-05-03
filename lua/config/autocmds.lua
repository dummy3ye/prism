-- Transparency Fix: Ensures background stays transparent across different UI events
local function apply_transparency()
    local groups = {
        "Normal", "NormalNC", "LineNr", "NonText", "EndOfBuffer", 
        "SignColumn", "VertSplit", "WinSeparator"
    }
    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
    end
end

vim.api.nvim_create_autocmd({"VimEnter", "ColorScheme", "BufEnter"}, {
    callback = apply_transparency,
})

-- Neovim 0.11 compatibility shim for Treesitter
if vim.treesitter.language.get_lang and not vim.treesitter.language.ft_to_lang then
  vim.treesitter.language.ft_to_lang = vim.treesitter.language.get_lang
end

-- Enable spellcheck only for Markdown and Text files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_us"
  end,
})

-- Automatically sync Neo-tree to the project root
vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "global",
  callback = function()
    require("neo-tree.command").execute({ action = "focus", dir = vim.fn.getcwd() })
  end,
})

apply_transparency()
