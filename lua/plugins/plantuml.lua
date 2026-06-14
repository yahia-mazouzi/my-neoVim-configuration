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
    init = function()
      vim.g["plantuml_previewer#plantuml_jar_path"] = vim.fn.glob "/opt/homebrew/Cellar/plantuml/*/libexec/plantuml.jar"
    end,
  },
}
