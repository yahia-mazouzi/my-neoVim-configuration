require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "gv", function()
  vim.cmd "vsplit"
  vim.lsp.buf.definition()
end, { desc = "Go to definition in vsp" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
