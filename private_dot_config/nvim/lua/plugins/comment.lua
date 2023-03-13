local M = { "numToStr/Comment.nvim" }
M.config = function()
  local comment = require("Comment")
  local ft = require("Comment.ft")
  ft.set("cpp", { "//%s", "/*%s*/" })
  comment.setup()
  print("comment setup")
end

return M

-- , opts = {
-- ft.
--
-- } }
