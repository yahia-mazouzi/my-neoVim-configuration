return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {},
  config = function()
    require("noice").setup {
      cmdline = {
        view = "cmdline", -- or cmdline
        format = {
          cmdline = { icon = "" },
          search_down = { icon = " " },
          search_up = { icon = " " },
        },
      },
      messages = {
        view = "notify",
        view_error = "notify",
        view_warn = "notify",
        view_history = "messages",
      },
      popupmenu = {
        enabled = true,
        backend = "nui",
      },
      lsp = {
        progress = {
          enabled = true,
          format = "lsp_progress",
          format_done = "lsp_progress_done",
          throttle = 1000 / 30,
          view = "mini",
        },
        signature = {
          enabled = false,
          auto_open = {
            enabled = false,
            trigger = false,
            luasnip = false,
          },
        },
        hover = {
          enabled = false,
        },
        message = {
          enabled = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = false }, -- hide "written" messages
        },
      },
    }
    require("notify").setup {
      stages = "fade_in_slide_out",
      timeout = 2000,
      max_width = 40,
      max_height = 5,
      minimum_width = 20,
    }
  end,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
}
