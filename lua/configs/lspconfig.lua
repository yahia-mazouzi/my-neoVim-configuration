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
  -- "pylyzer",
  -- "jedi_language_server",
  "sqlls",
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

-- Enable all configured language servers
local lsp_names = {}
for _, lsp in ipairs(servers) do
  table.insert(lsp_names, lsp)
end
table.insert(lsp_names, "ts_ls")
table.insert(lsp_names, "clangd")
table.insert(lsp_names, "basedpyright")
table.insert(lsp_names, "ruff")
table.insert(lsp_names, "emmet_language_server")

vim.lsp.enable(lsp_names)
