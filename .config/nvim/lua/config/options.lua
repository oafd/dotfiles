-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.lazyvim_picker = "fzf"
vim.g.autoformat = false
vim.g.lazyvim_cmp = "nvim-cmp"
-- Use ripgrep for :grep
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt_local.wrap = true       -- keep wrap
vim.opt_local.showbreak = ""    -- no '>' on wrapped lines
vim.opt.list = false -- no '>' on wrapped lines
-- No fake transparency anywhere
vim.opt.pumblend = 0   -- cmp popup menu
vim.opt.winblend = 0   -- all floating windows
vim.opt.shell = "zsh"
vim.opt.shellcmdflag = "-l -i -c"
