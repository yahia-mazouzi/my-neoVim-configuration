local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    typescript = { "prettier" },
    javascript = { "prettier" },
    go = { "gofumpt" },
    python = { "ruff_format" },
    c_cpp = { "clang-format" },
    cpp = { "clang_format" },
    c = { "clang_format" },
    java = { "google-java-format" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
