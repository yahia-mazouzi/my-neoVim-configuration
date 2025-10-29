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

      -- Define project mapping configurations
      local project_mappings = {
        default = {
          {
            localRoot = "/Users/med/Documents/Work/RB/domainprospector/app",
            remoteRoot = "/linklabs",
          },
        },
        gsc = {
          {
            localRoot = vim.fn.getcwd() .. "/app",
            remoteRoot = "/usr/src/app",
          },
        },
        lpg = {
          {
            localRoot = "/Users/med/Documents/Work/LPG/landing-page-studio",
            remoteRoot = "/usr/src/app",
          },
        },
        -- Add more project configurations as needed:
        -- project_name = {
        --   { localRoot = "...", remoteRoot = "..." },
        -- },
      }

      -- Function to select project configuration
      local function select_project_mappings()
        local projects = {}
        for name, _ in pairs(project_mappings) do
          table.insert(projects, name)
        end
        table.sort(projects)

        vim.ui.select(projects, {
          prompt = "Select project configuration:",
          format_item = function(item)
            return item
          end,
        }, function(choice)
          if choice then
            vim.g.dap_selected_project = choice
          end
        end)
      end

      -- Map a key to select project
      vim.keymap.set("n", "<leader>dps", select_project_mappings, { desc = "Select DAP project mapping" })

      vim.keymap.set("n", "<leader>ddd", function()
        -- Get selected project or use default
        local selected_project = vim.g.dap_selected_project or "default"
        local mappings = project_mappings[selected_project]

        require("dap").run {
          type = "python",
          request = "attach",
          connect = {
            host = "127.0.0.1",
            port = 5678,
          },
          mode = "remote",
          name = "Attach to Docker Django (" .. selected_project .. ")",
          justMyCode = false,
          pathMappings = mappings,
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
        commented = true,
      }
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
    dependencies = {
      "mfussenegger/nvim-dap",

      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local dap = require "dap"
      local dap_vscode_js = require "dap-vscode-js"

      dap_vscode_js.setup {
        debugger_path = vim.fn.stdpath "data" .. "/mason/packages/js-debug-adapter",
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
      }

      dap.adapters["pwa-node"] = {
        type = "server",
        host = "127.0.0.1",
        port = 8123,
        executable = {
          command = "js-debug-adapter",
        },
      }

      for _, language in ipairs { "javascript", "typescriptreact", "javascriptreact" } do
        dap.configurations[language] = {

          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (TS/JS)",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            runtimeExecutable = "ts-node",
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = vim.fn.getcwd(),
          },
        }
      end

      dap.configurations.typescript = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch TS file",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          runtimeExecutable = "ts-node",
          sourceMaps = true,
          protocol = "inspector",
          skipFiles = { "<node_internals>/**" },
          waitForDebugger = true, -- 💡 This makes Node pause until DAP is read
          runtimeArgs = { "--esm", "--inspect-brk" },
        },
      }
    end,
  },
  {
    "julianolf/nvim-dap-lldb",
    ft = { "c", "cpp" },
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
  local dap = require "dap"

  dap.adapters.codelldb = {
    type = "executable",
    command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
    name = "codelldb",
  }

  dap.configurations.c = {
    {
      name = "Launch",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},
    },
  }

  dap.configurations.cpp = dap.configurations.c
    end,
  },
}
