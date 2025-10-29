return {
  "renerocksai/telekasten.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  event = "VeryLazy",
  config = function()
    local home = vim.fn.expand "~/Personal/Todos/"
    require("telekasten").setup {
      home = home,
      dailies = home .. "/" .. "daily",
      weeklies = home .. "/" .. "weekly",
      templates = home .. "/" .. "templates",
      extension = ".md",
      take_over_my_home = false,
      auto_set_filetype = true,
      follow_creates_nonexisting = true,
      dailies_create_nonexisting = true,
      weeklies_create_nonexisting = true,
      journal_auto_open = false,
      template_new_note = home .. "/" .. "templates/new_note.md",
      template_new_daily = home .. "/" .. "templates/daily.md",
      template_new_weekly = home .. "/" .. "templates/weekly.md",
      image_subdir = "img",
      plug_into_calendar = true,
      tag_notation = "#tag",
      command_palette_theme = "dropdown",
      show_tags_theme = "dropdown",
      subdirs_in_links = true,
      template_handling = "smart",
      new_note_location = "smart",
      rename_update_links = true,
      follow_url_fallback = nil,
    }
  end,
}
