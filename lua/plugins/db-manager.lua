return {
  -- Core DB engine
  {
    "tpope/vim-dadbod",
    lazy = true,
    cmd = { "DB", "DBUI", "DBUIToggle", "DBUIFindBuffer" },
  },

  -- Database UI (explorer, queries, results)
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIFindBuffer" },
    keys = {
      {
        "<leader>ca",
        function()
          vim.ui.select({
            "Execute query",
            "Execute all",
            "Save query",
            "Find buffer",
          }, { prompt = "DB Actions" }, function(choice)
            if not choice then
              return
            end
            if choice == "Execute query" then
              vim.cmd "normal! vas"
              -- briefly highlight the selection so the user sees what will run
              vim.cmd "redraw"
              vim.defer_fn(function()
                vim.api.nvim_feedkeys(
                  vim.api.nvim_replace_termcodes("<Plug>(DBUI_ExecuteQuery)", true, true, true),
                  "x",
                  false
                )
              end, 300)
            elseif choice == "Execute all" then
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<Plug>(DBUI_ExecuteQuery)", true, true, true),
                "n",
                false
              )
            elseif choice == "Save query" then
              vim.cmd "DBUISaveQuery"
            elseif choice == "Find buffer" then
              vim.cmd "DBUIFindBuffer"
            end
          end)
        end,
        ft = { "sql", "mysql", "plsql" },
        desc = "DB Actions",
      },
    },
    init = function()
      -- Where to keep DB UI config
      vim.g.db_ui_save_location = vim.fn.stdpath "data" .. "/db_ui"

      -- Auto-execute last query on buffer reopen
      vim.g.db_ui_execute_on_save = 0

      -- Use Nerd Font icons if you have them
      vim.g.db_ui_use_nerd_fonts = 1

      -- Highlighting and auto layout
      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 35
    end,
  },

  -- Completion for SQL buffers
  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    config = function()
      -- Hook into nvim-cmp
      local cmp = require "cmp"
      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = cmp.config.sources({
          { name = "vim-dadbod-completion" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
