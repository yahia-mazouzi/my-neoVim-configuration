
local previewers = require("telescope.previewers")
local Path = require("plenary.path")
local ts_parsers = require("nvim-treesitter.parsers")
local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

local function get_ts_context(bufnr)
  local lang = ts_parsers.get_buf_lang(bufnr)
  if not lang or not ts_parsers.has_parser(lang) then
    return ""
  end

  local parser = ts_parsers.get_parser(bufnr, lang)
  if not parser then return "" end

  local tree = parser:parse()[1]
  if not tree then return "" end

  local root = tree:root()
  local cursor_node = ts_utils.get_node_at_cursor()
  local context = {}

  while cursor_node and cursor_node ~= root do
    local node_type = cursor_node:type()
    if node_type == "function" or node_type == "method_declaration" or node_type == "class" then
      local text = ts_utils.get_node_text(cursor_node, bufnr)
      if text and text[1] then
        table.insert(context, 1, text[1])
      end
    end
    cursor_node = cursor_node:parent()
  end

  return table.concat(context, " → ")
end

M.context_previewer = previewers.new_buffer_previewer({
  define_preview = function(self, entry)
    local filepath = entry.path or entry.filename or entry[1]
    local p = Path:new(filepath)
    local data = p:read()
    local lines = vim.split(data or "", "\n")

    -- Set filetype for Treesitter
    vim.bo[self.state.bufnr].filetype = vim.filetype.match({ filename = filepath })

    -- Fill the preview buffer
    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)

    -- Add context at the top
    local context_line = get_ts_context(self.state.bufnr)
    if context_line and context_line ~= "" then
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, 0, false, {
        "── Context ──",
        context_line,
        ""
      })
    end
  end,
})

return M

