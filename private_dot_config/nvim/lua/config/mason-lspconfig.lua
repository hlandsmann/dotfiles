local lspconfig = require('lspconfig')
require("mason").setup()
require("mason-lspconfig").setup()

require("mason-lspconfig").setup_handlers({
  -- The first entry (without a key) will be the default handler
  -- and will be called for each installed server that doesn't have
  -- a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup {}
  end,
  -- Next, you can provide a dedicated handler for specific servers.
  -- For example, a handler override for the `rust_analyzer`:
  ["rust_analyzer"] = function()
    require("rust-tools").setup {}
  end,
  -- ['clangd'] = function()
  --   lspconfig.clangd.setup {
  --     -- mason = false,
  --     cmd = {
  --       'clangd',
  --       '--background-index',
  --       '--log=verbose'
  --     },
  --     -- settings = {
  --     clangd = { path = '/usr/lib/llvm/16/clangd' },
  --     -- },
  --     filetypes = { 'c', 'cpp', 'h', 'hpp' }
  --   }
  -- end,
})
