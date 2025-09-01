return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  config = function()
    local neoscroll = require "neoscroll"

    -- Smooth key mappings
    local keymap = {
      ["<C-u>"] = function()
        neoscroll.ctrl_u { duration = 300, easing = "sine" }
      end,
      ["<C-d>"] = function()
        neoscroll.ctrl_d { duration = 350, easing = "sine" }
      end,
      ["<C-b>"] = function()
        neoscroll.ctrl_b { duration = 700, easing = "cubic" }
      end,
      ["<C-f>"] = function()
        neoscroll.ctrl_f { duration = 700, easing = "cubic" }
      end,
      ["<C-y>"] = function()
        neoscroll.scroll(-0.1, { move_cursor = false, duration = 220, easing = "quartic" })
      end,
      ["<C-e>"] = function()
        neoscroll.scroll(0.1, { move_cursor = false, duration = 220, easing = "quartic" })
      end,
    }

    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end

    -- Global smooth settings
    neoscroll.setup {
      mappings = {
        "<C-u>",
        "<C-d>",
        "<C-b>",
        "<C-f>",
        "<C-y>",
        "<C-e>",
        "zt",
        "zz",
        "zb",
      },
      hide_cursor = false, -- Keep cursor visible
      stop_eof = true, -- Stop at EOF
      respect_scrolloff = false, -- Ignore scrolloff
      cursor_scrolls_alone = true, -- Cursor keeps scrolling even if window cannot
      duration_multiplier = 1.2, -- Slower, smoother global timing
      easing = "sine", -- Default easing
      pre_hook = nil,
      post_hook = nil, -- Can add redraw if needed
      performance_mode = false, -- Keep highlights stable
      ignored_events = {
        "WinScrolled",
        "CursorMoved",
      },
    }
  end,
}
