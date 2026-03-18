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

# ---- LSP (lsp_cmd) ----

echo ""
echo "--- lsp (lsp_cmd) ---"

run_test "lsp_cmd setup runs without errors" \
    nvim_lua "
        require('fga').setup({ lsp_cmd = { 'openfga-lsp', '--stdio' } })
    "

run_test "lsp_cmd: config is registered" \
    nvim_lua "
        require('fga').setup({ lsp_cmd = { 'openfga-lsp', '--stdio' } })
        local config = vim.lsp.config['openfga']
        assert(config, 'openfga config not found in vim.lsp.config')
    "

run_test "lsp_cmd: has correct cmd" \
    nvim_lua "
        require('fga').setup({ lsp_cmd = { 'openfga-lsp', '--stdio' } })
        local config = vim.lsp.config['openfga']
        assert(config.cmd[1] == 'openfga-lsp', 'expected openfga-lsp, got: ' .. tostring(config.cmd[1]))
        assert(config.cmd[2] == '--stdio', 'expected --stdio, got: ' .. tostring(config.cmd[2]))
    "

run_test "lsp_cmd: has correct filetypes" \
    nvim_lua "
        require('fga').setup({ lsp_cmd = { 'openfga-lsp', '--stdio' } })
        local config = vim.lsp.config['openfga']
        assert(config.filetypes[1] == 'fga', 'expected fga filetype, got: ' .. tostring(config.filetypes[1]))
    "

# ---- LSP (deprecated lsp_server) ----

echo ""
echo "--- lsp (deprecated lsp_server) ---"

run_test "lsp_server still works (backwards compat)" \
    nvim_lua "
        require('fga').setup({ lsp_server = '/tmp/fake-server.js' })
        local config = vim.lsp.config['openfga']
        assert(config, 'openfga config not found')
        assert(config.cmd[1] == 'node', 'expected node, got: ' .. tostring(config.cmd[1]))
        assert(config.cmd[2] == '/tmp/fake-server.js', 'expected server path, got: ' .. tostring(config.cmd[2]))
        assert(config.cmd[3] == '--stdio', 'expected --stdio, got: ' .. tostring(config.cmd[3]))
    "

run_test "lsp_cmd takes precedence over lsp_server" \
    nvim_lua "
        require('fga').setup({ lsp_cmd = { 'my-lsp', '--stdio' }, lsp_server = '/tmp/ignored.js' })
        local config = vim.lsp.config['openfga']
        assert(config.cmd[1] == 'my-lsp', 'expected lsp_cmd to win, got: ' .. tostring(config.cmd[1]))
    "

run_test "no error when neither lsp option is set" \
    nvim_lua "
        require('fga').setup({})
    "

# ---- Summary ----

echo ""
echo "=== Results: $PASS passed, $FAIL failed ==="
[ "$FAIL" -eq 0 ] || exit 1
