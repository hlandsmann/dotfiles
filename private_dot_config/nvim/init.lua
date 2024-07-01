local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("config")
require("lazy").setup('plugins', {
  dev = {
    -- directory where you store your local plugin projects
    path = "~/src/nvim-plugins/",
    ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    patterns = {},    -- For example {"folke"}
    fallback = false, -- Fallback to git when local plugin doesn't exist
  }
})
-- require('mason').setup()
require 'config.mason-lspconfig'
require 'config.lspconfig'
require 'config.keymaps'

vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

vim.cmd.colorscheme('catppuccin')
-- vim.cmd.colorscheme('everforest')
