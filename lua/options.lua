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
