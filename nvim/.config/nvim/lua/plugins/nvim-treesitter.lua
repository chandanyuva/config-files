require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

-- Small core set installed up-front (blocking) so these work immediately
require("nvim-treesitter").install({
  "c",
  "lua",
  "vim",
  "vimdoc",
  "query",
  "markdown",
  "markdown_inline",
  "go",
  "javascript",
  "typescript",
  "tsx",
  "python",
  "sql",
}):wait(600000)

-- On-demand install of the parser for any other filetype you open
local queued = {}
local available
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local ft = vim.bo.filetype
    if ft == "" then
      return
    end
    local ok_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
    if not ok_lang or not lang or queued[lang] then
      return
    end
    if pcall(vim.treesitter.language.inspect, lang) then
      return
    end
    available = available or require("nvim-treesitter").get_available()
    if not vim.tbl_contains(available, lang) then
      queued[lang] = true -- not a known tree-sitter language; don't retry
      return
    end
    queued[lang] = true
    require("nvim-treesitter").install({ lang })
  end,
})

-- Native treesitter syntax highlighting (nvim 0.12)
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
