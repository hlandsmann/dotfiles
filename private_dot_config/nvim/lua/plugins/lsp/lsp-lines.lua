local M = {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
}
M.config = function()
  require("lsp_lines").setup()

  vim.diagnostic.config({
    virtual_text = false, -- removes duplication of diagnostic messages due to lsp_lines
    virtual_lines = true
  })
end
return M

-- local diagnostics_virtual_text_value = false  -- wish i could query it directly and avoid this tempvar
-- vim.keymap.set("n", "<F12>", function()
-- 	diagnostics_virtual_text_value = not diagnostics_virtual_text_value
-- 	vim.diagnostic.config({
-- 		virtual_text = diagnostics_virtual_text_value,
-- 		virtual_lines = not diagnostics_virtual_text_value,
-- 	})
-- end)
