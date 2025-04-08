return {
  {
    "mfussenegger/nvim-dap",
    config = function(_, _)
      local map = vim.keymap.set
      map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>")
      map("n", "<leader>dc", "<cmd> DapContinue <CR>")
      map("n", "<leader>dj", "<cmd> DapStepOver <CR>")
      map("n", "<leader>dk", "<cmd> DapStepOut <CR>")
      map("n", "<leader>dus", function()
        local widgets = require "dap.ui.widgets"
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end)
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
      ensure_installed = {
        "codelldb",
      },
    },
  },

  -- go debuger
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "leoluz/nvim-dap-go",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"

      require("dap-go").setup()
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
