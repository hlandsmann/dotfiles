return {
  { "catppuccin/nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "folke/tokyonight.nvim" },
  { "glepnir/zephyr-nvim" },
  { "marko-cerovac/material.nvim" },
  { "rafamadriz/neon" },
  { "ray-x/starry.nvim" },
  { "sainnhe/edge" },
  { "sainnhe/everforest" },
  { "sainnhe/sonokai" },
  { "savq/melange-nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      everforest_background = "hard",
      colorscheme = "everforest",
    },
  },
}
