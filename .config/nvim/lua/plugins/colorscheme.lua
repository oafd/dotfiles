return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  lazy = false,
  opts = {
    flavour = "mocha",
    transparent_background = true,
    term_colors = true,
    dim_inactive = { enabled = false },
    integrations = {
      cmp = true,
      gitsigns = true,
      telescope = true,
      mini = true,
      noice = true,
      notify = true,
      native_lsp = { enabled = true },
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
