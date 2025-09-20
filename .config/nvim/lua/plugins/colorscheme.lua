return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = true,
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      custom_highlights = function(colors)
        return {
          -- Window separators
          WinSeparator = { fg = colors.blue, bg = "NONE" },

          -- Floating windows (generic)
          NormalFloat = { bg = "NONE" },
          FloatBorder = { bg = "NONE" },
          -- Visual selection (brighter)
          Visual = { bg = colors.surface0, fg = "NONE" },
        }
      end,
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
