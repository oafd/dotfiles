return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- make Noice render hovers with a border
      presets = { lsp_doc_border = true },      -- quick on-switch
      lsp = {
        hover = { enabled = true, opts = { border = { style = "rounded" } } },
        signature = { enabled = true, opts = { border = { style = "rounded" } } },
      },
      -- (optional) be explicit for the hover view
      views = { hover = { border = { style = "rounded" }, syntax = true, } },
    },
  },
}
