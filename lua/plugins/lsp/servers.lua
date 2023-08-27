local M = {}

M.lua_ls = {
	capabilities = vim.tbl_deep_extend("force", require("plugins.lsp.defaults").capabilities, {
		workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
	}),
}

return M
