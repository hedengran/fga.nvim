# fga.nvim

Neovim plugin for OpenFGA modeling language support.

## Features

- Adds `.fga` as a file type
- Comment/uncomment lines with "gcc"
- Basic syntax highlighting for `.fga` files
- Optional automatic installation of TreeSitter grammar for OpenFGA ([matoous/tree-sitter-fga](https://github.com/matoous/tree-sitter-fga))
- Optional LSP integration

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "hedengran/fga.nvim",
    dependencies = {
        "neovim/nvim-lspconfig", -- Optional, for LSP integration
        "nvim-treesitter/nvim-treesitter", -- Optional, for enhanced syntax highlighting
    },
    config = function()
        require("fga").setup({
            install_treesitter_grammar = true,
            lsp_server = "/path/to/vscode-ext/server/out/server.node.js",
        })
    end,
}
```

## LSP Server Setup

To setup the LSP server:

1. Clone the OpenFGA VSCode extension:
```bash
git clone https://github.com/openfga/vscode-ext
cd vscode-ext
```

2. Install dependencies and build:
```bash
npm install
npm run compile
```

3. The LSP server will be available at `vscode-ext/server/out/server.node.js`

## Requirements

- `nvim-lspconfig` (optional) for LSP support
- `nvim-treesitter` (optional) for enhanced syntax highlighting

## Credits

- TreeSitter grammar by [matoous](https://github.com/matoous/tree-sitter-fga)
- LSP server from [OpenFGA VSCode Extension](https://github.com/openfga/vscode-ext)

## License

MIT License
