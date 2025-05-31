return {
  "ibhagwan/fzf-lua",
  keys = {
    { "<leader>fd", "<cmd>Dotfiles<CR>", desc = "Search chezmoi dotfiles" },
  },
  config = function()
    local fzf = require("fzf-lua")

    vim.api.nvim_create_user_command("Dotfiles", function()
      fzf.files({
        prompt = " Dotfiles > ",
        cwd = vim.fn.expand("~/.local/share/chezmoi"),
        cmd = "fd . ~/.local/share/chezmoi --hidden --exclude .git",
      })
    end, {})
  end,
}
