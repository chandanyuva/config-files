require("noice").setup({
  messages = { enabled = true, view = "mini" },
  popupmenu = { enabled = true },
  cmdline = { enabled = true, view = "cmdline_popup" },
  notify = { enabled = true },
  history = { enabled = true },
  presets = {
    command_palette = true,
    long_message_to_split = true,
  },
  views = {
    hover = {
      border = { style = "rounded", padding = { 0, 1 } },
    },
  },
})
