return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-python",
    },
    ft = { "python", "django" },
    config = function()
      local neotest = require "neotest"

      neotest.setup {
        adapters = {
          require "neotest-python" {
            dap = { justMyCode = false },
            runner = "pytest",
            python = "/Users/med/.config/nvim/lua/scripts/run_python_docker.sh",
          },
        },
        icons = {
          running_animated = { "⠋", "⠙", "⠸", "⢰", "⣠", "⣄", "⡆", "⠇" },
          passed = "✅",
          failed = "❌",
          skipped = "⏭",
          unknown = "❓",
        },
      }

      local map = vim.keymap.set

      -- Run nearest test
      map("n", "<leader>tn", function()
        neotest.run.run()
      end, { desc = "Run nearest test" })

      -- Run single test under cursor
      map("n", "<leader>tt", function()
        neotest.run.run {}
      end, { desc = "Run single test under cursor" })

      -- Run all tests in current file
      map("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand "%")
      end, { desc = "Run tests in current file" })

      -- Run all tests in project
      map("n", "<leader>ts", function()
        neotest.run.run(vim.loop.cwd())
      end, { desc = "Run all tests in project" })

      -- Run last test
      map("n", "<leader>tl", function()
        neotest.run.run_last()
      end, { desc = "Run last test" })

      -- Debug test with DAP
      map("n", "<leader>td", function()
        neotest.run.run { strategy = "dap" }
      end, { desc = "Debug test" })

      -- Run nearest test live in terminal (streaming output)
      map("n", "<leader>tlive", function()
        neotest.run.run { strategy = "integrated" }
      end, { desc = "Run nearest test live" })

      -- Toggle test summary panel
      map("n", "<leader>to", function()
        neotest.summary.toggle()
      end, { desc = "Toggle test summary" })

      -- Show output of last test
      map("n", "<leader>tr", function()
        neotest.output.open { enter = true, auto_close = false }
      end, { desc = "Show test output" })

      -- Show summary to navigate failed tests
      map("n", "<leader>tfail", function()
        neotest.summary.toggle()
      end, { desc = "Show failed test output" })
    end,
  },
}
