# NVChad Custom Config

My personal NVChad setup with productivity plugins and custom keymaps.

## Features

- **LSP**: Auto-completion, diagnostics, and code actions
- **DAP**: Debugging support for multiple languages
- **Git**: LazyGit integration
- **Testing**: Neotest for running tests
- **Navigation**: Telescope, Navbuddy, bookmark management
- **AI**: Copilot and OpenCode integration
- **Extras**: Markdown rendering, PlantUML, image preview, undo tree

## Installation

1. Install [NVChad](https://nvchad.com)
2. Backup existing config: `mv ~/.config/nvim ~/.config/nvim.bak`
3. Clone this repo: `git clone <repo-url> ~/.config/nvim`
4. Open Neovim and let plugins install

## Key Plugins

- `conform` - Auto-formatting
- `lint` - Linting
- `telescope` - Fuzzy finder
- `copilot` - AI code completion
- `neotest` - Test runner
- `render-markdown` - Enhanced markdown
- `lazy-git` - Git UI
- `dap` - Debugger

## Structure

```
lua/
├── configs/     # Plugin configurations
├── custom/      # Custom modules
├── plugins/     # Plugin definitions
├── scripts/     # Helper scripts
├── mappings.lua # Keybindings
└── options.lua  # Neovim options
```
