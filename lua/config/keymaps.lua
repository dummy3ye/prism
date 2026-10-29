-- User keymaps that are NOT already provided by a plugin.
--
-- This file used to be a full duplicate of the LSP and buffer bindings, but it
-- was never loaded (nothing required it), so the live versions are:
--   * LSP / diagnostics -> lua/plugins/lsp.lua (a strict superset)
--   * <C-n>             -> lua/plugins/neo-tree.lua
--   * <leader>x, <leader>q and friends -> lua/plugins/which-key.lua
-- Loading the old copy would have overridden <C-n> from
-- "Neotree filesystem reveal left" to "Neotree toggle", and would have
-- shadowed the <leader>x / <leader>q which-key groups with single actions.
--
-- Only genuinely additional bindings live here now.

vim.keymap.set("n", "<C-`>", "<cmd>ToggleTerm float<CR>", { desc = "Toggle floating terminal" })
vim.keymap.set("t", "<C-`>", "<C-\\><C-n><cmd>ToggleTerm float<CR>", { desc = "Toggle floating terminal (exit insert first)" })
vim.keymap.set("n", "<C-/>", "<cmd>ToggleTerm float<CR>", { desc = "Toggle floating terminal" })
vim.keymap.set("t", "<C-/>", "<C-\\><C-n><cmd>ToggleTerm float<CR>", { desc = "Toggle floating terminal (exit insert first)" })

-- ---------------------------------------------------------------------------
-- Editor-common control keys, all hitting the real system clipboard
-- ---------------------------------------------------------------------------
--   Ctrl+A  select all      Ctrl+C  copy      Ctrl+V  paste
--   Ctrl+X  cut             Ctrl+Z  undo      Ctrl+Y  redo      Ctrl+S  save
--
-- 'clipboard' is set to unnamedplus in lua/config/options.lua, so plain y, d
-- and p already move data through the real Wayland clipboard (nvim picks up
-- wl-copy/wl-paste automatically). These are the control-key shortcuts; they
-- read and write the `+` register, which is the same clipboard.
--
-- Note: vim.paste() is only a hook that nvim_paste() invokes. Calling it
-- directly errors with "attempt to compare nil with number", so the insert
-- mode paste below goes through nvim_paste(), the public entry point. Being an
-- API call rather than a :normal command, it also leaves us in insert mode.

-- Copy. `"+yy` yanks the current line in normal mode and the selection in
-- visual mode, so one command covers both.
vim.keymap.set({ "n", "v" }, "<C-c>", function()
  vim.cmd([[normal! "+yy]])
end, { desc = "Copy" })

-- Cut. `"+d` deletes the line, or the selection in visual mode. Deliberately
-- not mapped in insert mode, where Ctrl+X already means "delete the character
-- before the cursor".
vim.keymap.set({ "n", "v" }, "<C-x>", function()
  vim.cmd([[normal! "+d]])
end, { desc = "Cut" })

-- Paste. In visual mode this replaces the selection.
vim.keymap.set({ "n", "v", "x", "o" }, "<C-v>", function()
  if vim.v.operator ~= "" then
    -- Operator pending, e.g. d<C-v> or c<C-v>. Hand the paste back as a motion
    -- instead of performing it, so the operator applies to it.
    vim.api.nvim_feedkeys([["+p]], "n", false)
  else
    vim.cmd([[normal! "+p]])
  end
end, { desc = "Paste" })

-- Insert mode paste, staying in insert mode.
vim.keymap.set("i", "<C-v>", function()
  vim.api.nvim_paste(vim.fn.getreg("+", true, true), true, -1)
end, { desc = "Paste" })

-- In insert mode Ctrl+C exits to normal mode, as in every other editor. Left
-- default it can surface as an error when an operator is pending, so feed
-- <Esc> explicitly.
vim.keymap.set("i", "<C-c>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Exit insert mode" })

-- Select all. The editor-common meaning of Ctrl+A, rather than the vim-idiomatic
-- gc (increment number under cursor), which stays available as gc.
vim.keymap.set("n", "<C-a>", "ggVG", { desc = "Select all" })
vim.keymap.set("v", "<C-a>", "ggVG", { desc = "Select all" })

-- Undo / redo. Mapped in normal mode only: insert mode has no reason to
-- intercept them, and Ctrl+Z there is expected to keep typing normally.
vim.keymap.set("n", "<C-z>", "u", { desc = "Undo" })
vim.keymap.set("n", "<C-y>", "<C-r>", { desc = "Redo" })

-- Save, in every mode. Ctrl+S is what every other editor uses for it.
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", { desc = "Save" })

-- Middle click pastes from the system clipboard. Insert mode already does this
-- natively; normal mode does nothing useful by default.
vim.keymap.set("n", "<Middle-Release>", function()
  vim.cmd([[normal! "+p]])
end, { desc = "Paste (middle click)" })

-- ---------------------------------------------------------------------------
-- Everyday conveniences
-- ---------------------------------------------------------------------------

vim.keymap.set("n", "Q", "<cmd>quit<cr>", { desc = "Quit window" })

-- <Esc> clears the search highlight, so you are not left staring at stale
-- matches after moving the cursor.
for _, mode in ipairs({ "n", "v" }) do
  vim.keymap.set(mode, "<Esc>", function()
    if vim.fn.mode() ~= "n" and vim.fn.mode() ~= "v" then
      return
    end
    vim.cmd("nohlsearch")
  end, { desc = "Clear search highlight" })
end

-- Window navigation with Alt. Deliberately Alt rather than <C-h/j/k/l>, since
-- <C-j> and <C-k> already mean "line down" and "undo line" in normal mode.
vim.keymap.set("n", "<A-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<A-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<A-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<A-l>", "<C-w>l", { desc = "Window right" })

-- ---------------------------------------------------------------------------
-- Buffer navigation
-- ---------------------------------------------------------------------------

-- bufferline.nvim is disabled (see lua/plugins/dynamic.lua), so the
-- BufferLineCycle* commands do not exist; use Vim's own buffer commands.
vim.keymap.set("n", "<S-h>", "<cmd>silent! bprevious<cr>", { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>silent! bnext<cr>", { silent = true, desc = "Next buffer" })

-- ---------------------------------------------------------------------------
-- Quick project shortcuts
-- ---------------------------------------------------------------------------

vim.keymap.set("n", "<leader>wd", function()
  vim.cmd("cd " .. vim.fn.getcwd())
end, { desc = "Reset working directory" })

-- Location list: lsp.lua maps <leader>ld for the line float and which-key owns
-- the <leader>q group, so this uses a distinct key rather than shadowing it.
vim.keymap.set("n", "<leader>ll", vim.diagnostic.setloclist, { desc = "Open error list" })

-- ---------------------------------------------------------------------------
-- Mouse
-- ---------------------------------------------------------------------------
-- 'mouse' is already "a" (see lua/config/options.lua), which covers clicks,
-- scroll wheel and drag-select. The one rough edge is the command line: with
-- mouse reporting on, kitty cannot select `:` text natively, because nvim
-- swallows the drag. Turn reporting off while the command line is open and
-- restore it after, so selection works there and everywhere else.
local saved_mouse = nil

vim.api.nvim_create_autocmd("CmdlineEnter", {
  group = vim.api.nvim_create_augroup("cmdline-mouse", { clear = true }),
  callback = function()
    saved_mouse = vim.o.mouse
    if saved_mouse ~= "" then
      vim.o.mouse = ""
    end
  end,
})

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = vim.api.nvim_create_augroup("cmdline-mouse", { clear = true }),
  callback = function()
    if saved_mouse then
      vim.o.mouse = saved_mouse
      saved_mouse = nil
    end
  end,
})
