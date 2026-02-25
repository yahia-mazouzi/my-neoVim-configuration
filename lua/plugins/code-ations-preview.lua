return {
  "aznhe21/actions-preview.nvim",
  lazy = false,
  config = function()
    -- Custom Claude actions injected into the code actions picker
    local claude_actions = {
      {
        label = "Create Ticket",
        command = "/create-ticket",
      },
    }

    -- Build an Action-compatible object for custom Claude actions
    local function make_claude_action(entry)
      return {
        title = function()
          return entry.label .. " [Claude]"
        end,
        client_name = function()
          return "claude"
        end,
        preview = function(_, callback)
          callback {
            syntax = "",
            lines = { entry.label .. " — sends selection to Claude Code with /" .. entry.command:sub(2) },
          }
        end,
        apply = function()
          local line1 = vim.fn.line "'<"
          local line2 = vim.fn.line "'>"
          require("claudecode.selection").send_at_mention_for_visual_selection(line1, line2)
          vim.defer_fn(function()
            vim.cmd "ClaudeCodeFocus"
            vim.defer_fn(function()
              local buf = vim.api.nvim_get_current_buf()
              if vim.bo[buf].buftype == "terminal" then
                local chan = vim.bo[buf].channel
                if chan and chan > 0 then
                  vim.fn.chansend(chan, entry.command .. "\n")
                  return
                end
              end
              vim.notify("Type " .. entry.command .. " in Claude", vim.log.levels.WARN)
            end, 200)
          end, 300)
        end,
      }
    end

    -- Monkey-patch backend.select to inject Claude actions
    local backend = require "actions-preview.backend"
    local original_select = backend.select

    backend.select = function(config, actions)
      for _, entry in ipairs(claude_actions) do
        table.insert(actions, make_claude_action(entry))
      end
      original_select(config, actions)
    end

    vim.keymap.set({ "v", "n" }, "<leader>ca", require("actions-preview").code_actions)
  end,
}
