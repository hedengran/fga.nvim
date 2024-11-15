local M = {}

local function install_treesitter_grammer()
	-- Ensure Tree-sitter is available
	if not pcall(require, "nvim-treesitter") then
		vim.notify("nvim-treesitter not installed", vim.log.levels.ERROR)
		return
	end

	-- Register the parser
	local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
	if not parser_config.fga then
		parser_config.fga = {
			install_info = {
				url = "https://github.com/matoous/tree-sitter-fga",
				files = { "src/parser.c" },
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "fga",
		}
	end

	-- Use plugin-specific directory under data path
	local plugin_path = vim.fn.stdpath("data") .. "/fga-nvim"
	local queries_path = plugin_path .. "/queries/fga"
	vim.fn.mkdir(queries_path, "p")

	-- Download and set up the highlights query
	local highlights_url = "https://raw.githubusercontent.com/matoous/tree-sitter-fga/master/queries/highlights.scm"
	local highlights_path = queries_path .. "/highlights.scm"

	-- Download highlights.scm if it doesn't exist
	if vim.fn.filereadable(highlights_path) == 0 then
		vim.fn.system({
			"curl",
			"-fLo",
			highlights_path,
			"--create-dirs",
			highlights_url,
		})
	end

	-- Add the plugin path to runtimepath so Neovim can find queries/fga/highlights.scm
	vim.opt.runtimepath:append(plugin_path)
end

function M.setup(opts)
	opts = opts or {}

	install_treesitter_grammer()
end

return M
