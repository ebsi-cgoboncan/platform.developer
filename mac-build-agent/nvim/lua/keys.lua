vim.keymap.set('i', 'jk', '<Esc>')
vim.keymap.set('n', ';', ':')
vim.keymap.set('n', '<esc>', ':noh<return><esc>')

-- undo in insert mode
vim.keymap.set('i', '<c-z>', '<c-o>u')

-- navigating windows
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-l>', '<c-w>l')

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('n', 'Q', '<nop>')
