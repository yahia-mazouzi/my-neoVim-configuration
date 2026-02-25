require "nvchad.options"

-- add yours here!

local o = vim.o

-- Minimal and productive settings
o.cursorline = false -- Disable cursorline for less distraction
o.relativenumber = true -- Use absolute numbers only

-- Folding settings (ensures zf and other fold commands work)
o.foldmethod = "manual" -- Manual folding (use zf to create folds)
o.foldlevel = 99 -- Keep all folds open by default
o.foldlevelstart = 99 -- Start with all folds open

-- Open a new tab with 4 Claude Code instances in a 2x2 grid, focused on top-left
vim.api.nvim_create_user_command("NewClaudeSlaves", function()
  vim.cmd "tabnew"
  vim.cmd "terminal claude --dangerously-skip-permissions"
  vim.cmd "rightbelow vsplit | terminal claude --dangerously-skip-permissions"
  vim.cmd "wincmd t"
  vim.cmd "rightbelow split | terminal claude --dangerously-skip-permissions"
  vim.cmd "wincmd t"
  vim.cmd "wincmd l"
  vim.cmd "rightbelow split | terminal claude --dangerously-skip-permissions"
  vim.cmd "wincmd t"
end, { desc = "Open new tab with 4 Claude Code instances in a 2x2 grid" })

vim.api.nvim_create_user_command("NewGeminiSlaves", function()
  vim.cmd "tabnew"
  vim.cmd "terminal gemini"
  vim.cmd "rightbelow vsplit | terminal gemini"
  vim.cmd "wincmd t"
  vim.cmd "rightbelow split | terminal gemini"
  vim.cmd "wincmd t"
  vim.cmd "wincmd l"
  vim.cmd "rightbelow split | terminal gemini"
  vim.cmd "wincmd t"
end, { desc = "Open new tab with 4 Gemini instances in a 2x2 grid" })
