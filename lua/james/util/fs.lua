local M = {}

---Compute root directory of path given based on pattern given
---@param fpath string?
---@param patterns table
---@param upward boolean
---@return string?
function M.find_pattern_ancestor(fpath, patterns, upward)
	local dirpath = vim.fs.dirname(fpath)
	local root = vim.fs.find(patterns, {
		path = dirpath,
		upward = upward,
	})[1]

	if root and vim.loop.fs_stat(root) then return vim.fs.dirname(root) end
end

---Compute python executable path based on:
---- environment vaiable
---- scan for venv folder pattern in upward direction
---- fallback to system executable
---@param workspace string?
---@param opts table?
---@return string
function M.find_python_path(workspace, opts)
	local default_opts = { venv_patterns = { "venv", ".venv" } }
	opts = vim.tbl_deep_extend("force", default_opts, opts or {})

	workspace = workspace or vim.api.nvim_buf_get_name(0)
	workspace = vim.loop.fs_realpath(workspace)

	-- environment variable
	local env_var = vim.env.VIRTUAL_ENV
	if env_var then return M.join(env_var, "bin", "python") end

	-- TODO: should I scan downward too?
	-- scan for venv folder pattern in upward direction
	local result = M.find_pattern_ancestor(workspace, { opts.venv_patterns }, true)
	if result then return M.join(result, "bin", "python") end

	-- fallback
	return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

function M.join(...)
	local path_sep = jit and (jit.os == "Windows" and "\\" or "/") or "/"
	return table.concat(vim.tbl_flatten({ ... }), path_sep)
end

return M
