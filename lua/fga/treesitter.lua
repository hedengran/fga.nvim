local M = {}

local function install_treesitter_grammar()
	local ok, parsers = pcall(require, "nvim-treesitter.parsers")
	if not ok then
		vim.notify("fga.nvim: nvim-treesitter not installed", vim.log.levels.ERROR)
		return
	end

	local parser_config = parsers.get_parser_configs()
	if not parser_config.fga then
		parser_config.fga = {
			install_info = {
				url = "https://github.com/matoous/tree-sitter-fga",
				files = { "src/parser.c" },
				branch = "main",
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
	local highlights_url = "https://raw.githubusercontent.com/matoous/tree-sitter-fga/main/queries/highlights.scm"
	local highlights_path = queries_path .. "/highlights.scm"

	if vim.fn.filereadable(highlights_path) == 0 then
		local result = vim.fn.system({
			"curl",
			"-fLo",
			highlights_path,
			"--create-dirs",
			highlights_url,
		})
		if vim.v.shell_error ~= 0 then
			vim.notify("fga.nvim: failed to download highlights.scm", vim.log.levels.WARN)
		end
	end

	-- Add the plugin path to runtimepath so Neovim can find queries/fga/highlights.scm
	vim.opt.runtimepath:append(plugin_path)
end

function M.setup()
	install_treesitter_grammar()
end

return M
