local function get_dir_files(dir)
	local handle = vim.uv.fs_scandir(dir)
	if not handle then
		return {}
	end

	local files = {}
	while true do
		local name, t = vim.uv.fs_scandir_next(handle)
		if not name then
			break
		end
		if t == "file" then
			local fullpath = dir .. "/" .. name
			local stat = vim.uv.fs_stat(fullpath)
			table.insert(files, { path = fullpath, mtime = stat.mtime.sec, size = stat.size })
		end
	end

	return files
end

local function cleanup_dir(dir, max_size)
	local files = get_dir_files(dir)

	local total = 0
	for _, f in ipairs(files) do
		total = total + f.size
	end

	if total <= max_size then
		return
	end

	table.sort(files, function(a, b)
		return a.mtime < b.mtime
	end)

	for _, f in ipairs(files) do
		if total <= max_size then
			break
		end
		os.remove(f.path)
		total = total - f.size
	end
end

local function auto_cleanup()
	local data = vim.fn.stdpath("data")
	local backup_dir = data .. "/backup"
	local undo_dir = data .. "/undo"

	local MAX_SIZE = 1024 * 1024 * 1024 -- 1GB

	cleanup_dir(backup_dir, MAX_SIZE)
	cleanup_dir(undo_dir, MAX_SIZE)
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.schedule(auto_cleanup)
	end,
})

vim.api.nvim_create_user_command("CleanNvimStorage", function()
	auto_cleanup()
	print("Neovim backup/undo storage cleaned.")
end, {})
