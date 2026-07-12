require("which-key").setup({
  delay = 200,
  preset = "helix",
  icons = { mappings = vim.g.have_nerd_font },
  win = {
    width = { min = 20, max = 50 },
    height = { min = 4, max = 25 },
    col = -1,
    row = -1,
    border = "rounded",
    padding = { 1, 2 },
    title = true,
    title_pos = "center",
  },
  layout = {
    width = { min = 20, max = 40 },
    spacing = 3,
  },
  spec = {
    { "<leader>f", group = "[F]ind", mode = { "n", "v" } },
    { "<leader>b", group = "[B]uffer", mode = { "n", "v" } },
    { "<leader>t", group = "[T]oggle", mode = { "n", "v" } },
    { "<leader>s", group = "[S]ession", mode = { "n", "v" } },
    { "<leader>l", group = "[L]SP", mode = { "n", "v" } },
    { "<leader>c", group = "[C]ode / Format", mode = { "n", "v" } },
    { "<leader>x", group = "Diagnostics / Trouble", mode = { "n", "v" } },
    { "gr", group = "LSP Actions", mode = { "n" } },
  },
})
