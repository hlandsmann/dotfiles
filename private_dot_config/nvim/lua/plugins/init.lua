-- require('plugins.ui')
-- return {
--   "folke/which-key.nvim",
--   { "folke/neoconf.nvim", cmd = "Neoconf" },
--   "folke/neodev.nvim"}
return {
  { import = 'plugins.colors' },
  { import = 'plugins.editor' },
  { import = 'plugins.lsp' },
  { import = 'plugins.ui' },
  { import = 'plugins.startup' },
  { "dstein64/nvim-scrollview" },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
}
