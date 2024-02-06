vim.cmd("packadd which-key.nvim")
local wk = require("which-key")

wk.setup({
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
		align = "left",
	},
	show_help = true,
})

local b = {}
function b.go_to_buffer(num)
	return function()
		require("bufferline").go_to_buffer(num)
	end
end

-- Spaced prefixed in Normal mode
wk.register({
	[","] = { "<cmd>:NvimTreeFindFile<cr>", "find in NvimTree" },
	["t"] = { "<cmd>:NvimTreeToggle<cr>", "find in NvimTree" },
})
