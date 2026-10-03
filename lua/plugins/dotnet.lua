-- C# / .NET desktop development (WPF, WinForms, Avalonia, MAUI)
--
-- Requires the .NET SDK on PATH plus these Mason packages:
--   :MasonInstall roslyn-language-server csharpier netcoredbg
return {
  -- Roslyn language server -- the same server behind VS Code's C# Dev Kit.
  -- Replaces omnisharp: solution-aware, far faster on large solutions.
  -- NOTE: roslyn.nvim calls vim.lsp.enable("roslyn") itself, so "roslyn" must
  -- NOT be added to lsp_names in configs/lspconfig.lua.
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    opts = {
      broad_search = true, -- search upward for a .sln instead of only cwd
      lock_target = true, -- pick the target solution once, don't re-prompt
    },
  },

  -- Productivity layer: solution explorer, build/run, NuGet, user-secrets, EF.
  -- Testing is intentionally left to neotest (see plugins/neotest.lua) so C#
  -- reuses the existing <leader>t* keymaps rather than adding a second runner.
  {
    "GustavEikaas/easy-dotnet.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
    ft = { "cs", "fsharp", "xml", "axaml" },
    cmd = "Dotnet",
    keys = {
      { "<leader>Nr", "<cmd>Dotnet run<cr>", desc = "Dotnet run project" },
      { "<leader>Nb", "<cmd>Dotnet build<cr>", desc = "Dotnet build project" },
      { "<leader>NB", "<cmd>Dotnet build solution<cr>", desc = "Dotnet build solution" },
      { "<leader>Nc", "<cmd>Dotnet clean<cr>", desc = "Dotnet clean" },
      { "<leader>NR", "<cmd>Dotnet restore<cr>", desc = "Dotnet restore" },
      { "<leader>Ns", "<cmd>Dotnet solution select<cr>", desc = "Dotnet select solution" },
      { "<leader>Nd", "<cmd>Dotnet debug<cr>", desc = "Dotnet debug project" },
      { "<leader>Nt", "<cmd>Dotnet testrunner<cr>", desc = "Dotnet test explorer" },
      { "<leader>Nx", "<cmd>Dotnet diagnostic errors<cr>", desc = "Dotnet solution errors" },
      { "<leader>Nn", "<cmd>Dotnet new<cr>", desc = "Dotnet new project/file" },
      { "<leader>Np", "<cmd>Dotnet add package<cr>", desc = "Dotnet add NuGet package" },
      { "<leader>NP", "<cmd>Dotnet remove package<cr>", desc = "Dotnet remove NuGet package" },
      { "<leader>Nk", "<cmd>Dotnet secrets<cr>", desc = "Dotnet user secrets" },
      { "<leader>Nw", "<cmd>Dotnet watch<cr>", desc = "Dotnet watch run" },
      { "<leader>No", "<cmd>Dotnet outdated<cr>", desc = "Dotnet outdated packages" },
      {
        "<leader>Nh",
        function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = 0 }, { bufnr = 0 })
        end,
        desc = "Toggle inlay hints",
      },
    },
    opts = {
      picker = "telescope",
      -- file-scoped namespaces match modern .NET style and save a nesting level
      auto_bootstrap_namespace = { type = "file_scoped", enabled = true },
    },
  },
}
