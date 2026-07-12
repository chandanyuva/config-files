-- vtsls: TypeScript/JavaScript (bundles TypeScript internally)
vim.lsp.config("vtsls", {
	settings = {
		typescript = {
			suggest = { completeFunctionCalls = true },
			inlayHints = {
				includeInlayParameterNameHints = "all",
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
			},
		},
	},
})

-- lua_ls: custom settings (extends nvim-lspconfig's defaults)
vim.lsp.config("lua_ls", {
	on_init = function(client)
		client.server_capabilities.documentFormattingProvider = false

		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				version = "LuaJIT",
				path = { "lua/?.lua", "lua/?/init.lua" },
			},
			workspace = {
				checkThirdParty = false,
				library = vim.tbl_extend("force", vim.api.nvim_get_runtime_file("", true), {
					"${3rd}/luv/library",
				}),
			},
		})
	end,
	settings = {
		Lua = {
			format = { enable = false },
		},
	},
})

-- Enable all servers (nvim-lspconfig provides cmd/filetypes/root_markers)
for _, server in ipairs({ "vtsls", "gopls", "pyright", "clangd", "lua_ls" }) do
	vim.lsp.enable(server)
end

-- LspAttach: keymaps + document highlight
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc, mode)
			mode = mode or "n"
			vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- Go to definition (native, instant jump)
		map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")

		-- Go to declaration
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

		-- Workspace symbols (fzf-lua picker)
		map("gW", function() require("fzf-lua").lsp_workspace_symbols() end, "Open Workspace Symbols")

		-- Document symbols in fzf-lua (overrides built-in gO → quickfix)
		map("gO", function() require("fzf-lua").lsp_document_symbols() end, "Document Symbols (fzf)")

		-- Toggle inlay hints
		map("<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, "[T]oggle Inlay [H]ints")

		-- Document highlight: reference highlighting on cursor hold
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		if client and client:supports_method("textDocument/documentHighlight", event.buf) then
			local hl_group = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = hl_group,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = hl_group,
				callback = vim.lsp.buf.clear_references,
			})
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(e)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = e.buf })
				end,
			})
		end
	end,
})

