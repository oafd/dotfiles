return {
	{
		"ibhagwan/fzf-lua",
		keys = {
			{ "<leader>fd", "<cmd>Dotfiles<CR>", desc = "Search chezmoi dotfiles" },
		},
		config = function()
			local fzf = require("fzf-lua")
			fzf.setup({
				files = {
					cmd = "fd . --type f --hidden --follow | sort",
				},
				winopts = {
					height = 0.80,
					width = 0.90,
					preview = {
						layout = "horizontal",
						horizontal = "right:50%",
					},
				},
				fzf_opts = {
					["--tiebreak"] = "begin,index",
				},
				actions = {
					files = {
						["default"] = require("fzf-lua.actions").file_edit,
						["ctrl-v"] = require("fzf-lua.actions").file_vsplit,
						["ctrl-s"] = require("fzf-lua.actions").file_split,
						["ctrl-y"] = function(selected, opts)
							local cwd = opts and opts.cwd
							local paths = {}
							for _, relpath in ipairs(selected) do
								local clean_path = relpath:gsub("[^\x20-\x7E]", ""):gsub("%s+", "")
								local path = clean_path:match("^(.-):") or clean_path
								local fullpath = vim.fn.fnamemodify(cwd .. "/" .. path, ":p")
								table.insert(paths, fullpath)
							end
							local output = table.concat(paths, " ")
							vim.fn.setreg("+", output)
							vim.notify("📋 Copied to clipboard:\n" .. output)
						end,
					},
				},
			})

			vim.api.nvim_create_user_command("Dotfiles", function()
				fzf.files({
					prompt = " Dotfiles > ",
					cwd = vim.fn.expand("~/.local/share/chezmoi"),
					cmd = "fd . ~/.local/share/chezmoi --hidden --exclude .git",
				})
			end, {})
		end,
	},
}
