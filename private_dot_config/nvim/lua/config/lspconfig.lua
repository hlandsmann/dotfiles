local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
lspconfig.clangd.setup {
  cmd = {
    'clangd',
    '--clang-tidy',
    "--all-scopes-completion",
    "--cross-file-rename",
    "--completion-style=detailed",
    "--header-insertion-decorators",
    "--header-insertion=iwyu",
    "--pch-storage=memory",
    -- '--background-index',
    -- '--log=verbose'
  },
  settings = {
    clangd = { path = '/usr/lib/llvm/16/clangd' },
  },
  capabilities = capabilities,
}

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  capabilities = capabilities,
}

lspconfig.cmake.setup {
  -- cmd = { 'cmake-language-server' },
  cmd = { 'neocmakelsp', '--stdio' },
  single_file_support = true, -- suggested
  settings = {
    buildDirectory = 'build',
    root_dir = vim.fn.getcwd(),
  },
  capabilities = capabilities,
}

lspconfig.pyright.setup {}
