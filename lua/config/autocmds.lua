-- Transparency is owned by lua/transparency.lua (loaded from init.lua), which
-- covers far more groups than the eight this used to clear. Calling into it
-- here keeps BufEnter-based re-application without duplicating the group list.
local apply_transparency = function()
  require("transparency").apply()
end

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
    -- pcall because this fires on every directory change, including before
    -- neo-tree has finished loading. An unguarded require here throws a
    -- "module not found" error into the message area.
    pcall(function()
      require("neo-tree.command").execute({ action = "focus", dir = vim.fn.getcwd() })
    end)
  end,
})

vim.opt.autoread = true

local function watch_files()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "" then
      local name = vim.api.nvim_buf_get_name(buf)
      if name and name ~= "" then
        local stat = vim.loop.fs_stat(name)
        local modsave = vim.bo[buf].modified
        if stat and stat.mtime and stat.mtime.sec then
          local file_mtime = stat.mtime.sec * 1e6 + (stat.mtime.nsec or 0) / 1000
          local now = os.time() * 1e6
          if file_mtime <= now and not modsave then
            pcall(vim.cmd, "silent! edit! " .. vim.fn.fnameescape(name))
          end
        end
      end
    end
  end
end

local timer = vim.loop.new_timer()
if timer then
  timer:start(500, 500, vim.schedule_wrap(function() watch_files() end))
end

apply_transparency()

