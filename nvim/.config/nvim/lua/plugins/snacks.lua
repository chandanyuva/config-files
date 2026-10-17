local Snacks = require("snacks")

Snacks.setup({
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scroll = {
    enabled = true,
    animate = {
      duration = { step = 10, total = 200 },
      easing = "outQuad",
    },
  },
  input = { enabled = true },
  zen = { enabled = true },
  indent = {
    enabled = true,
    indent = {
      char = "│",
      hl = "SnacksIndent",
    },
    scope = {
      enabled = true,
      char = "│",
      hl = "SnacksIndentScope",
      underline = false,
    },
    animate = { enabled = true },
  },
  terminal = {
    enabled = true,
    win = {
      position = "float",
      border = "rounded",
      relative = "editor",
      width = 0.9,
      height = 0.9,
    },
  },
})

vim.keymap.set("n", "<leader>tt", function() Snacks.terminal() end, { desc = "Toggle Terminal" })
vim.keymap.set("n", "<leader>z", function() Snacks.zen() end, { desc = "Zen Mode" })
