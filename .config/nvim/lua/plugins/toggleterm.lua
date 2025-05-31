return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    direction = "float",
    open_mapping = nil,  -- disable default
    float_opts = {
      border = "curved",
      width = 100,
      height = 30,
    },
  },
  keys = {
    {
      "<leader>tt",
      function()
        require("toggleterm").toggle()
      end,
      desc = "Toggle floating terminal",
    },
  },
}
