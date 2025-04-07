return {
  {
    "weirongxu/plantuml-previewer.vim",
    ft = { "plantuml", "pu", "puml" }, -- adjust based on your filetypes
    lazy = true,
    event = "VeryLazy", -- fallback lazy loading
    dependencies = {
      "tyru/open-browser.vim",
      "aklt/plantuml-syntax",
    },
  },
}
