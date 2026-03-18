#!/bin/bash
set -e

PASS=0
FAIL=0

run_test() {
    local name="$1"
    shift
    printf "%-60s" "$name"
    if output=$("$@" 2>&1); then
        echo "PASS"
        PASS=$((PASS + 1))
    else
        echo "FAIL"
        echo "  $output"
        FAIL=$((FAIL + 1))
    fi
}

nvim_lua() {
    nvim --headless --clean \
        -c "set runtimepath+=." \
        -c "lua $1" \
        -c "q"
}

echo "=== fga.nvim test suite ==="
echo ""

# ---- Filetype ----

echo "--- filetype ---"

run_test "filetype detection for .fga files" \
    nvim_lua "
        require('fga').setup({})
        vim.cmd('edit /tmp/test.fga')
        assert(vim.bo.filetype == 'fga', 'expected fga filetype, got: ' .. vim.bo.filetype)
    "

# ---- LSP ----

echo ""
echo "--- lsp ---"

run_test "lsp setup runs without errors (native)" \
    nvim_lua "
        require('fga').setup({ lsp_server = '/tmp/fake-server.js' })
    "

run_test "openfga lsp config is registered" \
    nvim_lua "
        require('fga').setup({ lsp_server = '/tmp/fake-server.js' })
        local config = vim.lsp.config['openfga']
        assert(config, 'openfga config not found in vim.lsp.config')
    "

run_test "openfga config has correct filetypes" \
    nvim_lua "
        require('fga').setup({ lsp_server = '/tmp/fake-server.js' })
        local config = vim.lsp.config['openfga']
        assert(config.filetypes[1] == 'fga', 'expected fga filetype, got: ' .. tostring(config.filetypes[1]))
    "

run_test "openfga config has correct cmd" \
    nvim_lua "
        require('fga').setup({ lsp_server = '/tmp/fake-server.js' })
        local config = vim.lsp.config['openfga']
        assert(config.cmd[1] == 'node', 'expected node, got: ' .. tostring(config.cmd[1]))
        assert(config.cmd[2] == '/tmp/fake-server.js', 'expected server path, got: ' .. tostring(config.cmd[2]))
        assert(config.cmd[3] == '--stdio', 'expected --stdio, got: ' .. tostring(config.cmd[3]))
    "

run_test "no error when lsp_server is not set" \
    nvim_lua "
        require('fga').setup({})
    "

# ---- Summary ----

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] || exit 1
