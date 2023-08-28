local M = {}

local function remove_doc(res)
	if res == nil then return res end
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

-- TODO: show all available signatures for function overload
M.signature_help = function(_, result, ctx, config)
	local bufnr, winid = vim.lsp.handlers.signature_help(_, remove_doc(result), ctx, config)
	if winid then vim.api.nvim_win_set_config(winid, make_floating_popup_option(winid)) end

	return bufnr, winid
end

return M
