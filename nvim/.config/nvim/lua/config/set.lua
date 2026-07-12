vim.loader.enable()

-- WSL: redirect XDG_RUNTIME_DIR to writable path (fzf-lua needs it for RPC server)
if vim.env.XDG_RUNTIME_DIR and vim.fn.isdirectory(vim.env.XDG_RUNTIME_DIR) ~= 1 then
	local fallback = "/tmp/nvim-xdg-" .. vim.env.USER
	vim.fn.mkdir(fallback, "p")
	vim.env.XDG_RUNTIME_DIR = fallback
end

local opt = vim.opt
local g = vim.g
local indent = 2

g.mapleader = " "
g.maplocalleader = " "

vim.g.have_nerd_font = true

-- Preview substitutions live, as you type!
vim.o.inccommand = "split"

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end) -- allow neovim to access the system clipboard

-- WSL clipboard: use Windows clip.exe instead of wl-copy
if vim.fn.has("wsl") == 1 then
	vim.g.clipboard = {
		name = "WSL Clipboard (Windows)",
		copy = {
			["+"] = "/mnt/c/Windows/System32/clip.exe",
			["*"] = "/mnt/c/Windows/System32/clip.exe",
		},
		paste = {
			["+"] = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c Get-Clipboard",
			["*"] = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -c Get-Clipboard",
		},
		cache_enabled = 0,
	}
end

-- indention
opt.expandtab = true
opt.shiftwidth = indent
opt.smartindent = true
opt.softtabstop = indent
opt.tabstop = indent
opt.shiftround = true
vim.o.breakindent = true

-- tabline
opt.showtabline = 2
opt.sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize"

-- search
opt.ignorecase = true
opt.smartcase = true
opt.wildignore = opt.wildignore + { "*/node_modules/*", "*/.git/*", "*/vendor/*" }

-- ui
vim.o.winborder = "rounded"
vim.o.confirm = true
opt.cursorline = true
opt.list = true
opt.listchars = {
	tab = "┊ ",
	trail = "·",
	extends = "»",
	precedes = "«",
	nbsp = "×",
}
opt.fillchars = { eob = " " }

opt.winminwidth = 0
opt.pumheight = 10
opt.pumblend = 10
opt.pumborder = "rounded"
opt.winblend = 10

opt.mouse = "a"
opt.number = true
vim.o.relativenumber = true
opt.scrolloff = 5
opt.sidescrolloff = 3
opt.signcolumn = "yes"
opt.splitbelow = true
opt.splitright = true

opt.formatoptions = "jcroqlnt"

-- backups
local backup_dir = vim.fn.stdpath("data") .. "/backup/"
if vim.fn.isdirectory(backup_dir) == 0 then
	vim.fn.mkdir(backup_dir, "p")
end

opt.backup = true
opt.backupext = ".bak"
opt.backupdir = { backup_dir, "/tmp/" }

opt.swapfile = false
opt.writebackup = false

-- undos
local undo_dir = vim.fn.stdpath("data") .. "/undo/"
if vim.fn.isdirectory(undo_dir) == 0 then
	vim.fn.mkdir(undo_dir, "p")
end

opt.undofile = true
opt.undodir = undo_dir
opt.undolevels = 10000
opt.undoreload = 10000

-- autocomplete
opt.completeopt = { "menu", "menuone", "noselect", "popup" }
opt.shortmess = opt.shortmess + { c = true }
opt.showmode = false -- mini.statusline handles this

-- performance
opt.redrawtime = 1500
opt.ttimeoutlen = 10
opt.timeoutlen = 300
opt.updatetime = 100

-- theme
opt.termguicolors = true

-- diagnostics
vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	underline = { severity = { min = vim.diagnostic.severity.WARN } },
	virtual_text = true,
	virtual_lines = { current_line = true },
	jump = {
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
		end,
	},
})
