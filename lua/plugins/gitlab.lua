return {
  "harrisoncramer/gitlab.nvim",
  event = "VeryLazy",
  config = function()
    require("gitlab").setup {
      -- Your GitLab instance URL (leave nil for gitlab.com)
      -- gitlab_url = "https://gitlab.yourcompany.com",
    }
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "stevearc/dressing.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  build = function()
    require("gitlab.server").build(true)
  end,
}
