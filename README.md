# fga.nvim

Neovim support for [OpenFGA](https://openfga.dev/) authorization models (`.fga` files).

## Features

- Filetype detection
- Syntax highlighting (basic vim syntax, or tree-sitter)
- LSP support (diagnostics, hover, etc.)
- Comment toggling (`gcc`)

## Installation

```lua
-- lazy.nvim
{
    "hedengran/fga.nvim",
    opts = {
        -- install_treesitter_grammar = true,
        -- lsp_server = "/path/to/vscode-ext/server/out/server.node.js",
    },
}
```

## Tree-sitter

Requires [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter).

```lua
opts = {
    install_treesitter_grammar = true,
}
```

Then run `:TSInstall fga` after the plugin loads.

Uses [matoous/tree-sitter-fga](https://github.com/matoous/tree-sitter-fga).

## LSP

Requires [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig).

The LSP server comes from the [OpenFGA VSCode extension](https://github.com/openfga/vscode-ext):

```bash
git clone https://github.com/openfga/vscode-ext
cd vscode-ext
npm install && npm run compile
```

Then point to it:

```lua
opts = {
    lsp_server = "/path/to/vscode-ext/server/out/server.node.js",
}
```

## License

MIT
