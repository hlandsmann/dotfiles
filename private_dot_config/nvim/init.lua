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
-- require("lazy").setup(plugins, opts)

require("config")
require("lazy").setup('plugins')
-- require('mason').setup()
require 'config.mason-lspconfig'
require 'config.lspconfig'
require 'config.keymaps'
vim.cmd.colorscheme('catppuccin')
