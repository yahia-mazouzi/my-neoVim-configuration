return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "SmiteshP/nvim-navbuddy",
      dependencies = {
        "SmiteshP/nvim-navic",
        "MunifTanjim/nui.nvim",
      },
      config = function()
        local navbuddy = require "nvim-navbuddy"
        navbuddy.setup {
          window = {
            border = "single",
            size = { height = "50%", width = "80%" },
          },
          icons = {
            File = "󰈙 ",
            Module = " ",
            Namespace = "󰌗 ",
            Package = " ",
            Class = "󰌗 ",
            Method = "𝓜  ",
            Property = " ",
            Field = " ",
            Constructor = " ",
            Enum = "󰕘",
            Interface = "󰕘",
            Function = "󰊕 ",
            Variable = "󰆧 ",
            Constant = "󰏿 ",
            String = " ",
            Number = "󰎠 ",
            Boolean = "◩ ",
            Array = "󰅪 ",
            Object = "󰅩 ",
            Key = "󰌋 ",
            Null = "󰟢 ",
            EnumMember = " ",
            Struct = "󰌗 ",
            Event = " ",
            Operator = "󰆕 ",
            TypeParameter = "󰊄 ",
          },

          lsp = { auto_attach = true },
        }
      end,
    },
  },
}
