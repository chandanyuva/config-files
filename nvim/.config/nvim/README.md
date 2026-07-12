# Neovim Config — Keybinding Cheat Sheet

26 plugins, Neovim 0.12.3, `vim.pack` native plugin management.

## General

| Key | Mode | Action |
|-----|------|--------|
| `Esc` | n | Clear search highlights |
| `J` / `K` | v | Move selected lines down / up |
| `<C-h>` | n | Move to left window |
| `<C-j>` | n | Move to window below |
| `<C-k>` | n | Move to window above |
| `<C-l>` | n | Move to right window |
| `<leader>q` | n | Send diagnostics to quickfix list |

## Find (fzf-lua)

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fw` | Find current word under cursor |
| `<leader>fd` | Find diagnostics (workspace) |
| `<leader>fr` | Resume last search |
| `<leader>fb` | Find buffers |
| `<leader><leader>` | Find buffers (alt) |
| `<leader>fh` | Find help tags |
| `<leader>fk` | Find keymaps |
| `<leader>fc` | Find config files |

## Buffer

| Key | Action |
|-----|--------|
| `<leader>]` | Next buffer |
| `<leader>[` | Previous buffer |
| `<leader>bx` | Delete buffer |

## File Explorer (oil)

| Key | Action |
|-----|--------|
| `<leader>e` | Open parent directory (floating) |

## Harpoon

| Key | Action |
|-----|--------|
| `<C-e>` | Toggle quick menu |
| `<leader>a` | Add file to harpoon |
| `<leader>1` | Jump to harpoon mark 1 |
| `<leader>2` | Jump to harpoon mark 2 |
| `<leader>3` | Jump to harpoon mark 3 |
| `<leader>4` | Jump to harpoon mark 4 |

## LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gO` | Document symbols (fzf-lua) |
| `gW` | Workspace symbols (fzf-lua) |
| `<leader>th` | Toggle inlay hints |
| `<leader>li` | Show LSP info |

## Session (persistence)

| Key | Action |
|-----|--------|
| `<leader>ss` | Restore session |
| `<leader>sl` | Restore last session |
| `<leader>sd` | Save session |

## Breadcrumbs

| Key | Action |
|-----|--------|
| `<leader>to` | Toggle path breadcrumbs panel |

## Snacks Modules

| Key | Action |
|-----|--------|
| `<leader>tt` | Toggle floating terminal |
| `<leader>z` | Toggle zen mode |

## Undo Tree

| Key | Action |
|-----|--------|
| `<leader>u` | Toggle undo tree |

## Format (conform)

| Key | Action |
|-----|--------|
| `<leader>cf` | Format buffer |

## Diagnostics (trouble)

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle diagnostics (all) |
| `<leader>xX` | Toggle diagnostics (current buffer) |
| `<leader>xL` | Toggle location list |
| `<leader>xQ` | Toggle quickfix list |

## Terminal

| Key | Mode | Action |
|-----|------|--------|
| `<Esc><Esc>` | t | Exit terminal mode |

## Which-Key Groups

Press `<leader>` and wait 200ms to see available groups:

| Prefix | Group |
|--------|-------|
| `<leader>f` | Find |
| `<leader>b` | Buffer |
| `<leader>t` | Toggle |
| `<leader>s` | Session |
| `<leader>l` | LSP |
| `<leader>c` | Code / Format |
| `<leader>x` | Diagnostics / Trouble |
| `gr` | LSP Actions |

## Plugins

| Plugin | Purpose |
|--------|---------|
| rose-pine | Colorscheme |
| mini.nvim | Icons, pairs, indentscope, statusline |
| fidget.nvim | LSP progress spinners |
| gitsigns.nvim | Git signs in gutter |
| which-key.nvim | Keymap hints |
| persistence.nvim | Session management |
| nvim-colorizer.lua | Color previews |
| Comment.nvim | Commenting (gcc/gc) |
| fzf-lua | Fuzzy finder |
| oil.nvim | File explorer |
| harpoon | Quick file navigation |
| snacks.nvim | QoL: notifier, scroll, input, zen, terminal |
| breadcrumbs | Path panel showing current file location in project tree |
| undotree | Undo tree visualizer |
| mason.nvim | LSP installer |
| mason-lspconfig.nvim | LSP bridge |
| mason-tool-installer.nvim | Tool installer |
| nvim-lspconfig | Server config catalog |
| lazydev.nvim | Lua LSP integration |
| blink.cmp | Completion engine |
| plenary.nvim | Utility (harpoon dep) |
| conform.nvim | Format-on-save |
| nvim-lint | Lint-on-save |
| trouble.nvim | Diagnostics UI |
| render-markdown.nvim | Markdown rendering |
| nvim-treesitter | Parser installation |
