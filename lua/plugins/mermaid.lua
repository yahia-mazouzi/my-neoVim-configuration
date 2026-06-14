return {
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npx --yes yarn install",
    init = function()
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_browserfunc = "OpenMarkdownPreview"
      vim.cmd([[
        function! OpenMarkdownPreview(url) abort
          call jobstart(['/usr/bin/open', '-a', 'Google Chrome', a:url])
        endfunction
      ]])
    end,
  },
}
