-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").files({ cwd = "~" })
end, { desc = "Find files - Home" })
vim.keymap.set("n", "<Tab>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>//", function()
	require("fzf-lua").live_grep({ cwd = vim.fn.expand("~") })
end, { desc = "Live Grep (home)" })

vim.api.nvim_create_user_command("R", function(opts)
	local old, new

	if opts.args:find("|") then
		-- Pipe detected → split by |
		local args = vim.split(opts.args, "|")
		if #args < 2 then
			print("Usage: :R old | new")
			return
		end
		old = vim.trim(args[1])
		new = vim.trim(args[2])
	else
		-- No pipe → split by spaces
		local args = vim.split(opts.args, " ", { trimempty = true })
		if #args < 2 then
			print("Usage: :R old new")
			return
		end
		old = args[1]
		new = args[2]
	end

	-- Replace literal with confirmation
	vim.cmd("%s/\\V" .. old .. "/" .. new .. "/gc")
end, {
	nargs = "+",
})
