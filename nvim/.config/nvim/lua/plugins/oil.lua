require("oil").setup({
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
    is_hidden_file = function(name)
      return name:match("^%.") ~= nil
    end,
    natural_order = "fast",
    sort = {
      { "type", "asc" },
      { "name", "asc" },
    },
  },
  float = {
    preview_split = "right",
  },
})

vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
