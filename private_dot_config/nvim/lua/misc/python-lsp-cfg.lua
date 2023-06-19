local settings = {
  pyright = {
    python = {
      analysis = {
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportGeneralTypeIssues = "none",
          reportOptionalMemberAccess = "none",
          reportOptionalSubscript = "none",
          reportPrivateImportUsage = "none",
        },
        autoImportCompletions = false,
      },
      linting = {pylintEnabled = false}
    }
  },
  pylsp = {
    pylsp = {
      builtin = {
        installExtraArgs = {'flake8', 'pycodestyle', 'pydocstyle', 'pyflakes', 'pylint', 'yapf'},
      },
      plugins = {
        jedi_completion = { enabled = false },
        rope_completion = { enabled = false },
        flake8 = { enabled = false },
        pyflakes = { enabled = false },
        pycodestyle = {
          ignore = {'E226', 'E266', 'E302', 'E303', 'E304', 'E305', 'E402', 'C0103', 'W0104', 'W0621', 'W391', 'W503', 'W504'},
          maxLineLength = 99,
        },
      },
    },
  },
}


local on_attach = function(client, bufnr)
  local rc = client.resolved_capabilities

  if client.name == 'pyright' then
    rc.hover = false
  end

  if client.name == 'pylsp' then
    rc.rename = false
    rc.signature_help = false
  end

   --LSP signature
  require('lsp_signature').on_attach()

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.keymap.set("n", "gd", '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', opts)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "gh", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
end

-- Update capabilities
local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

-- Initialize LS
require('nvim-lsp-installer').on_server_ready(function(server)
  local opts = {capabilities = capabilities, on_attach = on_attach}
  if settings[server.name] then
    opts['settings'] = settings[server.name]
  end
  server:setup(opts)
end)
