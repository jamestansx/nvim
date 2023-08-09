---:help command-preview
local function trim_space_preview(opts, preview_ns, preview_buf)
	local line1 = opts.line1
	local line2 = opts.line2
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
	local preview_buf_line = 0

	for i, line in ipairs(lines) do
		local start_idx, end_idx = string.find(line, "%s+$")
		if start_idx then
			vim.api.nvim_buf_add_highlight(buf, preview_ns, "Substitute", line1 + i - 2, start_idx - 1, end_idx)

			-- Add lines and set highlights in the preview buffer if inccommand=split
			if preview_buf then
				local prefix = string.format("|%d| ", line1 + i - 1)
				vim.api.nvim_buf_set_lines(preview_buf, preview_buf_line, preview_buf_line, false, { prefix .. line })
				vim.api.nvim_buf_add_highlight(
					preview_buf,
					preview_ns,
					"Substitute",
					preview_buf_line,
					#prefix + start_idx - 1,
					#prefix + end_idx
				)
				preview_buf_line = preview_buf_line + 1
			end
		end
	end

	return 2
end

-- :help command-preview
local function trim_space(opts)
	local line1 = opts.line1
	local line2 = opts.line2
	local buf = vim.api.nvim_get_current_buf()
	local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)

	local new_lines = {}
	for i, line in ipairs(lines) do
		new_lines[i] = string.gsub(line, "%s+$", "")
	end
	vim.api.nvim_buf_set_lines(buf, line1 - 1, line2, false, new_lines)
end

local M = {}

-- delay notifications till vim.notify was replaced or after 500ms
-- https://github.com/LazyVim/LazyVim/blob/566049aa4a26a86219dd1ad1624f9a1bf18831b6/lua/lazyvim/util/init.lua#L219
function M.lazy_notify()
	local notifs = {}
	local function temp(...) table.insert(notifs, vim.F.pack_len(...)) end

	local orig = vim.notify
	vim.notify = temp

	local timer = vim.loop.new_timer()
	local check = vim.loop.new_check()

	local replay = function()
		timer:stop()
		check:stop()
		if vim.notify == temp then
			vim.notify = orig -- put back the original notify if needed
		end
		vim.schedule(function()
			---@diagnostic disable-next-line: no-unknown
			for _, notif in ipairs(notifs) do
				vim.notify(vim.F.unpack_len(notif))
			end
		end)
	end

	-- wait till vim.notify has been replaced
	check:start(function()
		if vim.notify ~= temp then replay() end
	end)
	-- or if it took more than 500ms, then something went wrong
	timer:start(500, 0, replay)
end

---create autocommand with auto augroup creation
---@param event string | table
---@param opts table
function M.create_autocmd(event, opts)
	if opts.group and vim.fn.exists("#" .. opts.group) == 0 then
		vim.api.nvim_create_augroup(opts.group, { clear = true })
	end
	vim.api.nvim_create_autocmd(event, opts)
end

-- trims all trailing white-space in the current buffer.
M.trim_white_space = vim.api.nvim_create_user_command(
	"TrimTrailingWhitespace",
	trim_space,
	{ nargs = "?", range = "%", addr = "lines", preview = trim_space_preview }
)

return M
