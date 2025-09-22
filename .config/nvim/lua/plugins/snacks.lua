return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    terminal = { enabled = true, win = { position = "float", border = "rounded", }, },
    notifier = { enabled = true, timeout = 3000, style = "compact" },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
  },
  keys = {
    { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>t", function() Snacks.terminal() end, desc = "Open Terminal Zsh" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
  }
}
