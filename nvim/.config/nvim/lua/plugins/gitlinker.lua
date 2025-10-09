return {
  "ruifm/gitlinker.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("gitlinker").setup({
      callbacks = {
        ["bitbucket.dev.kiwigrid.com"] = function(url_data)

          local base = "https://bitbucket.dev.kiwigrid.com"
          local project, repo = url_data.repo:match("([^/]+)/([^/]+)")
          if not project or not repo then return end

          local url = string.format(
            "%s/projects/%s/repos/%s/browse/%s",
            base, project, repo, url_data.file or ""
          )

          -- Add line number(s) if present
          if url_data.lstart then
            url = url .. "#" .. url_data.lstart
            if url_data.lend and url_data.lend ~= url_data.lstart then
              url = url .. "-" .. url_data.lend
            end
          end
          return url
        end,
      },
      mappings = "<leader>gy", -- Copy link
    })
  end,
  keys = {
    { "<leader>gy", mode = { "n", "v" }, desc = "Copy Git link" },
  },
}
