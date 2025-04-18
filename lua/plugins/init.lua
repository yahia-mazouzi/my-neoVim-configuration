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
          disable = function(lang, buf)
            local max_filesize = 150 * 1024 -- 150kb
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
            return false
          end,
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
          map("n", "<leader>gs", gitsigns.stage_hunk, { desc = "Stage Git hunk" })
          map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset Git hunk" })

          map("v", "<leader>gs", function()
            gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
          end, { desc = "Stage selected Git hunk" })

          map("v", "<leader>gr", function()
            gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
          end, { desc = "Reset selected Git hunk" })

          map("n", "<leader>gS", gitsigns.stage_buffer, { desc = "Stage entire Git buffer" })
          map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset entire Git buffer" })
          map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview Git hunk" })
          map("n", "<leader>gi", gitsigns.preview_hunk_inline, { desc = "Inline preview Git hunk" })

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
          map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Toggle Git line blame" })
          map("n", "<leader>gd", gitsigns.toggle_deleted, { desc = "Toggle Git deleted lines" })
          map("n", "<leader>gw", gitsigns.toggle_word_diff, { desc = "Toggle Git word diff" })

          -- Text object
          map({ "o", "x" }, "<leader>gih", gitsigns.select_hunk, { desc = "Select Git hunk" })
        end,
      }
    end,
  },
}
