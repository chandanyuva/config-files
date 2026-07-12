# Neovim 0.12+ Config — Modernization Plan

## Goals
- Target Neovim 0.12.3 with native APIs (no unnecessary plugins)
- Minimal plugin set: only plugins that add real value
- Proper IDE: LSP, completion, treesitter, themes, file explorer, fuzzy finder
- Modular file structure, stow-managed from `~/config-files/nvim/`

## Key Decisions

| Decision | Choice | Why |
|----------|--------|-----|
| Plugin manager | `vim.pack` (native) | Built-in since 0.11, zero overhead |
| LSP config | `vim.lsp.config` + `vim.lsp.enable` | Built-in since 0.11 |
| LSP servers catalog | `nvim-lspconfig` (config files only) | Provides cmd/filetypes/root_markers for each server |
| Completion | `blink.cmp` (Lua fuzzy) | Faster than native, better features |
| TypeScript server | `vtsls` | Bundles TS internally (TS 7.0 broke ts_ls) |
| Treesitter | Auto-loads from `pack/` directory | No pack.add needed, parsers auto-install |
| Undotree | `jiaoshijie/undotree` plugin | `:Undotree` not in 0.12.3, plugin works |
| Fuzzy finder | fzf-lua | Lighter than telescope, fewer deps |
| Statusline | mini.statusline | Tiny, fast, well-maintained |
| Session | persistence.nvim | Auto-save/restore, minimal |
| QoL modules | snacks.nvim | notifier, quickfile, scroll, input, zen, terminal |

## Directory Structure

```
~/config-files/nvim/.config/nvim/
├ .luarc.json                       # lua_ls config (root fix)
├ init.lua                          # Thin loader (5 lines)
├ lua/
│  config/
│  │  set.lua                       # Vim options
│  │  map.lua                       # Core keymaps
│  │  backup.lua                    # Auto-cleanup of undo/backup dirs
│  │  └ lsp.lua                     # Native LSP config + LspAttach keymaps
│  └ plugins/
│     init.lua                      # vim.pack.add() declarations + mason + requires
│     theme.lua                     # rose-pine
│     blink.lua                     # blink.cmp completion
│     fzf.lua                       # fzf-lua + keymaps
│     oil.lua                       # oil.nvim floating
│     harpoon.lua                   # harpoon2 + keymaps
│     gitsigns.lua                  # git signs
│     which-key.lua                 # keymap hints
│     mini.lua                      # icons + pairs + indentscope + statusline
│     fidget.lua                    # LSP progress
│     snacks.lua                    # snacks.nvim modules
│     persistence.lua               # session management
│     colorizer.lua                 # color highlighting
│     comment.lua                   # commenting
│     undotree.lua                  # undo tree
│     conform.lua                   # format-on-save
│     lint.lua                      # lint-on-save
│     trouble.lua                   # diagnostics UI
│     └ markdown.lua                # render-markdown
├ plan.md                           # This file
└ README.md                         # Keybinding cheat sheet
```

---

## Plugin Summary

| # | Plugin | Purpose |
|---|--------|---------|
| 1 | rose-pine | Colorscheme |
| 2 | mini.nvim | Icons, pairs, indentscope, statusline |
| 3 | fidget.nvim | LSP progress spinners |
| 4 | gitsigns.nvim | Git signs in gutter |
| 5 | which-key.nvim | Keymap hints |
| 6 | persistence.nvim | Session management |
| 7 | nvim-colorizer.lua | Color previews |
| 8 | Comment.nvim | Commenting (gcc/gc) |
| 9 | fzf-lua | Fuzzy finder |
| 10 | oil.nvim | File explorer (buffer-based) |
| 11 | harpoon | Quick file navigation |
| 12 | snacks.nvim | QoL: notifier, scroll, input, zen, terminal, quickfile |
| 13 | undotree | Undo tree visualizer |
| 14 | mason.nvim | LSP installer |
| 15 | mason-lspconfig.nvim | LSP bridge |
| 16 | mason-tool-installer.nvim | Tool installer |
| 17 | nvim-lspconfig | Server config catalog |
| 18 | lazydev.nvim | Lua LSP integration |
| 19 | blink.cmp | Completion engine |
| 20 | blink.lib | blink.cmp dependency |
| 21 | plenary.nvim | Utility (harpoon dep) |
| 22 | conform.nvim | Format-on-save |
| 23 | nvim-lint | Lint-on-save |
| 24 | trouble.nvim | Diagnostics UI |
| 25 | render-markdown.nvim | Markdown rendering |
| 26 | nvim-treesitter | Parser installation (auto-loaded from pack/) |

**Total: 26 plugins**

---

## What Gets Deleted (from old config)

| File/Plugin | Why |
|-------------|-----|
| `lua/config/lazy.lua` | Replaced by vim.pack |
| `lazy-lock.json` | No lazy.nvim anymore |
| `lua/plugins/telescope.lua` | Replaced by fzf-lua |
| `lua/plugins/autocomplete.lua` | Replaced by blink.cmp |
| `lua/plugins/LSP.lua` | Split into config/lsp.lua + plugins/init.lua (mason) |
| `lua/plugins/nvim-treesitter.lua` | Auto-loaded from pack/ directory |
| `lua/plugins/undoTree.lua` | Replaced by jiaoshijie/undotree |
| `lua/plugins/lazygit.lua` | Removed (was lazygit.nvim, not needed) |
| `lua/plugins/opencode.lua` | Removed |
| `lua/plugins/autoformat.lua` | Handled by conform.nvim |
| `lua/plugins/small-ones.lua` | Split: gitsigns/comment/colorizer kept individually |

---

## Migration Status

All steps completed. Config is fully functional.

| Step | Status |
|------|--------|
| Create plan.md | Done |
| Write init.lua | Done |
| Write config/set.lua | Done |
| Write config/map.lua | Done |
| Write config/backup.lua | Done |
| Write config/lsp.lua | Done |
| Write plugins/init.lua (vim.pack + mason) | Done |
| Write all plugin config files (18 files) | Done |
| Add snacks.nvim (notifier, quickfile, scroll, input, zen, terminal) | Done |
| Config review + fixes | Done |
| Write README.md | Done |

---

## Notes

- `nvim-treesitter` is NOT in `vim.pack.add()` — it auto-loads from `pack/` directory
- `mason` setup lives in `plugins/init.lua` (between pack declarations and config requires)
- `blink.cmp` capabilities are set in `plugins/blink.lua` (not lsp.lua) for load order
- `vtsls` replaces `ts_ls` — bundles TypeScript internally (TS 7.0 removed tsserver)
- Without nvim-lspconfig, `vim.lsp.config` requires explicit `cmd` for every server
- `lazyredraw` and `matchpairs` are removed — deprecated/default in 0.12
- WSL clipboard uses `clip.exe`/`powershell.exe` for `+`/`*` registers
- `.luarc.json` at nvim config root fixes lua_ls root detection
