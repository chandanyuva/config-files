return {
	-- {
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		---@diagnostic disable-next-line: missing-fields
	-- 		require("tokyonight").setup({
	-- 			styles = {
	-- 				comments = { italic = false }, -- Disable italics in comments
	-- 			},
	-- 		})
	-- 		vim.cmd("colorscheme tokyonight")
	-- 	end,
	-- },
	-- {
	-- 	{
	-- 		"olimorris/onedarkpro.nvim",
	-- 		priority = 1000, -- Ensure it loads first
	-- 		config = function()
	-- 			vim.cmd("colorscheme onedark_dark")
	-- 		end,
	-- 	},
	-- },
	{
		"rose-pine/neovim",
		name = "rose-pine",
		config = function()
			require("rose-pine").setup({
				styles = {
					bold = true,
					italic = false,
					transparency = true,
				},
				highlight_groups = {
					Comment = { italic = false },
				},
			})
			vim.cmd("colorscheme rose-pine")
		end,
	},
}
