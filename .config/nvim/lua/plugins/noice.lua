return {
	"folke/noice.nvim",
	opts = {
		cmdline = {
			enabled = true,
		},
		messages = {
			enabled = true,
		},
		lsp = {
			progress = {
				enabled = true,
			},
		},
		presets = {
			bottom_search = true,
			command_palette = true,
			long_message_to_split = true,
		},
		routes = {
			{
				filter = {
					event = "msg_showmode",
				},
				view = "notify", -- change to "mini" or "popup" if preferred
			},
		},
	},
}
