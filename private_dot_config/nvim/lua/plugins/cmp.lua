local M = {
  "hrsh7th/nvim-cmp",
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
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
      ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
      ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ["<C-e>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      -- Accept currently selected item. If none selected, `select` first item.
      -- Set `select` to `false` to only confirm explicitly selected items.
      ["\\"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expandable() then
          luasnip.expand()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        -- elseif check_backspace() then
        --   fallback()
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
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
