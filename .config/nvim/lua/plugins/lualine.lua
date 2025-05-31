return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        sections = {
          lualine_b = {
            "branch",
            {
              "diff",
              colored = true,
              symbols = { added = " ", modified = " ", removed = " " },
            },
          },
        },
      })
    end,
  },
}
