local M = {}

function M.setup(opts)
	opts = opts or {}

	-- Set up filetype detection
	vim.filetype.add({
		extension = {
			fga = "fga",
		},
	})

	if opts.install_treesitter_grammar then
		require("fga.treesitter").setup()
	end

	if opts.lsp_server then
		require("fga.lsp").setup(opts)
	end
end

return M
