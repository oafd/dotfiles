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

vim.api.nvim_create_user_command("Z", function(opts)
  local query = table.concat(opts.fargs, " ")

  if query == "" then
    return
  end

  local handle = io.popen("zoxide query " .. vim.fn.shellescape(query))
  if not handle then
    return
  end

  local result = (handle:read("*a") or ""):gsub("%s+$", "")
  handle:close()

  if result ~= "" then
    vim.cmd.cd(result)
    -- vim.notify("cd → " .. result, vim.log.levels.INFO)
  else
    vim.notify("zoxide: no match for " .. query, vim.log.levels.WARN)
  end
end, { nargs = "*", desc = "cd using zoxide" })

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
vim.api.nvim_create_autocmd("FileType", {
  pattern = "csv",
  callback = function()
    vim.cmd("CsvViewEnable")
  end,
})
