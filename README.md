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
        -- lsp_cmd = { "node", "/path/to/vscode-ext/server/out/server.node.js", "--stdio" },
    },
}
```

## Tree-sitter

Requires Neovim >= 0.9. The parser is compiled and cached automatically on first use (requires `git` and a C compiler).

```lua
opts = {
    install_treesitter_grammar = true,
}
```

Uses [matoous/tree-sitter-fga](https://github.com/matoous/tree-sitter-fga).

> **Note:** On Neovim < 0.9, basic syntax highlighting via `syntax/fga.lua` is
> still available without tree-sitter.

## LSP

On Neovim >= 0.11, LSP works natively with no extra plugins. On older versions,
[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) is required.

The LSP server comes from the [OpenFGA VSCode extension](https://github.com/openfga/vscode-ext):

```bash
git clone https://github.com/openfga/vscode-ext
cd vscode-ext
npm install && npm run compile
```

Then point to it with `lsp_cmd`:

```lua
opts = {
    lsp_cmd = { "node", "/path/to/vscode-ext/server/out/server.node.js", "--stdio" },
}
```

If you have the server available as an executable on your `$PATH`, you can pass it directly:

```lua
opts = {
    lsp_cmd = { "openfga-lsp", "--stdio" },
}
```

## License

MIT
