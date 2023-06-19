local M = {
  "hrsh7th/nvim-cmp",
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip', }
}

M.config = function()
  local cmp_status_ok, cmp = pcall(require, "cmp")
  if not cmp_status_ok then
    return
  end

  local snip_status_ok, luasnip = pcall(require, "luasnip")
  if not snip_status_ok then
    return
  end

  require("luasnip/loaders/from_vscode").lazy_load()

  -- local check_backspace = function()
  --   local col = vim.fn.col(".") - 1
  --   return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
  -- end

  --   פּ ﯟ   some other good icons
  local kind_icons = {
    Text = "",
    Method = "m",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "",
    Interface = "",
    Module = "",
    Property = "",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
  }
  -- find more here: https://www.nerdfonts.com/cheat-sheet

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body) -- For `luasnip` users.
      end,
    },

    mapping = {
      ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
      ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<c-y>"] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        { "i", "c" }
      ),
      ["<M-y>"] = cmp.mapping(
        cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        { "i", "c" }
      ),
      ["<c-space>"] = cmp.mapping {
        i = cmp.mapping.complete(),
        c = function(
          _ --[[fallback]]
        )
          if cmp.visible() then
            if not cmp.confirm { select = true } then
              return
            end
          else
            cmp.complete()
          end
        end,
      },
      ["<tab>"] = cmp.config.disable,
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        -- Kind icons
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        vim_item.menu = ({
          nvim_lsp = "[LSP]",
          luasnip = "[Snippet]",
          buffer = "[Buffer]",
          path = "[Path]",
        })[entry.source.name]
        return vim_item
      end,
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "buffer" },
      { name = "path" },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    window = {
      documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      },
    },
    experimental = {
      ghost_text = false,
      native_menu = false,
    },
  })
end
return M
-- local M = {
--   "hrsh7th/nvim-cmp",
-- }
--
-- M.config = function()
--   local cmp = require("cmp")
--
--   vim.opt.completeopt = { "menu", "menuone", "noselect" }
--
--   cmp.setup({
--
--     snippet = {
--       -- REQUIRED - you must specify a snippet engine
--       expand = function(args)
--         -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--         -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
--         -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
--         -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
--       end,
--     },
--     window = {
--       -- completion = cmp.config.window.bordered(),
--       -- documentation = cmp.config.window.bordered(),
--     },
--     mapping = cmp.mapping.preset.insert({
--       ["<C-b>"] = cmp.mapping.scroll_docs(-4),
--       ["<C-f>"] = cmp.mapping.scroll_docs(4),
--       ["<C-Space>"] = cmp.mapping.complete(),
--       ["<C-e>"] = cmp.mapping.abort(),
--       ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--
--       ["<C-j>"] = function()
--         if cmp.visible() then
--           cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
--         else
--           cmp.complete()
--         end
--       end,
--
--       ["<C-k>"] = function()
--         if cmp.visible() then
--           cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
--         else
--           cmp.complete()
--         end
--       end,
--     }),
--     sources = cmp.config.sources({
--       { name = "nvim_lsp" },
--       { name = "vsnip" }, -- For vsnip users.
--       -- { name = 'luasnip' }, -- For luasnip users.
--       -- { name = 'ultisnips' }, -- For ultisnips users.
--       -- { name = 'snippy' }, -- For snippy users.
--     }, {
--       { name = "buffer" },
--     }),
--   })
--
--   -- Set configuration for specific filetype.
--   cmp.setup.filetype("gitcommit", {
--     sources = cmp.config.sources({
--       { name = "cmp_git" }, -- You can specify the `cmp_git` source if you were installed it.
--     }, {
--       { name = "buffer" },
--     }),
--   })
--
--   -- -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
--   -- cmp.setup.cmdline({ "/", "?" }, {
--   --   mapping = cmp.mapping.preset.cmdline(),
--   --   sources = {
--   --     { name = "buffer" },
--   --   },
--   -- })
--   --
--   -- -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
--   -- cmp.setup.cmdline(":", {
--   --   mapping = cmp.mapping.preset.cmdline(),
--   --   sources = cmp.config.sources({
--   --     { name = "path" },
--   --   }, {
--   --     { name = "cmdline" },
--   --   }),
--   -- })
--
--   -- Set up lspconfig.
--   local capabilities = require("cmp_nvim_lsp").default_capabilities()
--   -- -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
--   -- require("lspconfig")["<YOUR_LSP_SERVER>"].setup({
--   --   capabilities = capabilities,
--   -- })
-- end
--
-- return M
