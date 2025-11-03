return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  config = function()
    require("kulala").setup {
      global_keymaps = false,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    }

    -- Keymaps
    local api = require "kulala.api"
    local scratch = require "kulala.scratchpad"
    local resp = require "kulala.response"

    vim.keymap.set("n", "<leader>Rs", api.send_request, { desc = "Send request" })
    vim.keymap.set("n", "<leader>Ra", api.send_all, { desc = "Send all requests" })
    vim.keymap.set("n", "<leader>Rb", scratch.open, { desc = "Open scratchpad" })
    vim.keymap.set("n", "<leader>Rr", resp.toggle, { desc = "Toggle response window" })
  end,
}
