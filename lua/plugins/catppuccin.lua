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
			all = function(colors)
				local U = require("catppuccin.utils.colors")
				local C = require("catppuccin.palettes").get_palette(vim.g.catppuccin_flavour)
				return {
					["@lsp.type.comment.lua"] = {}, -- don't override treesitter url highlight
				}
			end,
		},
		integrations = {
			notify = true,
			native_lsp = {
				enabled = true,
				underlines = { errors = { "undercurl" } },
			},
		},
	},
}
