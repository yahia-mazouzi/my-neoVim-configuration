return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        signs = false,
      },
    },
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "lua",
          "json",
          "bash",
          "html",
          "css",
          "javascript",
          "typescript",
          "python",
          "markdown",
          "markdown_inline",
          "yaml",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true, -- Enable Treesitter-based indentation
        },
      }
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    opts = function(_, opts)
      require("gitsigns").setup {
        on_attach = function(bufnr)
          local gitsigns = require "gitsigns"

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          map("n", "<leader>fh", function()
            local hunks = require("gitsigns").get_hunks()
            local format = require("conform").format
            for i = #hunks, 1, -1 do
              local hunk = hunks[i]
              if hunk ~= nil and hunk.type ~= "delete" then
                local start = hunk.added.start
                local last = start + hunk.added.count
                -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
                local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
                local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
                format { range = range }
              end
            end
          end, { desc = "Format all added hunks in buffer" })

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              vim.cmd.normal { "]c", bang = true }
            else
              gitsigns.nav_hunk "next"
            end
          end, { desc = "Next Git hunk" })

          map("n", "[c", function()
            if vim.wo.diff then
              vim.cmd.normal { "[c", bang = true }
            else
              gitsigns.nav_hunk "prev"
            end
          end, { desc = "Previous Git hunk" })

          -- Actions
          map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Git Stage hunk" })
          map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Git Reset hunk" })

          map("v", "<leader>gs", function()
            gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
          end, { desc = "Stage selected Git hunk" })

          map("v", "<leader>gr", function()
            gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
          end, { desc = "Reset selected Git hunk" })

          map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Git Stage entire buffer" })
          map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Git Reset entire buffer" })
          map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Git Preview Git hunk" })
          map("n", "<leader>gi", gitsigns.preview_hunk_inline, { desc = "Git Inline preview hunk" })

          map("n", "<leader>gb", function()
            gitsigns.blame_line { full = true }
          end, { desc = "Git blame line (full)" })

          map("n", "<leader>gd", gitsigns.diffthis, { desc = "Git diff against index" })

          map("n", "<leader>gD", function()
            gitsigns.diffthis "~"
          end, { desc = "Git diff against last commit" })

          map("n", "<leader>gQ", function()
            gitsigns.setqflist "all"
          end, { desc = "Git: Set quickfix list (all hunks)" })

          map("n", "<leader>gq", gitsigns.setqflist, { desc = "Git: Set quickfix list (current hunks)" })

          -- Toggles
          map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Git Toggle line blame" })
          map("n", "<leader>gd", gitsigns.toggle_deleted, { desc = "Git Toggle deleted lines" })
          map("n", "<leader>gw", gitsigns.toggle_word_diff, { desc = "Git Toggle word diff" })

          -- Text object
          map({ "o", "x" }, "<leader>gih", gitsigns.select_hunk, { desc = "Git Select hunk" })
        end,
      }
    end,
  },
}
