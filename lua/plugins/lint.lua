return {
  "mfussenegger/nvim-lint",
  lazy = false,
  config = function()
    require("lint").linters_by_ft = {
      python = { "flake8" },
      lua = { "luacheck" },
    }

    vim.keymap.set("n", "<leader>li", function()
      local ok, err = pcall(function()
        vim.diagnostic.open_float(nil, { focusable = false, scope = "line" })
      end)

      if not ok then
        vim.notify("Linting failed: " .. err, vim.log.levels.ERROR)
      else
        vim.notify("Linting triggered", vim.log.levels.INFO)
      end
    end, { desc = "Trigger linting" })
    -- Automatically lint on save
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
