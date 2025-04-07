return {
  "derektata/lorem.nvim",
  lazy = true,
  cmd = { "Lorem" },
  config = function()
    require("lorem").setup {
      sentenceLength = "medium",
      comma_chance = 0.2,
      max_commas_per_sentence = 2,
    }
  end,
}
