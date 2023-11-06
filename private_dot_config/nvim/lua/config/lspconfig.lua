local custom_lsp = {}
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

custom_lsp.setup_clangd = function(compile_commands_dir)
  local setup = {
    cmd = {
      'clangd',
      -- '/usr/lib/llvm/16/bin/clangd',
      '--log=verbose',
      '--query-driver=**',
      -- '--query-driver=/opt/riedel/boexli-SDK-aarch64-v1.26.0/sysroots/aarch64-riedel-linux',
     -- '--query-driver=/opt/riedel/boexli-SDK-aarch64-v1.26.0/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-riedel-linux/aarch64-riedel-linux-gcc,/opt/riedel/boexli-SDK-aarch64-v1.26.0/sysroots/x86_64-pokysdk-linux/usr/bin/aarch64-riedel-linux/aarch64-riedel-linux-g++',
      -- '/media/2TB/misc/llvm-project/build/bin/clangd',
      -- '--clang-tidy',
      "--all-scopes-completion",
      "--completion-style=detailed",
      -- "--header-insertion-decorators",
      "--header-insertion=never",
      "--pch-storage=memory",
      '--background-index',
      -- '--log=verbose'
    },
    -- settings = {
    --   clangd = { path = '/usr/lib/llvm/16/clangd' },
    --   -- clangd = { path = '/media/2TB/misc/llvm-project/build/bin/clangd' },
    -- },
    capabilities = capabilities,
  }
  if compile_commands_dir ~= nil then
    table.insert(setup.cmd, "--compile-commands-dir=" .. compile_commands_dir)
  end
  lspconfig.clangd.setup(setup)
end

custom_lsp.setup_clangd()

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
        checkThirdParty = false, -- THIS IS THE IMPORTANT LINE TO ADD
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
  cmd = { '/home/harmen/.cargo/bin/neocmakelsp', '--stdio' },
  single_file_support = true, -- suggested
  settings = {
    buildDirectory = 'build',
    root_dir = vim.fn.getcwd(),
  },
  capabilities = capabilities,
}

lspconfig.pyright.setup {}

return custom_lsp
