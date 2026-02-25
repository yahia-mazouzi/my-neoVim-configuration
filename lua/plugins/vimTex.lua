return {
  "lervag/vimtex",
  lazy = false, -- always load VimTeX
  init = function()
    -- Use Skim PDF viewer on macOS
    vim.g.vimtex_view_method = "skim"
    vim.g.vimtex_compiler_method = "generic"

    -- Optional but recommended settings:
    vim.g.vimtex_view_skim_sync = 1 -- Enable forward/inverse search
    vim.g.vimtex_view_skim_activate = 1 -- Auto-focus Skim when building

    -- Generic compiler using pdflatex directly (no latexmk needed)
    vim.g.vimtex_compiler_generic = {
      command = "pdflatex",
      options = {
        "-interaction=nonstopmode",
        "-synctex=1",
        "-file-line-error",
      },
    }
  end,
}
