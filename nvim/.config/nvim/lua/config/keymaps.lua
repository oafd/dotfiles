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
  local state = vim.g.autoformat and "ENABLED" or "DISABLED"
  vim.notify("Autoformat " .. state, vim.log.levels.INFO, { title = "Formatting" })
end, { desc = "Toggle Autoformat on Save" })

-- Show diagnostics in a floating popup
vim.keymap.set("n", "gl", function()
  vim.diagnostic.open_float(nil, { focus = false, border = "rounded" })
end, { desc = "Show diagnostic message" })

-- Hide terminal with Ctrl+Q (from terminal or normal mode)
vim.keymap.set({ "n", "t" }, "<C-q>", function()
  Snacks.terminal(nil, "main", { shell = "zsh" })
end, { desc = "Toggle Terminal" })

-- toggle virtual_text from diagnostic
vim.keymap.set("n", "<leader>xd", function()
  local current = vim.diagnostic.config().virtual_text
  local new_value = not current
  vim.diagnostic.config({ virtual_text = new_value })
  vim.notify("Virtual text " .. (new_value and "ENABLED" or "DISABLED"), vim.log.levels.INFO, { title = "Diagnostics" })
end, { desc = "Toggle virtual text" })
-- next spelling error
vim.keymap.set("n", "gs", "]s", { desc = "Next spelling error" })

-- spelling suggestions
vim.keymap.set("n", "gS", "[s", { desc = "Previous spelling error" })
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])
