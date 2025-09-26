-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "html",
  "cssls",
  "gopls",
  -- "eslint",
  "jdtls",
  "jsonls",
  "prismals",
  -- "pylyzer",
  -- "jedi_language_server",
  "basedpyright",
  "flake8",
}
local nvlsp = require "nvchad.configs.lspconfig"
local navbuddy = require "nvim-navbuddy"
-- lsps with default config

local on_attach_with_navbuddy = function(client, bufnr)
  navbuddy.attach(client, bufnr)
  nvlsp.on_attach(client, bufnr)
end

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
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
-- lspconfig.eslint.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

lspconfig.ts_ls.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  init_options = {
    preferences = {
      disableSuggestions = true,
    },
  },
}

lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    disable_formatting(client)
    nvlsp.on_attach(client, bufnr)
  end,
  capabilities = nvlsp.capabilities,
}

-- lspconfig.ruff.setup {
--   -- for more code actions , ruff is used by conform for hunk formatting
--   on_attach = function(client, bufnr)
--     disable_formatting(client)
--     nvlsp.on_attach(client, bufnr)
--   end,
--   capabilities = nvlsp.capabilities,
-- }

lspconfig.basedpyright.setup {
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
          reportAny = "none",
        },
        inlayHints = {
          callArgumentNames = true,
        },
      },
    },
  },
}

lspconfig.emmet_language_server.setup {
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
