return {
  "mbbill/undotree",
  lazy = false,
  config = function()
    vim.cmd [[nnoremap <Leader>u :UndotreeToggle<CR>]] -- Key mapping to toggle undotree
  end,
}
