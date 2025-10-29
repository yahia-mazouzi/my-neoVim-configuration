local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },

    htmldjango = { "djlint" },
    djangohtml = { "djlint" },
    txt = { "djlint" }, -- ✅ add this

    typescript = { "prettier" },
    javascript = { "prettier" },
    go = { "gofumpt" },
    python = { "ruff_format" },
    c_cpp = { "clang-format" },
    cpp = { "clang-format" },
    c = { "clang-format" },
    java = { "google-java-format" },
    sql = { "sqruff" },
  },

  format_on_save = function(_)
    return
  end,
}

-- Detect templates/*.txt as Django template
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "templates/**/*.txt", "**/templates/**/*.txt" },
  callback = function()
    vim.bo.filetype = "htmldjango"
  end,
})

return options
