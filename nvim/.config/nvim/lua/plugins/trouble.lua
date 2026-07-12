local trouble = require("trouble")
trouble.setup({})

vim.keymap.set("n", "<leader>xx", function() trouble.toggle("diagnostics") end, { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", function() trouble.toggle("diagnostics", { filter = { buf = 0 } }) end, { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xL", function() trouble.toggle("loclist") end, { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", function() trouble.toggle("qflist") end, { desc = "Quickfix List (Trouble)" })
