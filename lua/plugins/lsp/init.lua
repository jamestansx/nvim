return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile", "FileType" },
		config = function()
			for server, opts in pairs(require("plugins.lsp.servers")) do
				opts = vim.tbl_extend("force", require("plugins.lsp.defaults"), opts)
				require("lspconfig")[server].setup(opts)
			end
		end,
	},
	{
		"j-hui/fidget.nvim",
		tag = "legacy",
		event = "LspAttach",
		opts = {
			text = { spinner = "dots" },
			window = {
				blend = 0,
				relative = "editor",
			},
			timer = {
				fidget_decay = 300,
				task_decay = 300,
			},
		},
	},
}
