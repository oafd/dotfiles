return {
  "folke/snacks.nvim",
  lazy = false,
  ---@type snacks.Config
  opts = {
    dashboard = { enabled = true },
    explorer = { enabled = true, hidden = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = {
      hidden = true,
      win = {
        input = {
          keys = {
            ["<S-Up>"] = { "preview_scroll_up",   mode = { "i", "n" } },
            ["<S-Down>"] = { "preview_scroll_down", mode = { "i", "n" } },
          },
        },
      },
    },

    quickfile = { enabled = true },
    terminal = { enabled = true, win = { position = "float", border = "rounded", }, },
    notifier = { enabled = true, timeout = 3000, style = "compact" },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
  },
  keys = {
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>fC", function() Snacks.picker.files({ cwd = vim.fn.expand("~/dotfiles/"), hidden = true }) end, desc = "Find Files ~/.config", },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files ./" },
    { "<leader>fF", function() Snacks.picker.files({ cwd = vim.fn.expand("~"), }) end, desc = "Find Files ~/", },
    { "<leader>Z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep ./" },
    { "<leader>sG", function() Snacks.picker.grep({ cwd = vim.fn.expand("~") }) end, desc = "Grep ~/" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
  },
}
