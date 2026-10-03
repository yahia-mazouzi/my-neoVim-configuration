-- Seamless <C-h/j/k/l> between nvim splits and herdr panes: nvim moves its own
-- split first and only hands off to herdr at a split edge. The herdr half is the
-- local.vim-navigator plugin bound to bare ctrl+hjkl in ~/.config/herdr/config.toml.
--
-- Normal mode only, by the plugin's own design -- insert-mode <C-j> stays bound
-- to Copilot accept in lua/mappings.lua.
return {
  "bojackduy/nvim-herdr-navigation",

  -- The repo carries dev-only reference submodules (nvim-tmux-navigator, herdr);
  -- cloning them would pull the whole herdr source tree for nothing.
  submodules = false,

  -- Outside herdr this plugin is meaningless, and HERDR_PANE_ID is only exported
  -- into herdr pane shells, so it doubles as the "am I in herdr" probe.
  cond = function()
    return vim.env.HERDR_PANE_ID ~= nil
  end,

  event = "VeryLazy",

  -- The lua/ tree lives one level down inside the repo, not at its root.
  init = function(plugin)
    vim.opt.rtp:prepend(plugin.dir .. "/nvim-herdr-navigation")
  end,

  config = function()
    -- VeryLazy + schedule so these land AFTER NvChad has set its own default
    -- <C-h/j/k/l> window mappings, otherwise NvChad wins and nothing crosses
    -- the pane boundary.
    vim.schedule(function()
      require("herdr-navigation").setup({
        keybindings = {
          left = "<C-h>",
          down = "<C-j>",
          up = "<C-k>",
          right = "<C-l>",
        },
      })
    end)
  end,
}
