local M = {}

function M.on_attach(_, bufnr)
	-- Resolve keymap capabilities over all buffer clients
	-- https://github.com/LazyVim/LazyVim/blob/566049aa4a26a86219dd1ad1624f9a1bf18831b6/lua/lazyvim/plugins/lsp/keymaps.lua#L69
	local function has(method)
		local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
		for _, c in ipairs(clients) do
			if c.supports_method(method) then return true end
		end
		return false
	end

	local function map(mode, lhs, rhs, opts)
		if opts.has and not has(opts.has) then return end
		opts.has = nil
		opts.silent = opts.silent ~= false
		opts.noremap = true
		opts.buffer = bufnr
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	-- stylua: ignore start
	map("n", "gd", vim.lsp.buf.definition, { has = "textDocument/definition", desc = "[G]oto [D]efinition" })
	map("n", "gr", vim.lsp.buf.references, { has = "textDocument/references", desc = "[G]oto [R]eferences" })
	map("n", "gI", vim.lsp.buf.implementation, { has = "textDocument/implementation", desc = "[G]oto [I]mplementation" })
	map("n", "gD", vim.lsp.buf.type_definition, { has = "textDocument/typeDefinition", desc = "[G]oto Type [D]efinition" })

	map("n", "<leader>ds", vim.lsp.buf.document_symbol, { has = "textDocument/documentSymbol", desc = "[D]ocument [S]ymbols" })
	map("n", "<leader>ws", vim.lsp.buf.workspace_symbol, { has = "workspace/symbol", desc = "[W]orkspace [S]ymbols" })

	map("n", "K", vim.lsp.buf.hover, { has = "textDocument/hover", desc = "Hover Documentation" })
	map({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, { has = "textDocument/signatureHelp", desc = "Signature Documentation" })

	map("n", "<leader>ca", vim.lsp.buf.code_action, { has = "textDocument/codeAction", desc = "[C]ode [A]ction" })
	map("n", "<leader>cr", vim.lsp.buf.rename, { has = "textDocument/rename", desc = "[C]ode [R]ename" })
	map("n", "<leader>cf", vim.lsp.buf.format, { has = "textDocument/formatting", desc = "[C]ode [F]ormat" })
	-- stylua: ignore end
end

return M
