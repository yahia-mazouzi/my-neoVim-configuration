require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "gdv", function()
  vim.cmd "vsplit"
  vim.lsp.buf.definition()
end, { desc = "Go to definition in vsp" })

map("n", "gds", function()
  vim.cmd "split"
  vim.lsp.buf.definition()
end, { desc = "Go to definition in vsp" })

vim.keymap.set("n", "gdt", function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, ctx, _)
    if not result or vim.tbl_isempty(result) then
      vim.notify("No definition found", vim.log.levels.WARN)
      return
    end

    vim.cmd "tabnew"

    if vim.tbl_islist(result) then
      vim.lsp.util.jump_to_location(result[1], "utf-8", true)
    else
      vim.lsp.util.jump_to_location(result, "utf-8", true)
    end
  end)
end, { desc = "Go to definition in new tab" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

local builtin = require "telescope.builtin"
local context_previewer = require("custom.telescope-preview").context_previewer

vim.keymap.set("n", "<leader>cf", function()
  builtin.find_files {
    previewer = context_previewer,
  }
end, { desc = "Find Files with Context Preview" })

-- Copilot manual trigger mappings
map("i", "<C-g>", function()
  require("copilot.suggestion").next()
end, { desc = "Next Copilot suggestion" })

map("i", "<C-f>", function()
  require("copilot.suggestion").prev()
end, { desc = "Previous Copilot suggestion" })

map("i", "<C-j>", function()
  require("copilot.suggestion").accept()
end, { desc = "Accept Copilot suggestion" })

map("n", "<leader>cp", function()
  require("copilot.panel").open { position = "bottom", ratio = 0.4 }
end, { desc = "Open Copilot panel" })

map("i", "<C-\\>", function()
  require("copilot.suggestion").toggle_auto_trigger()
end, { desc = "Toggle Copilot auto trigger" })

-- Manual trigger when no suggestion is available
map("i", "<C-Space>", function()
  require("copilot.suggestion").trigger()
end, { desc = "Manually trigger Copilot suggestion" })

-- Alternative manual trigger
map("i", "<Cmd-\\>", function()
  local copilot_suggestion = require "copilot.suggestion"
  if copilot_suggestion.is_visible() then
    copilot_suggestion.next()
  else
    copilot_suggestion.trigger()
  end
end, { desc = "Force Copilot suggestion or cycle" })

-- Listen for opencode events
vim.api.nvim_create_autocmd("User", {
  pattern = "OpencodeEvent",
  callback = function(args)
    -- See the available event types and their properties
    vim.notify(vim.inspect(args.data), vim.log.levels.DEBUG)
    -- Do something interesting, like show a notification when opencode finishes responding
    if args.data.type == "session.idle" then
      vim.notify("opencode finished responding", vim.log.levels.INFO)
    end
  end,
})

-- Open URL under cursor (gx) or with Ctrl+Click
local function open_url_under_cursor()
  local url = vim.fn.expand "<cfile>"
  if url:match "^https?://" then
    vim.ui.open(url)
  else
    -- Try to find a URL on the current line
    local line = vim.api.nvim_get_current_line()
    local found = line:match "https?://[%w_.~!*'();:@&=+$,/?#%[%]%%-]+"
    if found then
      vim.ui.open(found)
    else
      vim.notify("No URL found under cursor", vim.log.levels.WARN)
    end
  end
end

map("n", "gx", open_url_under_cursor, { desc = "Open URL under cursor" })
map("n", "<C-LeftMouse>", function()
  -- Move cursor to click position first, then open
  vim.cmd "normal! <LeftMouse>"
  open_url_under_cursor()
end, { desc = "Ctrl+Click to open URL" })

-- Mermaid mappings
map("n", "<leader>mo", "<cmd>MermaidPreview<cr>", { desc = "Mermaid preview in browser" })
map("n", "<leader>ms", "<cmd>MermaidSave<cr>", { desc = "Mermaid save as SVG" })

-- PlantUML mappings
map("n", "<leader>po", "<cmd>PlantumlOpen<cr>", { desc = "Open PlantUML diagram in browser" })
map("n", "<leader>ps", "<cmd>PlantumlSave<cr>", { desc = "Save PlantUML diagram" })
map("n", "<leader>pt", "<cmd>PlantumlStart<cr>", { desc = "Start PlantUML server" })
map("n", "<leader>pq", "<cmd>PlantumlStop<cr>", { desc = "Stop PlantUML server" })
