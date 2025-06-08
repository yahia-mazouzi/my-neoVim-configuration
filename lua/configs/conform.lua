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
    cpp = { "clang-format" },
    c = { "clang-format" },
    java = { "google-java-format" },
  },

  format_on_save = function(buffnr)
    return
  end,
}

return options
