-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>fh", function()
  require("fzf-lua").files({ cwd = vim.fn.expand("~") })
end, { desc = "Find files - Home" })
-- create a note in notes/
vim.keymap.set("n", "<leader>N", function()
  vim.ui.input({ prompt = "Note filename: " }, function(input)
    if input and input ~= "" then
      local path = vim.fn.expand("~/notes/" .. input .. ".md")
      vim.cmd("edit " .. path)
    end
  end)
end, { desc = "New Note in ~/notes" })
vim.keymap.set("n", "<Tab>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-Tab>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })
-- change cwd to current file's directory
vim.keymap.set("n", "<leader>cd", function()
  vim.cmd("cd %:p:h")
  print("cwd -> " .. vim.fn.getcwd())
end, { desc = "Set cwd to file's folder" })
-- In terminal mode, send <C-l> through to the shell
vim.keymap.set("t", "<C-l>", "<C-l>", { noremap = true })
-- Toggle maximize current window without Zen/centering
local function toggle_maximize()
  if vim.w._max_saved then
    vim.cmd(vim.w._max_saved)     -- restore sizes
    vim.w._max_saved = nil
  else
    vim.w._max_saved = vim.fn.winrestcmd() -- save layout
    vim.cmd("wincmd |")           -- max width
    vim.cmd("wincmd _")           -- max height
  end
end

-- map it (normal + terminal mode)
vim.keymap.set({ "n", "t" }, "<leader>z", toggle_maximize, { desc = "Toggle maximize window" })
-- Normal: format whole file with Conform
vim.keymap.set("n", "<leader>cf", function()
  require("conform").format({ lsp_fallback = true })
end, { desc = "Format file" })

-- Visual: format selection with LSP
vim.keymap.set("v", "<leader>cf", function()
  vim.lsp.buf.format({
    range = {
      ["start"] = vim.api.nvim_buf_get_mark(0, "<"),
      ["end"]   = vim.api.nvim_buf_get_mark(0, ">"),
    },
  })
end, { desc = "Format selection (LSP)" })
vim.keymap.set("n", "<leader>fC", function()
  require("fzf-lua").files({ cwd = vim.fn.expand("~/.config") })
end, { desc = "Find in ~/.config" })
vim.keymap.set("v", "<leader>sc", function()
  require("fzf-lua").command_history()
end, { desc = "Search Command" })
