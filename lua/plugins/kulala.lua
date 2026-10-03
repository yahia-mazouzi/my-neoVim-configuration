return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  config = function()
    require("kulala").setup {
      global_keymaps = false,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    }

    -- Keymaps. Upstream consolidated kulala.api/.scratchpad/.response into the
    -- top-level module; these are the current equivalents.
    local kulala = require "kulala"

    vim.keymap.set("n", "<leader>Rs", kulala.run, { desc = "Send request" })
    vim.keymap.set("n", "<leader>Ra", kulala.run_all, { desc = "Send all requests" })
    vim.keymap.set("n", "<leader>Rb", kulala.scratchpad, { desc = "Open scratchpad" })
    vim.keymap.set("n", "<leader>Rr", kulala.toggle_view, { desc = "Toggle response window" })
  end,
}
