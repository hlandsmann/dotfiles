local M = { "akinsho/git-conflict.nvim" }

M.config = function()
  local git_conflict = require("git-conflict")
  git_conflict.setup({
    highlights = {
      incoming = "DiffChange",
      current = "DiffAdd",
    },
    default_mappings = false
  })
end

return M
