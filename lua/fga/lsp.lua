local M = {}

local function nvim_at_least(major, minor)
	return vim.fn.has("nvim-" .. major .. "." .. minor) == 1
end

local function setup_native(opts)
	vim.lsp.config("openfga", {
		cmd = { "node", opts.lsp_server, "--stdio" },
		filetypes = { "fga" },
		root_markers = { ".git" },
	})
	vim.lsp.enable("openfga")
end

local function setup_legacy(opts)
	if not pcall(require, "lspconfig") then
		vim.notify("fga.nvim: lspconfig not installed (required for LSP on Neovim < 0.11)", vim.log.levels.ERROR)
		return
	end

	local configs = require("lspconfig.configs")
	local util = require("lspconfig.util")

	if not configs.openfga then
		configs.openfga = {
			default_config = {
				cmd = { "node", opts.lsp_server, "--stdio" },
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

	if nvim_at_least(0, 11) then
		setup_native(opts)
	else
		setup_legacy(opts)
	end
end

return M
