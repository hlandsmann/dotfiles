-- local null_ls_ok, null_ls = pcall(require, "null-ls")
-- if not null_ls_ok then
--   return
-- end
--
-- local sources = {
--   -- python
--   null_ls.builtins.formatting.black,
--   --[[ .with({
--     extra_args = { "--line-length=120" },
--   }), ]]
--   null_ls.builtins.formatting.isort,
-- }
--
-- null_ls.setup({ sources = sources })

local M = { "jose-elias-alvarez/null-ls.nvim" }
M.config = function()
  local null_ls = require("null-ls")
  local formatting = null_ls.builtins.formatting
  null_ls.setup({
    sources = { formatting.blue.with({ extra_args = { "--line-length=110" } }) },
  })
end
return M
-- , sources = { require("null-ls").builtins.formatting.black } }
