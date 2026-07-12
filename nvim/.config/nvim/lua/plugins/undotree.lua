require("undotree").setup({
  position = "right",
  parser = "compact",
})

vim.keymap.set("n", "<leader>u", function()
  require("undotree").toggle()
end, { desc = "Toggle Undotree" })
