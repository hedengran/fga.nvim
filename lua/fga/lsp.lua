local M = {}

function M.setup(opts)
	opts = opts or {}

	if not pcall(require, "lspconfig") then
		vim.notify("lspconfig is required not installed", vim.log.levels.ERROR)
		return
	end

	local configs = require("lspconfig.configs")
	local util = require("lspconfig.util")

	if not configs.openfga then
		configs.openfga = {
			default_config = {
				cmd = { "node", opts.lsp_server, "--stdio" },
				filetypes = { "fga" },
				root_dir = function(fname)
					return util.find_git_ancestor(fname)
				end,
				settings = {},
			},
		}
	end
	configs.openfga.setup({})
end

return M
