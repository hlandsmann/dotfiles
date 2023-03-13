local M = { "akinsho/git-conflict.nvim" }

M.config = function()
  local git_conflict = require("git-conflict")
  git_conflict.setup({ highlights = {
    incoming = "DiffText",
    current = "DiffAdd",
  } })
end

return M
