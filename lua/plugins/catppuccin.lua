vim.g.catppuccin_flavour = "mocha"

return {
	"catppuccin/nvim",
	name = "catppuccin",
	lazy = false,
	priority = 1000,
	init = function() vim.cmd.colorscheme("catppuccin") end,
	opts = {
		term_colors = true,
		transparent_background = true,
		highlight_overrides = {
			all = function(colors) return {} end,
		},
		integrations = {
			notify = true,
		},
	},
}
