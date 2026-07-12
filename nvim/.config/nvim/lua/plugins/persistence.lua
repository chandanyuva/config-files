require("persistence").setup({
  store = vim.fn.stdpath("state") .. "/sessions/",
})

vim.keymap.set("n", "<leader>ss", function()
  require("persistence").load()
end, { desc = "Restore session" })

vim.keymap.set("n", "<leader>sl", function()
  require("persistence").load({ last = true })
end, { desc = "Restore last session" })

vim.keymap.set("n", "<leader>sd", function()
  require("persistence").save()
end, { desc = "Save session" })
