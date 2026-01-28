vim.cmd("syntax clear")

-- Keywords and types
vim.cmd("syntax keyword fgaKeyword type relations define module model schema from")
vim.cmd("syntax keyword fgaType and or")
vim.cmd('syntax match fgaType "but not"')

-- Define statements (word being defined as function)
vim.cmd('syntax match fgaDefineWord "\\vdefine \\zs\\w+\\ze:"')

-- Operators and delimiters
vim.cmd('syntax match fgaOperator ":"')
vim.cmd('syntax match fgaDelimiter "[\\[\\](),]"')

-- Comments
vim.cmd('syntax match fgaComment " #.*$"')
vim.cmd('syntax match fgaComment "^#.*$"')

vim.api.nvim_set_hl(0, "fgaKeyword", { link = "Keyword", default = true })
vim.api.nvim_set_hl(0, "fgaType", { link = "Type", default = true })
vim.api.nvim_set_hl(0, "fgaOperator", { link = "Operator", default = true })
vim.api.nvim_set_hl(0, "fgaDefineWord", { link = "Function", default = true })
vim.api.nvim_set_hl(0, "fgaDelimiter", { link = "Delimiter", default = true })
vim.api.nvim_set_hl(0, "fgaComment", { link = "Comment", default = true })
