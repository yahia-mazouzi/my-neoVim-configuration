-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- Protected require to handle potential errors
local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  vim.notify("Failed to load lspconfig: " .. tostring(lspconfig), vim.log.levels.ERROR)
  return
end

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
  local server_available, server_config = pcall(function()
    return lspconfig[lsp]
  end)
  if server_available and server_config then
    server_config.setup {
      on_attach = on_attach_with_navbuddy,
      on_init = nvlsp.on_init,
      capabilities = nvlsp.capabilities,
    }
  end
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

local ts_ls_available = pcall(function()
  return lspconfig.ts_ls
end)
if ts_ls_available then
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
end

local clangd_available = pcall(function()
  return lspconfig.clangd
end)
if clangd_available then
  lspconfig.clangd.setup {
    on_attach = function(client, bufnr)
      disable_formatting(client)
      nvlsp.on_attach(client, bufnr)
    end,
    capabilities = nvlsp.capabilities,
  }
end

-- lspconfig.ruff.setup {
--   -- for more code actions , ruff is used by conform for hunk formatting
--   on_attach = function(client, bufnr)
--     disable_formatting(client)
--     nvlsp.on_attach(client, bufnr)
--   end,
--   capabilities = nvlsp.capabilities,
-- }

local basedpyright_available = pcall(function()
  return lspconfig.basedpyright
end)
if basedpyright_available then
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
end

local emmet_available = pcall(function()
  return lspconfig.emmet_language_server
end)
if emmet_available then
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
end

