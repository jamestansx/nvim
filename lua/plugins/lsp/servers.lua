local M = {}

M.lua_ls = {
	capabilities = vim.tbl_deep_extend("force", require("plugins.lsp.defaults").capabilities, {
		-- XXX: this is a fix to trigger diagnostics on start for files without .luarc.json
		-- as for some reason the file cannot be added to workspace_folder
		workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
	}),
}

return M
