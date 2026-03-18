local M = {}

local REPO_URL = "https://github.com/matoous/tree-sitter-fga"
local HIGHLIGHTS_URL =
	"https://raw.githubusercontent.com/matoous/tree-sitter-fga/main/queries/highlights.scm"

local function nvim_at_least(major, minor)
	return vim.fn.has("nvim-" .. major .. "." .. minor) == 1
end

--- Clone tree-sitter-fga and compile the parser .so, cached under stdpath("data").
local function ensure_parser()
	local parser_dir = vim.fn.stdpath("data") .. "/fga-nvim/parser"
	local parser_so = parser_dir .. "/fga.so"
	if vim.fn.filereadable(parser_so) == 1 then
		return parser_dir
	end

	vim.fn.mkdir(parser_dir, "p")
	local tmp = vim.fn.tempname()

	local clone_out = vim.fn.system({ "git", "clone", "--depth", "1", REPO_URL, tmp })
	if vim.v.shell_error ~= 0 then
		vim.notify("fga.nvim: failed to clone tree-sitter-fga:\n" .. clone_out, vim.log.levels.ERROR)
		return nil
	end

	local cc = vim.env.CC or "cc"
	local compile_out = vim.fn.system({
		cc,
		"-o",
		parser_so,
		"-shared",
		tmp .. "/src/parser.c",
		"-I" .. tmp .. "/src",
		"-Os",
	})
	vim.fn.delete(tmp, "rf")

	if vim.v.shell_error ~= 0 then
		vim.notify("fga.nvim: failed to compile parser:\n" .. compile_out, vim.log.levels.ERROR)
		return nil
	end

	return parser_dir
end

local function setup_highlights()
	local plugin_path = vim.fn.stdpath("data") .. "/fga-nvim"
	local queries_path = plugin_path .. "/queries/fga"
	vim.fn.mkdir(queries_path, "p")

	local highlights_path = queries_path .. "/highlights.scm"
	if vim.fn.filereadable(highlights_path) == 0 then
		vim.fn.system({
			"curl",
			"-fLo",
			highlights_path,
			"--create-dirs",
			HIGHLIGHTS_URL,
		})
		if vim.v.shell_error ~= 0 then
			vim.notify("fga.nvim: failed to download highlights.scm", vim.log.levels.WARN)
		end
	end

	vim.opt.runtimepath:append(plugin_path)
end

function M.setup()
	if not nvim_at_least(0, 9) then
		vim.notify(
			"fga.nvim: tree-sitter support requires Neovim >= 0.9. "
				.. "Basic syntax highlighting via syntax/fga.lua is still available.",
			vim.log.levels.WARN
		)
		return
	end

	vim.treesitter.language.register("fga", "fga")

	-- Skip compilation if the parser is already available (e.g. installed via :TSInstall)
	local has_parser = pcall(vim.treesitter.language.add, "fga")
	if not has_parser then
		local parser_dir = ensure_parser()
		if parser_dir then
			vim.opt.runtimepath:append(vim.fs.dirname(parser_dir))
		end
	end

	setup_highlights()
end

return M
