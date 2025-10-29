return {
  "lervag/vimtex",
  lazy = false, -- always load VimTeX
  init = function()
    -- Use Skim PDF viewer on macOS
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_compiler_method = "latexmk"

    -- Optional but recommended settings:
    vim.g.vimtex_view_skim_sync = 1 -- Enable forward/inverse search
    vim.g.vimtex_view_skim_activate = 1 -- Auto-focus Skim when building
    vim.g.vimtex_compiler_latexmk = {
      options = {
        "-pdf",
        "-interaction=nonstopmode",
        "-synctex=1",
      },
    }
  end,
}
