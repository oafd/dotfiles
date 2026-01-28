return {
  "catgoose/nvim-colorizer.lua",
  event = "VeryLazy",
  config = function()
    require("colorizer").setup({
      filetypes = { "*" },
      user_default_options = { names = false, mode = "background" },
    })
  end,
}
