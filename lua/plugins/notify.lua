return {
	"rcarriga/nvim-notify",
	lazy = false,
	init = function() vim.notify = require("notify") end,
	opts = {
		fps = 60,
		render = "compact",
		stages = "slide",
		max_height = function() return math.floor(vim.o.lines * 0.6) end,
		max_width = function() return math.floor(vim.o.columns * 0.6) end,
		on_open = function(win) vim.api.nvim_win_set_option(win, "winblend", 0) end,
	},
}
