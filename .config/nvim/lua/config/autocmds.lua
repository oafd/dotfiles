-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "xml",
	callback = function()
		vim.opt_local.expandtab = false -- Use tabs, not spaces
		vim.opt_local.shiftwidth = 4 -- Tab width for >>, <<
		vim.opt_local.tabstop = 4 -- Width of a tab character
		vim.opt_local.softtabstop = 4 -- Spaces a <Tab> counts for in insert mode
	end,
})
