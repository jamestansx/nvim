local o = vim.opt
local autocmd = require("james.utils").editor.create_autocmd

--misc
o.exrc = true
o.virtualedit = "block"

-- general UI setting
o.number = true
o.relativenumber = true
o.termguicolors = true
o.title = true
o.laststatus = 3
o.signcolumn = "yes" -- TODO: should I set it to constant?
o.showtabline = 1

-- mouse be good
o.mouse = "a"
o.mousemodel = "extend"

-- conceal option
o.conceallevel = 2
o.concealcursor = "nc" -- same as help page setting

-- highlight me!
o.cursorline = true
o.showmatch = true
o.matchtime = 3
o.hlsearch = true
o.synmaxcol = 300

-- confirm
o.confirm = true
o.autowriteall = true

-- spelling
o.spelllang = { "en", "cjk" }
o.spelloptions = { "camel" }
o.spellsuggest = "best,5"

-- scroll offset
o.scrolloff = 3
o.sidescrolloff = 3

-- smart indentation
o.cindent = true
o.expandtab = false
o.autoindent = true
o.smartindent = true
o.shiftround = true

-- smart wrap
o.wrap = true
o.breakindent = true
o.linebreak = true
o.showbreak = "↪ "
o.breakat = [[ ,]]

-- format option
autocmd({ "BufEnter" }, {
	desc = "Set global format options",
	group = "GlobalFormatOptions",
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions = {
			c = true, -- wrap comment using TextWidth
			q = true, -- allow formatting comment with "gq"
			r = true, -- continue comment when pressing enter
			n = true, -- detect list for formatting
			j = true, -- auto remove comments if possible
		}
	end,
})

-- quick timeout
o.timeoutlen = 500
o.updatetime = 250
o.redrawtime = 1000

-- hidden characters
o.list = true
o.listchars:append({
	space = "·",
	trail = "␣",
	tab = "  »",
	nbsp = "◻",
	extends = "→",
	precedes = "←",
	eol = "↲",
})

-- proper search
o.ignorecase = true
o.smartcase = true
o.incsearch = true

-- smart completion
o.complete:append({ "kspell" })
o.completeopt = { "menu", "menuone", "noselect" }
o.infercase = true

-- popup menus
o.pumblend = 10
o.winblend = 10
o.pumheight = 5 -- less is more

-- permanent undo list
o.undofile = true
o.undolevels = 100000

-- window sane split
o.splitbelow = true
o.splitright = true
o.splitkeep = "screen"

-- less cluttering
o.ruler = false
o.showmode = false
o.shortmess:append("WIcs") -- write file, intro message, ins-completion message, search notice

-- decent WildMenu
o.wildmode = { "longest:full", "full" }
o.wildoptions:append({ "fuzzy" })
o.wildignorecase = true
o.wildignore:append({ ".git", ".hg", ".svn" }) -- version control
o.wildignore:append({ "*.swp", "*.lock" }) -- lock file
o.wildignore:append({ "*.pyc", "*.pycache" }) -- python
o.wildignore:append({ "**/node_modules/**" }) -- JavaScript
o.wildignore:append({ "*.o", "*.out", "*.obj" }) -- executable
o.wildignore:append({ "*.bmp", "*.gif", "*.ico", "*.png", "*.jpeg", "*.webp" }) -- picture
o.wildignore:append({ "*.mkv", "*.mov", "*.mp4", "*.webm", "*.webp" }) -- video
o.wildignore:append({ "*.mp3", "*.wav" }) -- song
o.wildignore:append({ "*.zip", "*.tar.gz", "*.tar.bz2", "*.tar.xz" }) -- zip
o.wildignore:append({ "*.doc", "*.docx", "*.pdf", "*.pptx" }) -- document
o.wildignore:append({ "*.otf", "*.ttf", "*.woff" }) -- font

-- diff opts
o.diffopt:append({
	"iwhite",
	"hiddenoff",
	"linematch:60",
	"algorithm:histogram",
	"indent-heuristic",
})

-- folding
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true
o.foldmethod = "marker" -- TODO: TreeSitter?
o.fillchars:append({
	fold = " ",
	foldopen = "▽",
	foldsep = " ",
	foldclose = "▷",
})

-- grep
if vim.fn.executable("rg") then
	o.grepprg = "rg --vimgrep --no-heading --smart-case --hidden --glob '!.git'"
	o.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end

-- session restore
o.sessionoptions = { "buffers", "curdir", "folds", "tabpages", "terminal", "winsize" }
o.viewoptions = { "folds", "cursor", "curdir", "localoptions" }
o.jumpoptions = { "stack", "view" }

-- diagnostics
vim.diagnostic.config({
	virtual_text = { source = "if_many" },
	signs = true,
	severity_sort = true,
	update_in_insert = true,
})
