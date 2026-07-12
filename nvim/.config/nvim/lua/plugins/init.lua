local function gh(repo)
  return "https://github.com/" .. repo
end

-- ============================================
-- Plugin Declarations
-- ============================================

vim.pack.add({
  { src = gh("rose-pine/neovim"), name = "rose-pine" },
})

vim.pack.add({
  { src = gh("nvim-mini/mini.nvim"), name = "mini.nvim" },
  { src = gh("j-hui/fidget.nvim"), name = "fidget.nvim" },
  { src = gh("lewis6991/gitsigns.nvim"), name = "gitsigns.nvim" },
  { src = gh("folke/which-key.nvim"), name = "which-key.nvim" },
  { src = gh("folke/persistence.nvim"), name = "persistence.nvim" },
  { src = gh("catgoose/nvim-colorizer.lua"), name = "nvim-colorizer.lua" },
  { src = gh("numToStr/Comment.nvim"), name = "Comment.nvim" },
})

vim.pack.add({
  { src = gh("ibhagwan/fzf-lua"), name = "fzf-lua" },
  { src = gh("nvim-lua/plenary.nvim"), name = "plenary.nvim" },
  { src = gh("stevearc/oil.nvim"), name = "oil.nvim" },
  { src = gh("ThePrimeagen/harpoon"), name = "harpoon", version = "harpoon2" },
  { src = gh("folke/snacks.nvim"), name = "snacks.nvim" },
  { src = gh("jiaoshijie/undotree"), name = "undotree" },
})

vim.pack.add({
  { src = gh("mason-org/mason.nvim"), name = "mason.nvim" },
  { src = gh("mason-org/mason-lspconfig.nvim"), name = "mason-lspconfig.nvim" },
  { src = gh("WhoIsSethDaniel/mason-tool-installer.nvim"), name = "mason-tool-installer.nvim" },
  { src = gh("neovim/nvim-lspconfig"), name = "nvim-lspconfig" },
})

vim.pack.add({
  { src = gh("folke/lazydev.nvim"), name = "lazydev.nvim" },
  { src = gh("saghen/blink.lib"), name = "blink.lib" },
  { src = gh("saghen/blink.cmp"), name = "blink.cmp" },
})

vim.pack.add({
  { src = gh("stevearc/conform.nvim"), name = "conform.nvim" },
  { src = gh("mfussenegger/nvim-lint"), name = "nvim-lint" },
  { src = gh("folke/trouble.nvim"), name = "trouble.nvim" },
  { src = gh("MeanderingProgrammer/render-markdown.nvim"), name = "render-markdown.nvim" },
})

-- ============================================
-- Mason setup (must run after pack declarations, before LSP)
-- ============================================

require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "vtsls", "gopls", "pyright", "clangd", "lua_ls" },
  automatic_enable = false,
})
require("mason-tool-installer").setup({
  ensure_installed = { "stylua", "eslint_d", "prettierd" },
})

-- ============================================
-- Load plugin configs
-- ============================================

require("plugins.theme")
require("plugins.blink")
require("plugins.fzf")
require("plugins.oil")
require("plugins.harpoon")
require("plugins.gitsigns")
require("plugins.which-key")
require("plugins.mini")
require("plugins.fidget")
require("plugins.persistence")
require("plugins.colorizer")
require("plugins.comment")
require("plugins.snacks")
require("plugins.undotree")
require("plugins.conform")
require("plugins.lint")
require("plugins.trouble")
require("plugins.markdown")
require("plugins.tree-panel")
