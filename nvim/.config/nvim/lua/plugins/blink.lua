local cmp = require("blink.cmp")

vim.lsp.config("*", {
  capabilities = cmp.get_lsp_capabilities(),
})

cmp.setup({
  keymap = { preset = "default" },
  sources = {
    default = { "lsp", "path", "snippets", "lazydev", "dadbod" },
    providers = {
      lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
      dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
    },
  },
  completion = {
    documentation = { auto_show = false, auto_show_delay_ms = 500 },
  },
  signature = { enabled = true },
  fuzzy = { implementation = "lua" },
})
