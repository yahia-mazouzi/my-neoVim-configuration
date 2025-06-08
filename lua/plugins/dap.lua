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

      map("n", "H", function()
        require("dap.ui.widgets").hover()
      end, { desc = "DAP Hover (variable info)" })

      vim.fn.sign_define("DapBreakpoint", {
        text = "B",
        texthl = "DapBreakpoint",
        linehl = "",
        numhl = "",
      })

      vim.api.nvim_set_hl(0, "DapBreakpoint", {
        fg = "#BE5046",
        bg = "",
      })

      vim.fn.sign_define("DapStopped", {
        text = "→",
        texthl = "DapStopped",
        linehl = "DapStoppedLine",
        numhl = "",
      })

      vim.api.nvim_set_hl(0, "DapStopped", {
        fg = "#5F865F",
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
      local dap_python = require "dap-python"
      dap_python.setup(path)

      vim.keymap.set("n", "<leader>dd", function()
        require("dap").run {
          type = "python",
          request = "launch",
          name = "Django runserver",
          program = vim.fn.getcwd() .. "/manage.py",
          args = { "runserver", "--noreload" },
          django = true,
        }
      end, { desc = "Launch Django runserver in DAP" })

      vim.keymap.set("n", "<leader>ddd", function()
        require("dap").run {
          type = "python",
          request = "attach",
          connect = {
            host = "127.0.0.1",
            port = 5678,
          },
          mode = "remote",
          name = "Attach to Docker Django",
          justMyCode = false,
          pathMappings = {
            {
              localRoot = vim.fn.getcwd() .. "/app",
              remoteRoot = "/usr/src/app",
            },
          },
        }
      end, { desc = "Attach Docker Django debug" })

      vim.keymap.set("n", "<leader>ddc", function()
        require("dap").run {
          type = "python",
          request = "attach",
          connect = {
            host = "127.0.0.1",
            port = 5678,
          },
          mode = "remote",
          name = "Attach to Celery Worker",
          justMyCode = false,
          pathMappings = {
            {
              localRoot = vim.fn.getcwd() .. "/app",
              remoteRoot = "/usr/src/app",
            },
          },
        }
      end, { desc = "Attach Celery Worker Debugger" })
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup {
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        commented = true, -- 👈 Adds virtual text as comments
      }
    end,
  },
}
