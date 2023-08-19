local M = {}

---Compute root directory of given filepath using pattern
---@param filepath string?
---@param pattern table?
---@return string?
function M.get_project_root(filepath, pattern)
	local _pattern = { ".git", ".editorconfig", unpack(pattern or {}) }

	filepath = filepath or vim.api.nvim_buf_get_name(0)
	filepath = vim.loop.fs_realpath(filepath)
	filepath = filepath and vim.fs.dirname(filepath) or vim.loop.cwd()

	local root = vim.fs.find(_pattern, {
		path = filepath,
		upward = true,
	})[1]

	if root and vim.loop.fs_stat(root) then return vim.fs.dirname(root) end
end

-- Compute python executable path based on:
-- - environment variable
-- - root pattern of `pyvenv.cfg`
-- - fallback to system executable
function M.get_python_path(filepath)
	-- environment variable
	local env_var = vim.env.VIRTUAL_ENV
	if env_var then return M.join(env_var, "bin", "python") end

	-- root pattern of `pyvenv.cfg`
	local homedir = vim.loop.os_homedir()
	local result = vim.fs.find("pyvenv.cfg", {
		path = M.get_project_root(filepath),
		stop = homedir,
		upward = false,
	})[1]
	if result then return M.join(vim.fs.dirname(result), "bin", "python") end

	-- fallback
	return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

---Convert table to path-like string
---@return string
function M.join(...) return table.concat(vim.tbl_flatten({ ... }), "/") end

return M
