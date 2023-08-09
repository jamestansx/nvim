local M = {}

-- Compute python executable path based on:
-- - environment variable
-- - root patterns by traversing directory upward and downward
-- - fallback to system executable
function M.get_python_path(workspace, pattern)
	local _pattern = { "pyvenv.cfg", "venv", ".venv" }

	-- environment variable
	local env_var = vim.env.VIRTUAL_ENV
	if env_var then return M.join(env_var, "bin", "python") end

	-- patterns by traversing directory upward and downward
	pattern = pattern or _pattern
	workspace = vim.loop.fs_realpath(workspace or vim.loop.cwd())
	local homedir = vim.loop.os_homedir()
	for i = 1, 2 do
		local result = vim.fs.find(pattern, {
			path = workspace,
			stop = homedir,
			upward = i == 1, -- search upward first
		})[1]
		if result then
			return M.join(vim.fn.isdirectory(result) == 1 and result or vim.fs.dirname(result), "bin", "python")
		end
	end

	-- fallback
	return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

-- I don't care about `Windows`
function M.join(...) return table.concat(vim.tbl_flatten({ ... }), "/") end

return M
