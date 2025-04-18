return {
  {
    "mfussenegger/nvim-dap",
    config = function(_, _)
      local map = vim.keymap.set
      map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>")
      map("n", "<leader>dc", "<cmd> DapContinue <CR>")
      map("n", "J", function()
        local dap = require "dap"
        if dap.session() then
          dap.step_over()
        else
          vim.cmd "normal! J"
        end
      end, { desc = "Step Over (Only if DAP session active)" })

      vim.fn.sign_define("DapBreakpoint", {
        text = "B", -- Simple filled circle
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "",
      })

      vim.api.nvim_set_hl(0, "DapBreakpoint", {
        fg = "#BE5046", -- Bright red
        bg = "",
      })
      vim.fn.sign_define("DapStopped", {
        text = "→",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
        numhl = "",
      })
      vim.api.nvim_set_hl(0, "DapStopped", {
        fg = "#5F865F", -- Same red
        bg = "",
      })
      vim.api.nvim_set_hl(0, "DapStoppedLine", {
        bg = "#3E4452",
      })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
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
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
  },
}
