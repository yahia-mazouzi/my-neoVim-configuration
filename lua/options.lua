require "nvchad.options"

-- add yours here!

local o = vim.o

-- Register .mmd files as mermaid filetype
vim.filetype.add {
  extension = {
    mmd = "mermaid",
  },
}

-- Minimal and productive settings
o.cursorline = false -- Disable cursorline for less distraction
o.relativenumber = true -- Use absolute numbers only

-- Folding settings (ensures zf and other fold commands work)
o.foldmethod = "manual" -- Manual folding (use zf to create folds)
o.foldlevel = 99 -- Keep all folds open by default
o.foldlevelstart = 99 -- Start with all folds open

-- Open a new tab with 4 Claude Code instances in a 2x2 grid, focused on top-left
vim.api.nvim_create_user_command("NewClaudeSlaves", function()
  vim.cmd "tabnew"
  vim.cmd "terminal claude --dangerously-skip-permissions"
  vim.cmd "rightbelow vsplit | terminal claude --dangerously-skip-permissions"
  vim.cmd "wincmd t"
  vim.cmd "rightbelow split | terminal claude --dangerously-skip-permissions"
  vim.cmd "wincmd t"
  vim.cmd "wincmd l"
  vim.cmd "rightbelow split | terminal claude --dangerously-skip-permissions"
  vim.cmd "wincmd t"
end, { desc = "Open new tab with 4 Claude Code instances in a 2x2 grid" })

vim.api.nvim_create_user_command("NewGeminiSlaves", function()
  vim.cmd "tabnew"
  vim.cmd "terminal gemini"
  vim.cmd "rightbelow vsplit | terminal gemini"
  vim.cmd "wincmd t"
  vim.cmd "rightbelow split | terminal gemini"
  vim.cmd "wincmd t"
  vim.cmd "wincmd l"
  vim.cmd "rightbelow split | terminal gemini"
  vim.cmd "wincmd t"
end, { desc = "Open new tab with 4 Gemini instances in a 2x2 grid" })

-- Code above, terminal below — instant coding layout
vim.api.nvim_create_user_command("DevLayout", function()
  vim.cmd "botright split | resize 15 | terminal"
  vim.cmd "wincmd k"
end, { desc = "Code above, terminal below" })

-- Open all git-changed files in separate tabs for review
vim.api.nvim_create_user_command("ReviewLayout", function()
  local files = vim.fn.systemlist "git diff --name-only HEAD"
  if #files == 0 then
    vim.notify("No changed files", vim.log.levels.INFO)
    return
  end
  for i, f in ipairs(files) do
    if i == 1 then
      vim.cmd("edit " .. vim.fn.fnameescape(f))
    else
      vim.cmd("tabnew " .. vim.fn.fnameescape(f))
    end
  end
  vim.cmd "tabfirst"
  vim.notify(#files .. " changed files opened in tabs", vim.log.levels.INFO)
end, { desc = "Open all git-changed files in tabs" })

-- Mermaid diagram commands (uses mmdc CLI)
local function find_mmdc()
  local path = vim.fn.exepath "mmdc"
  if path ~= "" then
    return path
  end
  local nvm_mmdc = vim.fn.glob(vim.fn.expand "~/.nvm/versions/node/*/bin/mmdc")
  if nvm_mmdc ~= "" then
    return vim.split(nvm_mmdc, "\n")[1]
  end
  return nil
end

vim.api.nvim_create_user_command("MermaidPreview", function()
  local mmdc = find_mmdc()
  if not mmdc then
    vim.notify("mmdc not found. Install: npm i -g @mermaid-js/mermaid-cli", vim.log.levels.ERROR)
    return
  end
  local file = vim.fn.expand "%:p"
  local output = vim.fn.tempname() .. ".svg"
  vim.fn.jobstart({ mmdc, "-i", file, "-o", output }, {
    on_exit = function(_, code)
      if code == 0 then
        vim.schedule(function()
          vim.fn.jobstart({ "/usr/bin/open", "-a", "Google Chrome", output })
        end)
      else
        vim.schedule(function()
          vim.notify("mmdc failed (exit " .. code .. ")", vim.log.levels.ERROR)
        end)
      end
    end,
  })
end, { desc = "Render mermaid diagram to SVG and open in browser" })

vim.api.nvim_create_user_command("MermaidSave", function()
  local mmdc = find_mmdc()
  if not mmdc then
    vim.notify("mmdc not found. Install: npm i -g @mermaid-js/mermaid-cli", vim.log.levels.ERROR)
    return
  end
  local file = vim.fn.expand "%:p"
  local output = vim.fn.expand "%:p:r" .. ".svg"
  vim.fn.jobstart({ mmdc, "-i", file, "-o", output }, {
    on_exit = function(_, code)
      vim.schedule(function()
        if code == 0 then
          vim.notify("Saved: " .. output, vim.log.levels.INFO)
        else
          vim.notify("mmdc failed (exit " .. code .. ")", vim.log.levels.ERROR)
        end
      end)
    end,
  })
end, { desc = "Render mermaid diagram to SVG alongside source file" })

-- Distraction-free editing — close all splits, hide UI chrome
vim.api.nvim_create_user_command("FocusMode", function()
  vim.cmd "only"
  vim.opt_local.number = false
  vim.opt_local.relativenumber = false
  vim.opt_local.signcolumn = "no"
  vim.notify("Focus mode ON — use :FocusOff to restore", vim.log.levels.INFO)
end, { desc = "Distraction-free editing" })

-- Restore normal editing UI
vim.api.nvim_create_user_command("FocusOff", function()
  vim.opt_local.number = true
  vim.opt_local.relativenumber = true
  vim.opt_local.signcolumn = "auto"
  vim.notify("Focus mode OFF", vim.log.levels.INFO)
end, { desc = "Exit focus mode" })
