-- Harmens Docu:
-- colorful icons: emerge joypixels, eselect fontconfig list, eselect fontconfig enable **
--
--
-- bootstrap lazy.nvim, LazyVim and your plugins
--
require("config.lazy")
require("tokyonight").setup()
-- require("scrollbar").setup()

vim.g.everforest_background = "hard"
vim.cmd("colorscheme everforest")

local vim = vim
local opt = vim.opt

-- enable fold with treesitter, autocommand zR to open all folds
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.conceallevel = 0

vim.api.nvim_create_autocmd({ "BufRead", "BufReadPost", "BufNewFile" }, {
  pattern = { "*" },
  -- callback = function()
  --   vim.api.nvim_feedkeys("zR", "n", true)
  -- end,
  command = "set foldlevel=99",
})
