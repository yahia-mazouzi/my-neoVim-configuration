return {
  {
    "weirongxu/plantuml-previewer.vim",
    ft = { "plantuml", "pu", "puml" },
    lazy = true,
    cmd = { "PlantumlOpen", "PlantumlSave", "PlantumlStart", "PlantumlStop" },
    dependencies = {
      "tyru/open-browser.vim",
      "aklt/plantuml-syntax",
    },
  },
}
