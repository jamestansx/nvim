local autocmd = require("james.util").create_autocmd

autocmd({ "TextYankPost" }, {
	desc = "Highlight text on yank",
	group = "HlTextYank",
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
})

autocmd({ "BufWritePre" }, {
	desc = "Create missing directories when saving file",
	group = "MkdirOnSave",
	pattern = "*",
	callback = function(args)
		if args.match:match("^%w+://") then return end -- skip if it is a url
		local file = vim.loop.fs_realpath(args.match) or args.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

autocmd({ "BufWritePre" }, {
	desc = "Trim whitespace before saving file",
	group = "TrimWhiteOnSave",
	pattern = "*",
	callback = function()
		if vim.b.editorconfig == nil then
			local view = vim.fn.winsaveview()
			vim.api.nvim_command("silent! undojoin")
			vim.api.nvim_command("silent keepjumps keeppatterns %s/\\s\\+$//e")
			vim.fn.winrestview(view)
		end
	end,
})

-- TODO: not sure if I ever need this?
-- autocmd({ "BufReadPost" }, {
-- 	desc = "Restore last loc when opening a buffer",
-- 	group = "RestoreLastLoc",
-- 	callback = function()
-- 		local mark = vim.api.nvim_buf_get_mark(0, '"')
-- 		local lcount = vim.api.nvim_buf_line_count(0)
-- 		if mark[1] > 0 and mark[1] <= lcount then pcall(vim.api.nvim_win_set_cursor, 0, mark) end
-- 	end,
-- })

autocmd({ "BufRead", "FileType" }, {
	desc = "Reset undo persistence on certain files",
	group = "NoUndoPersist",
	pattern = {
		-- path
		"/tmp/*",
		"*.tmp",
		"*.bak",

		-- filetype
		"gitcommit",
	},
	command = [[setlocal noundofile]],
})

autocmd({ "BufRead", "FileType" }, {
	desc = "Prevent accidental write to buffers that shouldn't be edited",
	group = "NoModify",
	pattern = {
		"*.orig",
		"*.pacnew",
	},
	command = [[setlocal nomodifiable]],
})

autocmd({ "WinLeave" }, {
	desc = "Toggle cursorline on switching window",
	group = "ToggleCursorLine",
	pattern = "*",
	callback = function(args)
		local cl = vim.wo.cursorline
		if cl then
			vim.api.nvim_win_set_var(0, "_toggleCursorLine", cl)
			vim.wo.cursorline = false
		end
	end,
})

autocmd({ "WinEnter" }, {
	desc = "Toggle cursorline on switching window",
	group = "ToggleCursorLine",
	pattern = "*",
	callback = function(args)
		local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "_toggleCursorLine")
		if ok and cl then
			vim.wo.cursorline = true
			vim.api.nvim_win_del_var(0, "_toggleCursorLine")
		end
	end,
})

-- TODO: use for all filetype that is only readable
autocmd({ "FileType" }, {
	desc = "Close certain filetypes with <q>",
	group = "FtKeymapQuit",
	pattern = {
		"checkhealth",
		"help",
		"lazy",
		"lspinfo",
		"man",
		"nofile",
		"notify",
		"prompt",
		"qf",
		"query",
		"startuptime",
		"tsplayground",
		"vim",
		"Navbuddy",
		"TelescopePrompt",
	},
	callback = function(args)
		vim.bo[args.buf].buflisted = false
		vim.api.nvim_buf_set_keymap(args.buf, "n", "q", "<CMD>close<CR>", { silent = true })
	end,
})

-- TODO: not sure if I need this?
autocmd({ "VimEnter" }, {
	desc = "Set CWD if argv is directory",
	group = "AutoCwd",
	pattern = "*",
	callback = function(args)
		-- TODO: should we also cd to file's directory?
		-- local dir = vim.fn.isdirectory(vim.fn.expand(args.file)) == 1 and args.file
		-- 	or vim.fn.fnamemodify(args.file, ":p:h")
		if vim.fn.isdirectory(vim.fn.expand(args.file)) == 0 then return end
		vim.api.nvim_set_current_dir(args.file)
	end,
})
