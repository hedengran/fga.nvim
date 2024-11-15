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

-- Link to standard highlighting groups
local links = {
	fgaKeyword = "Keyword",
	fgaType = "Type",
	fgaOperator = "Operator",
	fgaDefineWord = "Function",
	fgaDelimiter = "Delimiter",
	fgaComment = "Comment",
}

for from, to in pairs(links) do
	vim.cmd(string.format("highlight default link %s %s", from, to))
end
