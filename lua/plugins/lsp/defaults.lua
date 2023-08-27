local M = {}

M.on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	require("plugins.lsp.keymaps").on_attach(client, bufnr)
end

M.capabilities = (function()
	return vim.lsp.protocol.make_client_capabilities()
end)()

return M
