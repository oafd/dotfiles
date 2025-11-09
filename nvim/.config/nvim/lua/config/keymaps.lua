-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>fh", function()
  require("fzf-lua").files({ cwd = vim.fn.expand("~") })
end, { desc = "Find files - Home" })

vim.keymap.set("n", "<leader>sG", function()
  require("fzf-lua").live_grep({ cwd = vim.fn.expand("~") })
end, { desc = "Grep (Home)" })

-- create a note in notes/
   vim.keymap.set("n", "<leader>N", function()
  vim.ui.input({ prompt = "Note filename: " }, function(input)
    if input and input ~= "" then
      local path = vim.fn.expand("~/notes/" .. input .. ".md")
      vim.cmd("edit " .. path)
    end
  end)
end, { desc = "New Note in ~/notes" })

-- Toggle global autoformat (LazyVim)
vim.keymap.set("n", "<leader>fo", function()
  vim.g.autoformat = not vim.g.autoformat
  local state = vim.g.autoformat and "enabled" or "disabled"
  vim.notify("Autoformat on save " .. state, vim.log.levels.INFO, { title = "Formatting" })
end, { desc = "Toggle Autoformat on Save" })

-- change cwd to current file's directory
vim.keymap.set("n", "<leader>cd", function()
  vim.cmd("cd %:p:h")
  print("cwd -> " .. vim.fn.getcwd())
end, { desc = "Set cwd to file's folder" })

-- Show diagnostics in a floating popup
vim.keymap.set("n", "gl", function()
  vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
end, { desc = "Show diagnostic message" })

vim.keymap.set("n", "<leader>fC", function()
  require("fzf-lua").files({ cwd = vim.fn.expand("~/.config") })
end, { desc = "Find in ~/.config" })

-- Hide terminal with Ctrl+Q (from terminal or normal mode)
vim.keymap.set({ "n", "t" }, "<C-q>", function()
  Snacks.terminal()
end, { desc = "Hide Terminal" })

-- toggle virtual_text from diagnostic
vim.keymap.set("n", "<leader>xd", function()
  local current = vim.diagnostic.config().virtual_text
  local new_value = not current
  vim.diagnostic.config({ virtual_text = new_value })
  vim.notify("Virtual text " .. (new_value and "enabled" or "disabled"), vim.log.levels.INFO, { title = "Diagnostics" })
end, { desc = "Toggle virtual text" })
