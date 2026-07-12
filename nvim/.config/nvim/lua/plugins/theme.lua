require("rose-pine").setup({
  styles = {
    bold = true,
    italic = false,
    transparency = true,
  },
  highlight_groups = {
    Comment = { italic = false },
  },
})

vim.cmd.colorscheme("rose-pine")
