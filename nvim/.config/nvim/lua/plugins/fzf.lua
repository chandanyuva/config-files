local fzf = require("fzf-lua")

fzf.setup({})

local map = vim.keymap.set
map("n", "<leader>ff", fzf.files, { desc = "[F]ind [F]iles" })
map("n", "<leader>fg", fzf.live_grep, { desc = "[F]ind by [G]rep" })
map("n", "<leader>fw", fzf.grep_cword, { desc = "[F]ind current [W]ord" })
map("n", "<leader>fd", fzf.diagnostics_workspace, { desc = "[F]ind [D]iagnostics" })
map("n", "<leader>fr", fzf.resume, { desc = "[F]ind [R]esume" })
map("n", "<leader>fb", fzf.buffers, { desc = "[F]ind [B]uffers" })
map("n", "<leader>fh", fzf.helptags, { desc = "[F]ind [H]elp" })
map("n", "<leader>fk", fzf.keymaps, { desc = "[F]ind [K]eymaps" })
map("n", "<leader>fc", function()
  fzf.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[F]ind [C]onfig files" })
map("n", "<leader><leader>", fzf.buffers, { desc = "Find existing buffers" })
