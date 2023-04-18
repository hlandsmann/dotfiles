-- Harmens Docu:
-- colorful icons: emerge joypixels, eselect fontconfig list, eselect fontconfig enable **
--
--
-- bootstrap lazy.nvim, LazyVim and your plugins
--
require("config.lazy")
require("tokyonight").setup()
-- require("scrollbar").setup()

-- vim.g.everforest_background = "hard"
-- vim.cmd("colorscheme everforest")
vim.lsp.set_log_level("trace")
-- local opt = vim.opt
-- vim.treesitter.language.register('devicetree', 'dtso')
-- local parsers = require "nvim-treesitter.parsers"
--
-- local parser_config = parsers.get_parser_configs()
-- parser_config.devicetree.filetype_to_parsername = "dtso"

-- require 'lspconfig'.clangd.setup {
--   cmd = { "clangd", "--background-index", "--log=verbose" },
--   -- capabilities = capabilities
-- }

-- -- vim.api.nvim_create_autocmd({ "BufRead", "BufReadPost", "BufNewFile" }, {
-- vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged" }, {
--   pattern = { "*" },
--   callback = function()
--     vim.lsp.semantic_tokens_full()
--   end,
--   -- command = "set foldlevel=99",
-- })
-- if &filetype == "cpp" || &filetype == "cuda" || &filetype == "c"
--   autocmd BufEnter,TextChanged <buffer> lua require 'vim.lsp.buf'.semantic_tokens_full()
-- endif
