# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal NVChad v2.5 configuration for Neovim 0.11+. NVChad provides the base framework (lazy-loaded plugins, theming, UI). This config extends it with LSP, DAP, testing, AI assistance, and various productivity plugins.

## Architecture

### Bootstrap Flow

`init.lua` → bootstraps lazy.nvim → loads NVChad v2.5 base → imports `lua/plugins/` → applies base46 theme cache → loads `lua/options.lua` → loads `lua/mappings.lua` (deferred via `vim.schedule`)

### Key Directories

- **lua/plugins/*.lua**: Plugin specs auto-discovered by lazy.nvim. Each file returns a table (or list of tables) of plugin specs.
- **lua/configs/**: Plugin configuration modules loaded by plugin specs (lspconfig.lua, conform.lua, lazy.lua)
- **lua/custom/**: Custom utilities (telescope-preview.lua for context previewer)
- **lua/chadrc.lua**: NVChad config — theme (kanagawa), UI settings, dashboard header, statusline

### Plugin Pattern

To add a new plugin: create `lua/plugins/<name>.lua` returning a lazy.nvim spec table. Lazy.nvim auto-discovers it.

## LSP Configuration

Configured in `lua/configs/lspconfig.lua` using **Neovim 0.11+ `vim.lsp.config` API** (not the old lspconfig setup pattern).

### How It Works

1. Servers in the `servers` table get a default config with navbuddy attachment via a loop
2. Servers needing custom config (ts_ls, clangd, basedpyright, ruff, mypy, emmet_language_server, sqlls) are configured individually with `vim.lsp.config[name] = { ... }`
3. All server names are collected into `lsp_names` and enabled with `vim.lsp.enable(lsp_names)`

### Adding a New LSP Server

- **Simple (default config)**: Add name to `servers` table AND to `lsp_names` collection
- **Custom config**: Add `vim.lsp.config["server_name"] = { ... }` block AND `table.insert(lsp_names, "server_name")`

### Enabled Servers

- **Web**: html, cssls, ts_ls, emmet_language_server, prismals
- **Python**: basedpyright (type checker, relaxed diagnostics, inlay hints), ruff (linting — hover+formatting disabled to avoid conflicts), mypy (diagnostics only — hover disabled)
- **Go**: gopls
- **C/C++**: clangd (formatting disabled, handled by conform)
- **Java**: jdtls
- **SQL**: sqlls (includes custom `<leader>se` to execute SQL statement under cursor via vim-dadbod)
- **Others**: jsonls, djlint, plantuml_lsp

### Python LSP Architecture

basedpyright handles types/hover/completions. ruff handles linting/code actions (hover+formatting disabled). mypy provides additional diagnostics (hover disabled). This avoids provider conflicts.

## Formatting (conform.nvim)

Config: `lua/configs/conform.lua`. **Format-on-save is disabled.** Format manually via `:Format` or `<leader>fm`.

Formatters: stylua (lua), ruff_format (python), prettier (css/html/ts/js), djlint (htmldjango/djangohtml/txt), gofumpt (go), clang-format (c/cpp), google-java-format (java), sqruff (sql).

Django templates in `templates/**/*.txt` are auto-detected as `htmldjango` filetype via autocmd.

## Testing (neotest)

Config: `lua/plugins/neotest.lua`. Python runner: pytest. DAP integration enabled (`justMyCode = false`).

**Note**: Python path points to a Docker wrapper script at `/Users/med/.config/nvim/lua/scripts/run_python_docker.sh` — this is machine-specific.

Key mappings: `<leader>tn` (nearest), `<leader>tt` (cursor), `<leader>tf` (file), `<leader>ts` (suite), `<leader>tl` (last), `<leader>td` (debug with DAP), `<leader>tlive` (live output), `<leader>to` (summary panel), `<leader>tr` (output).

## Debugging (DAP)

Config: `lua/plugins/dap.lua`. DAP UI auto-opens/closes with sessions.

### Python DAP

- `<leader>dd`: Launch local Django runserver (--noreload)
- `<leader>ddd`: Attach to Docker Django (port 5678, uses project-specific path mappings)
- `<leader>ddc`: Attach to Celery worker (port 5678)
- `<leader>dps`: Select project path mapping (rb, gsc, lpg) for Docker debugging

### JS/TS DAP

pwa-node adapter with ts-node. Launch file or attach to process.

### C/C++ DAP

codelldb adapter via Mason. Prompts for executable path.

### General DAP Keymaps

`<leader>db` (breakpoint), `<leader>dc` (continue), `J` (step over — only during active DAP session, otherwise normal J), `H` (hover/variable info).

## Notable Custom Keymaps

See `lua/mappings.lua` for full list. Highlights:

- `;` → `:` (command mode shortcut)
- `jk` → ESC (insert mode)
- `gdt`/`gdv`/`gds`: Go to definition in new tab / vsplit / split
- `<leader>cf`: Telescope find files with context previewer
- `<leader>se`: Execute SQL under cursor (buffer-local, SQL files only)
- `<leader>po/ps/pt/pq`: PlantUML open/save/start/stop

### Copilot (insert mode)

`<C-j>` accept, `<C-g>` next, `<C-f>` prev, `<C-Space>` trigger, `<C-\>` toggle auto-trigger, `<M-\>` force/cycle. `<leader>cp` opens panel (normal mode).

### Gitsigns

Inline blame enabled by default. `<leader>fh` formats all added hunks. Navigation: `]c`/`[c`. Stage/reset: `<leader>gs`/`<leader>gr` (hunk), `<leader>gS`/`<leader>gR` (buffer). Preview: `<leader>gp`/`<leader>gi`. Blame: `<leader>gb`. Diff: `<leader>gd`/`<leader>gD`. Quickfix: `<leader>gq`/`<leader>gQ`. Toggle word diff: `<leader>gw`. Hunk text object: `<leader>gih`.

## Custom Commands

- `:NewAgentsTerminal` — Opens a new tab with 4 Claude Code instances in a 2x2 grid (defined in `lua/options.lua`)

## Options

Defined in `lua/options.lua`: relative line numbers, manual folding (foldlevel 99 — all open by default), cursorline disabled.

## Spelling

`mistake.nvim` is loaded for typo correction. Custom dictionary entries in `mistake_custom_dict.lua` (root level). The `ignore` list in `lua/plugins/mistake.lua` prevents corrections for specific words (e.g., "rb").