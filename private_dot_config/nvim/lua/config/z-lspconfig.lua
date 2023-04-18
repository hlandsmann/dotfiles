local lspconfig = require('lspconfig')
lspconfig.clangd.setup {
  cmd = {
    'clangd',
    '--background-index',
    '--log=verbose'
  },
  settings = {
    clangd = { path = '/usr/lib/llvm/16/clangd' },
  },
  -- capabilities = capabilities
}