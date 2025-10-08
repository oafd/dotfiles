return {
  {
    "ibhagwan/fzf-lua",
    config = function()
      local fzf = require("fzf-lua")
      local actions = require("fzf-lua.actions")

      fzf.setup({
        files = {
          cmd = "fd . --type f --hidden --follow | sort",
        },
        winopts = {
          height = 0.80,
          width  = 0.90,
          preview = { layout = "horizontal", horizontal = "right:50%" },
        },
        fzf_opts = {
          ["--tiebreak"] = "begin,index",
          ["--header-first"] = false,    -- put it above the prompt
        },
        actions = {
          files = {
            ["default"] = actions.file_edit,
            ["ctrl-v"]  = actions.file_vsplit,
            ["ctrl-s"]  = actions.file_split,
            ["ctrl-q"]  = actions.file_qf,  -- send to quickfix
            ["ctrl-y"]  = function(selected, opts)
              local cwd = opts and opts.cwd
              local paths = {}
              for _, relpath in ipairs(selected) do
                local clean = relpath:gsub("[^\x20-\x7E]", ""):gsub("%s+", "")
                local path  = clean:match("^(.-):") or clean
                table.insert(paths, vim.fn.fnamemodify((cwd or "") .. "/" .. path, ":p"))
              end
              local out = table.concat(paths, " ")
              vim.fn.setreg("+", out)
              vim.notify("📋 Copied to clipboard:\n" .. out)
            end,
          },
        },
      })
    end,
  },
}
