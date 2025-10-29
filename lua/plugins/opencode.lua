return {
  "NickvanDyke/opencode.nvim",
  lazy = false,
  dependencies = {
    -- ✅ Needed for provider.toggle and better input UI
    {
      "folke/snacks.nvim",
      lazy = false,
      opts = {
        input = {
          enabled = true,
        },
        terminal = {
          enabled = true, -- ✅ provides provider.toggle()
        },
      },
    },
  },

  config = function()
    vim.g.opencode_opts = {
      -- You can add settings here later if you want
    }

    -- ✅ Required for auto_reload & watching edited files
    vim.o.autoread = true
  end,

  keys = {
    -- ✅ Ask general question
    {
      "<leader>oA",
      function()
        require("opencode").ask()
      end,
      desc = "Ask opencode",
    },

    -- ✅ Ask about cursor text
    {
      "<leader>oa",
      function()
        require("opencode").ask "@cursor: "
      end,
      desc = "Ask opencode about this",
      mode = "n",
    },

    -- ✅ Ask about visually selected text
    {
      "<leader>oa",
      function()
        require("opencode").ask "@selection: "
      end,
      desc = "Ask opencode about selection",
      mode = "v",
    },

    -- ✅ Toggle embedded model panel
    {
      "<leader>ot",
      function()
        require("opencode").toggle()
      end,
      desc = "Toggle embedded opencode",
    },

    -- ✅ Start new session
    {
      "<leader>on",
      function()
        require("opencode").command "session_new"
      end,
      desc = "New opencode session",
    },

    -- ✅ Copy last response to clipboard
    {
      "<leader>oy",
      function()
        require("opencode").command "messages_copy"
      end,
      desc = "Copy last message",
    },

    -- ✅ Scroll response panel
    {
      "<S-C-u>",
      function()
        require("opencode").command "messages_half_page_up"
      end,
      desc = "Scroll messages up",
    },
    {
      "<S-C-d>",
      function()
        require("opencode").command "messages_half_page_down"
      end,
      desc = "Scroll messages down",
    },

    -- ✅ Pick prompt template (coding, refactor, debug, explain, etc.)
    {
      "<leader>op",
      function()
        require("opencode").select_prompt()
      end,
      desc = "Select prompt",
      mode = { "n", "v" },
    },

    -- ✅ Example custom prompt
    {
      "<leader>oe",
      function()
        require("opencode").prompt "Explain @cursor and its context"
      end,
      desc = "Explain code near cursor",
    },
  },
}
