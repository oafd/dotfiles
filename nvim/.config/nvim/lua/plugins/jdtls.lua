return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  opts = function(_, opts)
    opts.settings = opts.settings or {}
    opts.settings.java = opts.settings.java or {}
    opts.settings.java.format = {
      enabled = true,
      settings = {
        url = vim.fn.expand("~/.config/nvim/kiwigrid.xml"),
        profile = "kiwigrid",
      },
    }
  end,
}
