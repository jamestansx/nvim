local M = {}

local function remove_doc(res)
	for i = 1, #res.signatures do
		if res.signatures[i] and res.signatures[i].documentation then
			if res.signatures[i].documentation.value then
				res.signatures[i].documentation.value = nil
			else
				res.signatures[i].documentation = nil
			end
		end
	end
	return res
end

local function make_floating_popup_option(winid)
	local win_config = vim.api.nvim_win_get_config(winid)

	local height = win_config.height
	local anchor = vim.split(win_config.anchor, "")
	local col = anchor[2] == "W" and 0 or 1
	local row

	-- only display below the cursor if float win can't
	-- fit the upper cursor
	if vim.fn.winline() <= height then
		anchor[1] = "N"
		row = 1
	else
		anchor[1] = "S"
		row = 0
	end

	return {
		relative = "cursor",
		anchor = table.concat(anchor, ""),
		col = col,
		row = row,
	}
end

-- adapted from neovim core:
-- https://github.com/neovim/neovim/blob/cffdf102d4f01fe5675c389eb80bf55daa62697a/runtime/lua/vim/lsp/handlers.lua#L446
M.signature_help = function(_, result, ctx, config)
	config = config or {}
	config.focus_id = ctx.method
	if vim.api.nvim_get_current_buf() ~= ctx.bufnr then return end
	if not (result and result.signatures and result.signatures[1]) then
		if config.silent ~= true then print("No signature help available") end
		return
	end
	local client = vim.lsp.get_client_by_id(ctx.client_id)
	local triggers = vim.tbl_get(client.server_capabilities, "signatureHelpProvider", "triggerCharacters")
	local ft = vim.api.nvim_buf_get_option(ctx.bufnr, "filetype")

	local hl = {}
	local lines = {}
	result = result and remove_doc(result)

	-- concat all available signatures
	for i = 0, #result.signatures - 1 do
		result.activeSignature = i
		local l, h = vim.lsp.util.convert_signature_help_to_markdown_lines(result, ft, triggers)
		l = vim.lsp.util.trim_empty_lines(l)
		if vim.tbl_isempty(l) and i == 0 then
			if config.silent ~= true then print("No signature help available") end
			return
		elseif not vim.tbl_isempty(l) then
			table.insert(lines, l)
			hl[i + 1] = h
		end
	end

	local fbuf, fwin = vim.lsp.util.open_floating_preview(vim.tbl_flatten(lines), "markdown", config)
	if hl then
		for i = 1, #hl do
			vim.api.nvim_buf_add_highlight(fbuf, -1, "LspSignatureActiveParameter", i - 1, unpack(hl[i]))
		end
	end
	if fwin then vim.api.nvim_win_set_config(fwin, make_floating_popup_option(fwin)) end
	return fbuf, fwin
end

return M
