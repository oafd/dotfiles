local M = {}

local function open_term()
  return Snacks.terminal(nil, {
    id = "main",
    auto_insert = true,
  })
end

local function send_to_term(cmd)
  local term = open_term()
  local chan = vim.bo[term.buf].channel

  vim.schedule(function()
    vim.fn.chansend(chan, cmd .. "\n")
  end)
end

function M.run_test_all()
  send_to_term("mvn clean test")
end

function M.run_test_class()
  local file = vim.api.nvim_buf_get_name(0)
  local class = vim.fn.fnamemodify(file, ":t:r")
  send_to_term(("mvn -Dtest=%s test"):format(class))
end

function M.run_test_method()
  local file = vim.api.nvim_buf_get_name(0)
  local class = vim.fn.fnamemodify(file, ":t:r")
  local method = vim.fn.expand("<cword>")

  if not method or method == "" then
    vim.notify("No method under cursor", vim.log.levels.ERROR)
    return
  end

  send_to_term(("mvn -Dtest=%s#%s test"):format(class, method))
end

return M
