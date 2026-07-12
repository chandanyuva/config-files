require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("mini.pairs").setup()

require("mini.indentscope").setup({
  symbol = "▏",
})

local statusline = require("mini.statusline")
statusline.setup({ use_icons = vim.g.have_nerd_font })

statusline.section_location = function()
  return "%2l:%-2v"
end
