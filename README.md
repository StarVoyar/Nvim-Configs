# Neovim Configuration

A modular, plugin-based Neovim configuration organized by plugin names for easy maintenance and customization.

## Structure

```
configs/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── plugins.lua          # Plugin imports (lazy.nvim)
│   ├── plugins/             # Individual plugin specifications
│   │   ├── alpha-nvim.lua
│   │   ├── grug-far.lua
│   │   ├── lualine.lua
│   │   ├── mason-lspconfig.lua
│   │   ├── mason.lua
│   │   ├── neo-tree.lua
│   │   ├── neoscroll.lua
│   │   ├── nvim-autopairs.lua
│   │   ├── nvim-cmp.lua
│   │   ├── nvim-dap.lua
│   │   ├── nvim-lspconfig.lua
│   │   ├── nvim-treesitter.lua
│   │   ├── smear-cursor.lua
│   │   ├── smoothcursor.lua
│   │   ├── telescope-live-grep-args.lua
│   │   ├── telescope.lua
│   │   ├── tiny-code-action.lua
│   │   ├── tokyonight.lua
│   │   └── vim-visual-multi.lua
│   └── configs/             # Plugin configurations
│       ├── alpha-nvim.lua
│       ├── grug-far.lua
│       ├── keybindings.lua
│       ├── lualine.lua
│       ├── mason.lua
│       ├── neo-tree.lua
│       ├── neoscroll.lua
│       ├── nvim-cmp.lua
│       ├── nvim-dap.lua
│       ├── nvim-lspconfig.lua
│       ├── nvim-treesitter.lua
│       ├── smear-cursor.lua
│       ├── smoothcursor.lua
│       ├── telescope.lua
│       ├── tokyonight.lua
│       └── ui.lua
```

## Features

- **Plugin Manager**: lazy.nvim with individual plugin files
- **Theme**: TokyoNight (dark/night variant)
- **Completion**: nvim-cmp with LuaSnip
- **LSP**: nvim-lspconfig with mason.nvim and mason-lspconfig.nvim
- **Debugging**: nvim-dap with UI, Python, Go, JavaScript adapters
- **File Explorer**: neo-tree.nvim
- **Fuzzy Finder**: telescope.nvim with live-grep-args extension
- **Search & Replace**: grug-far.nvim
- **Status Line**: lualine.nvim with TokyoNight theme
- **Startup Dashboard**: alpha-nvim with custom falling stars animation
- **Syntax Highlighting**: nvim-treesitter
- **Cursor Effects**: smear-cursor.nvim, smoothcursor.nvim
- **Smooth Scrolling**: neoscroll.nvim
- **Auto Pairs**: nvim-autopairs
- **Multi-cursor**: vim-visual-multi
- **Code Actions**: tiny-code-action.nvim

## Keybindings

| Key             | Action                          |
| --------------- | ------------------------------- |
| `<Control + f>` | Live grep (telescope)           |
| `<Alt + f>`     | Find files (telescope)          |
| `<Control + e>` | Toggle file explorer            |
| `<Control + r>` | Search and replace (grug-far)   |
| `<Control + t>` | Toggle terminal                 |
| `<Control + s>` | Save                            |
| `<Control + q>` | Quit with confirmation          |
| `<Alt + s>`     | Save all and quit               |
| `<Control + a>` | Select all                      |
| `<Control + d>` | Select word/line (multi-cursor) |
| `<F8>`          | Toggle debug UI                 |
| `<Control + b>` | Toggle breakpoint               |
| `<F5>`          | Continue debugging              |
| `<F10>`         | Step over                       |
| `<F11>`         | Step into                       |
| `<Shift + F11>` | Step out                        |

## Installation

1. Backup your existing Neovim config (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   ```

2. Clone this configuration:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. Start Neovim - plugins will install automatically via lazy.nvim

## Requirements

- Neovim >= 0.9.0
- Git
- A Nerd Font (for icons)
- Python 3 (for some LSP servers)
- Node.js (for some LSP servers)

## Customization

- Add new plugins: Create a new file in `lua/plugins/` and add import to `lua/plugins.lua`
- Modify plugin config: Edit corresponding file in `lua/configs/`
- Add keybindings: Edit `lua/configs/keybindings.lua`
- Change theme: Edit `lua/configs/tokyonight.lua` or replace with another theme

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.
