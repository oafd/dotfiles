return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	opts = {
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = true,
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn", -- start selection
				node_incremental = "grn", -- expand selection
				node_decremental = "grm", -- shrink selection
			},
		},
		textobjects = {
			select = {
				enable = true,
				lookahead = true,
				keymaps = {
					["af"] = "@function.outer", -- around function
					["if"] = "@function.inner", -- inside function
					["ac"] = "@class.outer", -- around class
					["ic"] = "@class.inner", -- inside class
					["ab"] = "@block.outer", -- around block (optional)
					["ib"] = "@block.inner", -- inside block (optional)
				},
			},
		},
		ensure_installed = {
			"lua",
			"vim",
			"bash",
			"python",
			"javascript",
			"typescript",
			"json",
			"yaml",
			"go",
			"rust",
			"java",
			"markdown",
			-- add or remove languages here
		},
		auto_install = true,
	},
}
