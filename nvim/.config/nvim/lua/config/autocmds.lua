vim.api.nvim_create_autocmd("FileType", {
  pattern = "xml",
  callback = function()
    if vim.fn.expand("%:t") == "pom.xml" then
      vim.b.disable_autoformat = true
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function(ev)
    local jt = require("config.java-test")

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
    end

    map("<leader>ta", jt.run_test_all, "Run All Tests")
    map("<leader>tc", jt.run_test_class, "Run Test class")
    map("<leader>tm", jt.run_test_method, "Run Test method")
  end,
})

-- Override :cd to use zoxide
vim.api.nvim_create_user_command("Cd", function(opts)
  local target = table.concat(opts.fargs, " ")
  if target == "" then
    vim.cmd("cd ~")
    return
  end

  -- call zoxide
  local handle = io.popen("zoxide query " .. vim.fn.shellescape(target))
  if not handle then
    return
  end

  local result = handle:read("*a")
  handle:close()

  result = result:gsub("%s+$", "")
  if result ~= "" then
    vim.cmd("cd " .. vim.fn.fnameescape(result))
    vim.notify("cd → " .. result, vim.log.levels.INFO)
  else
    vim.notify("zoxide: no match for " .. target, vim.log.levels.WARN)
  end
end, { nargs = "*", complete = "dir" })

-- Make :cd call :Cd
vim.cmd("cabbrev cd Cd")

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    -- Only run if ANSI escape codes are present
    if vim.fn.search([[\%x1b\[]], "nw") ~= 0 then
      vim.cmd([[%s/\%x1b\[[0-9;]*[A-Za-z]//g]])
      vim.o.wrap = false
      vim.o.filetype = "log"
    end
  end,
})

vim.api.nvim_create_user_command("BufSize", function()
  local bytes = vim.api.nvim_buf_get_offset(0, vim.api.nvim_buf_line_count(0))
  print(string.format("%.2f KB", bytes / 1024))
end, {})
