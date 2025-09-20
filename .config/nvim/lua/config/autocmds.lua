-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_user_command("CleanLogs", function()
  vim.cmd([[%s/\\n/\r/ge]])
  vim.cmd([[%s/\\t/    /ge]])
  vim.cmd([[%!sed -E 's/\x1B\[[0-9;]*[A-Za-z]//g']])
end, { desc = "Convert \\n and \\t into real newlines and tabs" })
vim.api.nvim_create_user_command("PrettyResponse", function()
  vim.cmd([[%!sed -E 's/\x1B\[[0-9;]*[A-Za-z]//g' | sed 's/^.*response//' | jq .]])
end, { desc = "Strip ANSI, drop log prefix, and pretty-print JSON response" })
