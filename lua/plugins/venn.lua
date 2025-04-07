return {
  "jbyuki/venn.nvim",
  lazy = true,
  cmd = { "VennStart" }, -- triggers plugin loading
  config = function()
    local map = vim.keymap.set

    -- global function to toggle venn drawing
    function _G.Toggle_venn()
      if not vim.b.venn_enabled then
        vim.b.venn_enabled = true
        vim.cmd [[setlocal virtualedit=all]]
        map("n", "J", "<C-v>j:VBox<CR>", { noremap = true, buffer = true })
        map("n", "K", "<C-v>k:VBox<CR>", { noremap = true, buffer = true })
        map("n", "L", "<C-v>l:VBox<CR>", { noremap = true, buffer = true })
        map("n", "H", "<C-v>h:VBox<CR>", { noremap = true, buffer = true })
        map("v", "f", ":VBox<CR>", { noremap = true, buffer = true })
        map("v", "d", ":VBoxDO<CR>", { noremap = true, buffer = true })
      else
        vim.cmd [[setlocal virtualedit=]]
        vim.api.nvim_buf_del_keymap(0, "n", "J")
        vim.api.nvim_buf_del_keymap(0, "n", "K")
        vim.api.nvim_buf_del_keymap(0, "n", "L")
        vim.api.nvim_buf_del_keymap(0, "n", "H")
        vim.api.nvim_buf_del_keymap(0, "v", "f")
        vim.api.nvim_buf_del_keymap(0, "v", "d")
        vim.b.venn_enabled = nil
      end
    end

    vim.api.nvim_create_user_command("VennStart", function()
      Toggle_venn()
    end, {})
  end,
}
