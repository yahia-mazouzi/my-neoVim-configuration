return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  config = function()
    require("lspsaga").setup {
      ui = {
        border = "rounded",
        title = true,
      },
      symbol_in_winbar = {
        enable = true,
      },
      code_action = {
        show_server_name = true,
      },
      lightbulb = {
        enable = true,
        sign = true,
      },
      rename = {
        in_select = true,
        auto_save = true,
      },
    }
  end,
  dependencies = {
    "nvim-treesitter/nvim-treesitter", -- recommended
    "nvim-tree/nvim-web-devicons", -- optional but looks better
  },
}
