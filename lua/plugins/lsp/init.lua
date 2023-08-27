return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile", "FileType" },
	config = function()
		for server, opts in pairs(require("plugins.lsp.servers")) do
			opts = vim.tbl_extend("force", require("plugins.lsp.defaults"), opts)
			require("lspconfig")[server].setup(opts)
		end
	end,
}
