local M = {}

local AUTO_OPEN = true

local state = {
  win = nil,
  buf = nil,
  ns = vim.api.nvim_create_namespace("breadcrumbs"),
  git = {},
  git_timer = nil,
}

local EXCLUDE = {
  "node_modules", ".git", ".venv", "__pycache__",
  ".next", "dist", "build", ".DS_Store",
}

local render -- forward declare

local GIT_ICONS = {
  M = "●",  -- modified
  A = "+",  -- added
  D = "−",  -- deleted
  R = "→",  -- renamed
  C = "→",  -- copied
  U = "!",  -- unmerged
  ["?"] = "~",  -- untracked
}

local function get_palette()
  local ok, p = pcall(require, "rose-pine.palette")
  if ok then return p end
  return { iris = "#c4a7e7", foam = "#9ccfd8" }
end

local function setup_highlights()
  local p = get_palette()

  vim.api.nvim_set_hl(0, "BreadcrumbsConnector", { link = "NonText" })
  vim.api.nvim_set_hl(0, "BreadcrumbsDir", {
    fg = p.iris,
  })
  vim.api.nvim_set_hl(0, "BreadcrumbsFile", { link = "Normal" })
  vim.api.nvim_set_hl(0, "BreadcrumbsCurrent", {
    bold = true,
    fg = p.foam,
  })
  vim.api.nvim_set_hl(0, "BreadcrumbsGitModified", { fg = p.gold })
  vim.api.nvim_set_hl(0, "BreadcrumbsGitAdded", { fg = p.foam })
  vim.api.nvim_set_hl(0, "BreadcrumbsGitDeleted", { fg = p.love })
  vim.api.nvim_set_hl(0, "BreadcrumbsGitUntracked", { fg = p.subtle })
  vim.api.nvim_set_hl(0, "BreadcrumbsGitRenamed", { fg = p.rose })
  vim.api.nvim_set_hl(0, "BreadcrumbsCount", { fg = p.muted })
end

setup_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("breadcrumbs-hl", { clear = true }),
  callback = function()
    setup_highlights()
  end,
})

local function is_excluded(name)
  for _, pattern in ipairs(EXCLUDE) do
    if name == pattern then return true end
  end
  return false
end

local function get_entries(dir)
  local entries = {}
  local handle = vim.uv.fs_scandir(dir)
  if not handle then return entries end
  while true do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then break end
    if not is_excluded(name) then
      table.insert(entries, { name = name, type = t })
    end
  end
  table.sort(entries, function(a, b)
    if a.type == b.type then return a.name < b.name end
    return a.type == "directory"
  end)
  return entries
end

local function count_entries(dir)
  local count = 0
  local handle = vim.uv.fs_scandir(dir)
  if not handle then return 0 end
  while true do
    local name = vim.uv.fs_scandir_next(handle)
    if not name then break end
    if not is_excluded(name) then
      count = count + 1
    end
  end
  return count
end

local function refresh_git()
  local cwd = vim.uv.cwd()
  vim.system({ "git", "rev-parse", "--show-toplevel" }, { cwd = cwd, text = true }, function(root_out)
    if root_out.code ~= 0 then
      vim.schedule(function()
        state.git = {}
      end)
      return
    end
    local git_root = vim.trim(root_out.stdout)
    local real_cwd = vim.uv.fs_realpath(cwd) or cwd
    local prefix = real_cwd:sub(#git_root + 2)

    vim.system({ "git", "status", "--porcelain=v1" }, { cwd = cwd, text = true }, function(out)
      if out.code ~= 0 then
        vim.schedule(function()
          state.git = {}
        end)
        return
      end
      local git = {}
      for line in out.stdout:gmatch("[^\r\n]+") do
        local index_status = line:sub(1, 1)
        local work_status = line:sub(2, 2)
        local path = line:sub(4)
        local status = index_status ~= " " and index_status or work_status
        local rel = path
        if #prefix > 0 and path:sub(1, #prefix) == prefix then
          rel = path:sub(#prefix + 2)
        end
        if status ~= " " and status ~= "?" then
          git[rel] = status
        elseif status == "?" then
          git[rel] = "?"
        end
      end
      vim.schedule(function()
        state.git = git
        if state.win and vim.api.nvim_win_is_valid(state.win) then
          render()
        end
      end)
    end)
  end)
end

local function schedule_git_refresh()
  if state.git_timer and not state.git_timer:is_closing() then
    state.git_timer:stop()
    state.git_timer:close()
  end
  state.git_timer = vim.uv.new_timer()
  state.git_timer:start(500, 0, function()
    refresh_git()
  end)
end

local function get_git_icon(path)
  local status = state.git[path]
  if not status then return nil, nil end
  return GIT_ICONS[status] or status, status
end

local function get_git_hl(status)
  local map = {
    M = "BreadcrumbsGitModified",
    A = "BreadcrumbsGitAdded",
    D = "BreadcrumbsGitDeleted",
    U = "BreadcrumbsGitDeleted",
    R = "BreadcrumbsGitRenamed",
    C = "BreadcrumbsGitRenamed",
  }
  return map[status] or "BreadcrumbsGitUntracked"
end

local function build_path_tree(dir, path_components, depth, cwd)
  local entries = get_entries(dir)
  local lines = {}
  local target = path_components and path_components[1] or nil
  local next = (path_components and #path_components > 1)
    and vim.list_extend({}, path_components, 2)
    or nil

  local target_dir = nil
  if target then
    for _, e in ipairs(entries) do
      if e.type == "directory" and e.name == target then
        target_dir = e
        break
      end
    end
  end

  local C1 = "├─ "
  local C2 = "╰─ "
  local C3 = "│  "

  if depth == 1 then
    for i, entry in ipairs(entries) do
      local last = (i == #entries)
      local conn = last and C2 or C1

      if entry.type == "directory" and entry.name == target then
        local name = entry.name .. "/"
        table.insert(lines, { text = conn .. name, conn_len = #conn, hl = "BreadcrumbsDir", path = entry.name, type = "directory" })
        local pfx = last and "   " or C3
        for _, child in ipairs(build_path_tree(dir .. "/" .. entry.name, next, depth + 1, cwd)) do
          table.insert(lines, { text = pfx .. child.text, conn_len = child.conn_len + #pfx, hl = child.hl, path = child.path, type = child.type })
        end
      elseif entry.type == "directory" then
        local count = count_entries(dir .. "/" .. entry.name)
        table.insert(lines, { text = conn .. entry.name .. "/ [+" .. count .. "]", conn_len = #conn, hl = "BreadcrumbsDir", path = entry.name, type = "directory" })
      else
        table.insert(lines, { text = conn .. entry.name, conn_len = #conn, hl = "BreadcrumbsFile", path = entry.name, type = "file" })
      end
    end
  elseif target_dir then
    local ep = dir:sub(#cwd + 2) .. "/" .. target_dir.name
    table.insert(lines, { text = C1 .. target_dir.name .. "/", conn_len = #C1, hl = "BreadcrumbsDir", path = ep, type = "directory" })
    for _, child in ipairs(build_path_tree(dir .. "/" .. target_dir.name, next, depth + 1, cwd)) do
      table.insert(lines, { text = C3 .. child.text, conn_len = child.conn_len + #C3, hl = child.hl, path = child.path, type = child.type })
    end
  else
    for i, entry in ipairs(entries) do
      local last = (i == #entries)
      local conn = last and C2 or C1
      local ep = dir:sub(#cwd + 2) .. "/" .. entry.name

      if entry.type == "directory" then
        local count = count_entries(dir .. "/" .. entry.name)
        table.insert(lines, { text = conn .. entry.name .. "/ [+" .. count .. "]", conn_len = #conn, hl = "BreadcrumbsDir", path = ep, type = "directory" })
      else
        table.insert(lines, { text = conn .. entry.name, conn_len = #conn, hl = "BreadcrumbsFile", path = ep, type = "file" })
      end
    end
  end

  return lines
end

local function get_current_file(cwd)
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].buftype ~= "" then return nil end
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then return nil end
  local abs = vim.uv.fs_realpath(name)
  if not abs then return nil end
  if abs:sub(1, #cwd + 1) == cwd .. "/" then
    return abs:sub(#cwd + 2)
  end
  return nil
end

function render()
  if not state.buf or not vim.api.nvim_buf_is_valid(state.buf) then return end

  local cwd = vim.fn.getcwd()
  local file = get_current_file(cwd)
  local components = file and vim.split(file, "/", { plain = true }) or nil
  local tree = build_path_tree(cwd, components, 1, cwd)

  local display = {}
  local file_line
  for i, entry in ipairs(tree) do
    display[#display + 1] = entry.text
    if file and entry.path == file then file_line = i end
  end

  vim.bo[state.buf].modifiable = true
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, display)
  vim.bo[state.buf].modifiable = false

  vim.api.nvim_buf_clear_namespace(state.buf, state.ns, 0, -1)
  for i, entry in ipairs(tree) do
    local line = i - 1
    local is_current_file = (file_line and i == file_line)
    local is_path_dir = not is_current_file and file and entry.type == "directory"
      and file:sub(1, #entry.path + 1) == entry.path .. "/"

    if entry.conn_len > 0 then
      vim.api.nvim_buf_set_extmark(state.buf, state.ns, line, 0, {
        end_col = entry.conn_len,
        hl_group = "BreadcrumbsConnector",
      })
    end

    local hl = entry.hl
    if is_current_file then
      hl = "BreadcrumbsCurrent"
    elseif is_path_dir then
      hl = "BreadcrumbsDir"
    end

    local name_start = entry.conn_len
    local name_end = #entry.text

    local git_icon, git_status = get_git_icon(entry.path)
    if git_icon then
      local icon_pos = name_end
      vim.api.nvim_buf_set_extmark(state.buf, state.ns, line, icon_pos, {
        virt_text = { { " " .. git_icon, get_git_hl(git_status) } },
        virt_text_pos = "overlay",
      })
    end

    vim.api.nvim_buf_set_extmark(state.buf, state.ns, line, name_start, {
      end_col = name_end,
      hl_group = hl,
    })
  end

  if state.win and vim.api.nvim_win_is_valid(state.win) then
    local total = #display
    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
    local height = math.min(total, screen_h - 4)
    vim.api.nvim_win_set_height(state.win, height)

    if file_line then
      local first_path_line = nil
      for i, entry in ipairs(tree) do
        local is_path_dir = file and entry.type == "directory"
          and file:sub(1, #entry.path + 1) == entry.path .. "/"
        if is_path_dir then
          first_path_line = i
          break
        end
      end

      local from_line = first_path_line or 1
      local target
      if file_line > from_line + height - 1 then
        target = from_line
      else
        target = math.max(1, math.min(from_line, total - height + 1))
      end
      vim.api.nvim_win_call(state.win, function()
        vim.fn.winrestview({ topline = target })
      end)
    end
  end
end

local function ensure_buf()
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then return end
  state.buf = vim.api.nvim_create_buf(false, true)
  vim.bo[state.buf].buftype = "nofile"
  vim.bo[state.buf].bufhidden = "hide"
  vim.bo[state.buf].swapfile = false
  vim.bo[state.buf].modifiable = false
end

function M.open()
  ensure_buf()

  if state.win and vim.api.nvim_win_is_valid(state.win) then return end

  local screen_w = vim.opt.columns:get()
  local width = 40

  state.win = vim.api.nvim_open_win(state.buf, false, {
    relative = "editor",
    width = width,
    height = 1,
    row = 1,
    col = screen_w - width - 1,
    style = "minimal",
    border = "none",
    focusable = false,
    zindex = 50,
  })

  vim.wo[state.win].cursorline = false
  vim.wo[state.win].number = false
  vim.wo[state.win].relativenumber = false
  vim.wo[state.win].signcolumn = "no"
  vim.wo[state.win].foldcolumn = "0"

  refresh_git()
  render()
end

function M.close()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
  end
  if state.buf and vim.api.nvim_buf_is_valid(state.buf) then
    vim.api.nvim_buf_delete(state.buf, { force = true })
    state.buf = nil
  end
end

function M.toggle()
  if state.win and vim.api.nvim_win_is_valid(state.win) then
    M.close()
  else
    M.open()
  end
end

local augroup = vim.api.nvim_create_augroup("breadcrumbs", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup,
  once = true,
  callback = function()
    vim.schedule(function()
      if AUTO_OPEN then
        M.open()
      else
        ensure_buf()
        refresh_git()
        render()
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  callback = function(ev)
    if ev.buf == state.buf then return end
    if vim.bo[ev.buf].buftype == "" then
      render()
      schedule_git_refresh()
    end
  end,
})

vim.keymap.set("n", "<leader>to", function() M.toggle() end, { desc = "Toggle Breadcrumbs" })

return M
