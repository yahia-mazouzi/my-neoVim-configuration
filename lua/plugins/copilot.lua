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
              debounceMs = 75, -- faster refresh (default ~300ms)
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
          -- Put Copilot suggestions *above* LSP and others
          table.insert(opts.sources, 1, {
            name = "copilot",
            group_index = 1,
            priority = 1000,
          })
        end,
      },
    },
  },
}
