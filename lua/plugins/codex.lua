return {
  "johnseth97/codex.nvim",
  lazy = true,
  cmd = { "Codex" },
  keys = {
    { "<leader>ax", "<cmd>Codex<cr>", desc = "Toggle Codex popup" },
    { "<leader>xk", "<cmd>Codex kill<cr>", desc = "Kill Codex session" },
  },
  opts = {
    keymaps = {},
    border = "rounded",
    width = 0.8,
    height = 0.8,
    autoinstall = true,
  },
}
