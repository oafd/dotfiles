-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_picker = "fzf"
vim.g.autoformat = true
vim.g.lazyvim_cmp = "nvim-cmp"
vim.opt.pumblend = 0 -- cmp popup menu
vim.opt.winblend = 0 -- all floating windows
vim.opt.showtabline = 0 -- never show the tabline
vim.opt_local.wrap = true -- keep wrap
vim.opt_local.showbreak = "" -- no '>' on wrapped lines
vim.opt.list = false -- no '>' on wrapped lines
