-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- EXAMPLE
local servers = {
  "html",
  "cssls",
  "gopls",
  -- "eslint",
  "jdtls",
  "jsonls",
  "prismals",
  "djlint",
  "plantuml_lsp",
  -- "pylyzer",
  -- "jedi_language_server",
  -- "basedpyright",
}
local nvlsp = require "nvchad.configs.lspconfig"

-- Protected require for navbuddy
local navbuddy_ok, navbuddy = pcall(require, "nvim-navbuddy")
if not navbuddy_ok then
  vim.notify("Failed to load nvim-navbuddy", vim.log.levels.WARN)
  navbuddy = nil
end

-- lsps with default config

local on_attach_with_navbuddy = function(client, bufnr)
  if navbuddy then
    navbuddy.attach(client, bufnr)
  end
  nvlsp.on_attach(client, bufnr)
end

for _, lsp in ipairs(servers) do
  vim.lsp.config[lsp] = {
    on_attach = on_attach_with_navbuddy,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

local disable_formatting = function(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end
--
-- vim.lsp.config("eslint", {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- })

vim.lsp.config["ts_ls"] = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  init_options = {
    preferences = {
      disableSuggestions = true,
    },
  },
}

vim.lsp.config["clangd"] = {
  on_attach = function(client, bufnr)
    disable_formatting(client)
    nvlsp.on_attach(client, bufnr)
  end,
  capabilities = nvlsp.capabilities,
}

-- vim.lsp.config("ruff", {
--   -- for more code actions , ruff is used by conform for hunk formatting
--   on_attach = function(client, bufnr)
--     disable_formatting(client)
--     nvlsp.on_attach(client, bufnr)
--   end,
--   capabilities = nvlsp.capabilities,
-- })

vim.lsp.config["basedpyright"] = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = false,
        disableOrganizeImports = true,
        diagnosticMode = "openFilesOnly",
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportUnknownVariableType = "none",
          reportUnannotatedClassAttribute = "none",
          reportIncompatibleVariableOverride = "none",
          reportMissingTypeArgument = "none",
          reportArgumentType = "none",
          reportUnknownParameterType = "none",
          reportUntypedFunctionDecorator = "none",
          reportFunctionMemberAccess = "none",
          reportUnknownMemberType = "none",
          reportUninitializedInstanceVariable = "none",
          reportUnknownArgumentType = "none",
          reportAttributeAccessIssue = "none",
          reportImplicitRelativeImport = "none",
          reportUnusedCallResult = "none",
          reportExplicitAny = "none",
          reportOperatorIssue = "none",
          reportAny = "none",
        },
        inlayHints = {
          callArgumentNames = true,
        },
      },
    },
  },
}

vim.lsp.config["ruff"] = {

  on_attach = function(client, bufnr)
    disable_formatting(client)
    -- avoid hover conflict with basedpyright
    client.server_capabilities.hoverProvider = false
    nvlsp.on_attach(client, bufnr)
  end,
  init_options = {
    settings = {
      -- Ruff language server settings go here
    },
  },
}

vim.lsp.config["mypy"] = {
  on_attach = function(client, bufnr)
    -- Disable hover to avoid conflicts with basedpyright
    client.server_capabilities.hoverProvider = false
    nvlsp.on_attach(client, bufnr)
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

vim.lsp.config["emmet_language_server"] = {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = {
    "css",
    "eruby",
    "html",
    "javascript",
    "javascriptreact",
    "less",
    "sass",
    "scss",
    "pug",
    "typescriptreact",
  },
  -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
  -- **Note:** only the options listed in the table are supported.
  init_options = {
    ---@type table<string, string>
    includeLanguages = {},
    --- @type string[]
    excludeLanguages = {},
    --- @type string[]
    extensionsPath = {},
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
    preferences = {},
    --- @type boolean Defaults to `true`
    showAbbreviationSuggestions = true,
    --- @type "always" | "never" Defaults to `"always"`
    showExpandedAbbreviation = "always",
    --- @type boolean Defaults to `false`
    showSuggestionsAsSnippets = false,
    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
    syntaxProfiles = {},
    --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
    variables = {},
  },
}

-- SQL LSP with code actions for query execution
-- Helper function to extract current SQL statement
local function get_current_sql_statement()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local current_line = cursor_pos[1]
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Find start of statement (search backwards for semicolon or empty line)
  local start_line = current_line
  for i = current_line - 1, 1, -1 do
    local line = lines[i]
    if line:match "^%s*$" or line:match ";%s*$" then
      start_line = i + 1
      break
    end
    if i == 1 then
      start_line = 1
    end
  end

  -- Find end of statement (search forwards for semicolon or empty line)
  local end_line = current_line
  for i = current_line, #lines do
    local line = lines[i]
    if line:match ";%s*$" then
      end_line = i
      break
    end
    if i > current_line and line:match "^%s*$" then
      end_line = i - 1
      break
    end
    if i == #lines then
      end_line = #lines
    end
  end

  -- Extract the SQL statement
  local sql_lines = {}
  for i = start_line, end_line do
    table.insert(sql_lines, lines[i])
  end

  local sql = table.concat(sql_lines, "\n")
  -- Remove trailing semicolon and whitespace
  sql = sql:gsub(";%s*$", "")

  return sql, start_line, end_line
end

-- Execute SQL using vim-dadbod
local function execute_current_sql()
  local sql, start_line, end_line = get_current_sql_statement()

  if sql == "" or sql:match "^%s*$" then
    vim.notify("No SQL statement found", vim.log.levels.WARN)
    return
  end

  -- Check if dadbod is available
  if vim.fn.exists "*db#execute" == 0 then
    vim.notify("vim-dadbod not found. Please install vim-dadbod and vim-dadbod-ui", vim.log.levels.ERROR)
    return
  end

  -- Get the current database from dbui
  local db = vim.g.db or vim.b.db
  if not db or db == "" then
    vim.notify(
      "No database selected. Please select a database in DBUI first (press 'S' on a database)",
      vim.log.levels.WARN
    )
    return
  end

  vim.notify("Executing SQL (lines " .. start_line .. "-" .. end_line .. ")...", vim.log.levels.INFO)

  -- Execute the query
  local ok, result = pcall(vim.fn["db#execute"], db, sql)

  if not ok then
    vim.notify("Error executing SQL: " .. tostring(result), vim.log.levels.ERROR)
    return
  end

  -- Display results in a new split
  vim.cmd "new"
  local result_buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_option(result_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(result_buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_name(result_buf, "SQL Results")

  -- Split result into lines and set
  local result_lines = vim.split(result, "\n", { plain = true })
  vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, result_lines)
  vim.api.nvim_buf_set_option(result_buf, "modifiable", false)

  vim.notify("Query executed successfully (" .. #result_lines .. " lines)", vim.log.levels.INFO)
end

vim.lsp.config["postgres_lsp"] = {
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)

    -- Add keymap to execute current SQL statement
    vim.keymap.set("n", "<leader>se", execute_current_sql, {
      buffer = bufnr,
      desc = "Execute current SQL statement",
    })
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

-- Enable all configured language servers
local lsp_names = {}
for _, lsp in ipairs(servers) do
  table.insert(lsp_names, lsp)
end
table.insert(lsp_names, "ts_ls")
table.insert(lsp_names, "clangd")
table.insert(lsp_names, "basedpyright")
table.insert(lsp_names, "ruff")
table.insert(lsp_names, "mypy") -- Note: mypy provides diagnostics, not code actions
table.insert(lsp_names, "emmet_language_server")
table.insert(lsp_names, "postgres_lsp")

vim.lsp.enable(lsp_names)
