local g = vim.g
local o = vim.o
local bo = vim.bo
local wo = vim.wo

-- global variables
g.base16colorspace = 256
g.cursorhold_updatetime = 100
g.laststatus = 3

-- global options
o.backspace = 'indent,eol,start'
o.completeopt = 'menu,menuone,noselect'
o.hidden = true
o.belloff = 'all'
o.ignorecase = true
o.mouse = 'a'
o.showmode = false
o.smarttab = false
o.showmatch = true
o.smartcase = true
o.updatetime = 300
o.fillchars = 'vert:┃'
o.fcs = 'eob: '
o.clipboard = 'unnamed'
o.background = 'dark'
o.termguicolors = true
o.foldlevelstart = 20
o.expandtab = true
o.tabstop = 2
o.shiftwidth = o.tabstop

-- buffer options
bo.smartindent = true

-- window options
wo.cursorline = true
wo.number = true
wo.relativenumber = true
wo.signcolumn = 'yes'
wo.wrap = true
wo.foldmethod = 'expr'
wo.foldexpr = 'nvim_treesitter#foldexpr()'

