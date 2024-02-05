vim.cmd 'packadd which-key.nvim'
local wk = require 'which-key'

wk.setup {
  plugins = {
    marks = true,
    registers = true,
    spelling = { enabled = true },
    presets = {
      operators = true,
      motions = true,
      text_objects = true,
      windows = true,
      nav = true,
      z = true,
      g = true,
    },
  },
  layout = {
    spacing = 3,
    align = 'left',
  },
  show_help = true,
}

local b = {}
function b.go_to_buffer(num)
  return function()
    require('bufferline').go_to_buffer(num)
  end
end

-- Spaced prefixed in Normal mode
wk.register({
  [','] = { '<cmd>:NvimTreeFindFile<cr>', 'find in NvimTree' },
  ['t'] = { '<cmd>:NvimTreeToggle<cr>', 'find in NvimTree' },
  p = {
    name = '+Tabs',
    n = { '<cmd>tabnew +term<cr>', 'New with terminal' },
    o = { '<cmd>tabonly<cr>', 'Close all other' },
    q = { '<cmd>tabclose<cr>', 'Close' },
    l = { '<cmd>tabnext<cr>', 'Next' },
    h = { '<cmd>tabprevious<cr>', 'Previous' },
  },
  b = {
    name = '+Buffers',
    n = { '<cmd>:BufferLineCycleNext<cr>', 'Next buffer' },
    p = { '<cmd>:BufferLineCyclePrev<cr>', 'Previous buffer' },
    f = { '<cmd>:BufferLineMoveNext<cr>', 'Move buffer forward' },
    b = { '<cmd>:BufferLineMovePrev<cr>', 'Move buffer backwards' },
    e = { '<cmd>:BufferLineSortByExtension<cr>', 'Sort buffers by extension' },
    d = { '<cmd>:BufferLineSortByDirectory<cr>', 'Sort buffers by directory' },
    ['1'] = { b.go_to_buffer(1), 'Go to buffer 1' },
    ['2'] = { b.go_to_buffer(2), 'Go to buffer 2' },
    ['3'] = { b.go_to_buffer(3), 'Go to buffer 3' },
    ['4'] = { b.go_to_buffer(4), 'Go to buffer 4' },
    ['5'] = { b.go_to_buffer(5), 'Go to buffer 5' },
    ['6'] = { b.go_to_buffer(6), 'Go to buffer 6' },
    ['7'] = { b.go_to_buffer(7), 'Go to buffer 7' },
    ['8'] = { b.go_to_buffer(8), 'Go to buffer 8' },
    ['9'] = { b.go_to_buffer(9), 'Go to buffer 9' },
  }
})

