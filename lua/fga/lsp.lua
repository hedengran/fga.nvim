local M = {}

local function nvim_at_least(major, minor)
	return vim.fn.has("nvim-" .. major .. "." .. minor) == 1
end

local function resolve_cmd(opts)
	if opts.lsp_cmd then
		return opts.lsp_cmd
	end

	-- Deprecated: lsp_server option
	if opts.lsp_server then
		vim.notify(
			"fga.nvim: `lsp_server` is deprecated, use `lsp_cmd` instead.\n"
				.. '  lsp_cmd = { "node", "/path/to/server.node.js", "--stdio" }',
			vim.log.levels.WARN
		)
		return { "node", opts.lsp_server, "--stdio" }
	end

	return nil
end

local function setup_native(cmd)
	vim.lsp.config("openfga", {
		cmd = cmd,
		filetypes = { "fga" },
		root_markers = { ".git" },
	})
	vim.lsp.enable("openfga")
end

local function setup_legacy(cmd)
	if not pcall(require, "lspconfig") then
		vim.notify("fga.nvim: lspconfig not installed (required for LSP on Neovim < 0.11)", vim.log.levels.ERROR)
		return
	end

	local configs = require("lspconfig.configs")
	local util = require("lspconfig.util")

	if not configs.openfga then
		configs.openfga = {
			default_config = {
				cmd = cmd,
				filetypes = { "fga" },
				root_dir = util.find_git_ancestor,
				single_file_support = true,
				settings = {},
			},
		}
	end
	configs.openfga.setup({})
end

function M.setup(opts)
	opts = opts or {}

	local cmd = resolve_cmd(opts)
	if not cmd then
		return
	end

	if nvim_at_least(0, 11) then
		setup_native(cmd)
	else
		setup_legacy(cmd)
	end
end

return M
