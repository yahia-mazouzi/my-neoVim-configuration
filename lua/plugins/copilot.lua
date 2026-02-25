return {
  -- Copilot core
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        suggestion = { enabled = false }, -- disable inline ghost text
        panel = { enabled = false }, -- disable side panel
        filetypes = {
          ["*"] = true, -- enable for all filetypes
        },
        copilot_node_command = "node", -- ensure node is used
        server_opts_overrides = {
          advanced = {
            completions = {
              -- Fire Copilot suggestions more often
              triggerCharacters = {
                ".",
                ":",
                "(",
                "[",
                "{",
                ",",
                " ",
                "<",
                "=",
                '"',
                "'",
                "/",
              },
              debounceMs = 150, -- balanced refresh rate to prevent blinking
            },
          },
        },
      }
    end,
  },

  -- Copilot CMP integration
  {
    "zbirenbaum/copilot-cmp",
    lazy = false,
    dependencies = { "zbirenbaum/copilot.lua" },
    opts = {},
    config = function(_, opts)
      require("copilot_cmp").setup(opts)
    end,
    specs = {
      {
        "hrsh7th/nvim-cmp",
        optional = true,
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
          -- Put Copilot suggestions with LSP and others (same group to prevent blinking)
          table.insert(opts.sources, 1, {
            name = "copilot",
            group_index = 2,
            priority = 100,
            keyword_length = 1,
            max_item_count = 3,
          })

          -- Add performance settings to reduce blinking
          opts.performance = opts.performance or {}
          opts.performance.throttle = 80
          opts.performance.debounce = 60
          opts.performance.fetching_timeout = 200
        end,
      },
    },
  },
}
