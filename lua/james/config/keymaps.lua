vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = function(mode, lhs, rhs, opts)
	opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
	vim.keymap.set(mode, lhs, rhs, opts)
end

local function goto_diagnostic(direction, level)
	return function() vim.diagnostic["goto_" .. direction]({ severity = vim.diagnostic.severity[level] }) end
end

-- why not?
map({ "n", "v" }, "<Space>", "<Nop>")

-- smart j k
map({ "n", "v" }, "j", "v:count || mode(1)[0:1] == 'no' ? 'j': 'gj'", { expr = true })
map({ "n", "v" }, "k", "v:count || mode(1)[0:1] == 'no' ? 'k': 'gk'", { expr = true })

-- join line without moving cursor
map("n", "J", "mzJ`z")

-- everything should be centered
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "*", "*zzzv")
map("n", "#", "#zzzv")
map("n", "g*", "g*zzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- keep text selected after indentation
map("x", ">", ">gv")
map("x", "<", "<gv")

-- https://github.com/mhinz/vim-galore#saner-command-line-history
map(
	"c",
	"<C-n>",
	function() return vim.fn.wildmenumode() == 1 and "<C-n>" or "<Down>" end,
	{ expr = true, silent = false }
)
map(
	"c",
	"<C-p>",
	function() return vim.fn.wildmenumode() == 1 and "<C-p>" or "<Up>" end,
	{ expr = true, silent = false }
)

-- use the home row keys!!!!!
map("", "<Up>", "<Nop>")
map("", "<Down>", "<Nop>")
map("", "<Left>", "<Nop>")
map("", "<Right>", "<Nop>")

-- file explorer
map("n", "<C-p>", vim.cmd.Ex)

-- buffers
map("n", "<leader><leader>", "<C-^>")

-- select pasted text
map("n", "<leader>gp", "`[v`]", { desc = "Select the pasted text" })

-- diagnostic
map("n", "<leader>df", vim.diagnostic.open_float, { desc = "[D]iagnostic [F]loat" })
map("n", "<leader>dn", vim.diagnostic.goto_prev, { desc = "Goto [P]revious [D]iagnostic" })
map("n", "<leader>dp", vim.diagnostic.goto_next, { desc = "Goto [N]ext [D]iagnostic" })
map("n", "[e", goto_diagnostic("prev", "ERROR"), { desc = "Goto previous [E]rror" })
map("n", "]e", goto_diagnostic("next", "ERROR"), { desc = "Goto next [E]rror" })
map("n", "[w", goto_diagnostic("prev", "WARN"), { desc = "Goto previous [W]arn" })
map("n", "]w", goto_diagnostic("next", "WARN"), { desc = "Goto next [W]arn" })
