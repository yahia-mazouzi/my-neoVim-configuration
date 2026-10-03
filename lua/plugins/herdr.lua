return {
  "ChmaraX/herdr-nvim",
  cond = function()
    return vim.env.HERDR_ENV == "1"
  end,
  opts = {},
}
