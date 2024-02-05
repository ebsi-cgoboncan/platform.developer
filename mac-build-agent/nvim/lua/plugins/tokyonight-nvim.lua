require('tokyonight').setup {
  style = 'night',
  transparent = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = { italic = true },
    sidebars = 'transparent',
    floats = 'transparent',
  },
  hide_inactive_statusline = true,
}

vim.cmd[[colorscheme tokyonight]]

