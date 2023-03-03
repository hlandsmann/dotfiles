return {
  -- disabled:
  { "echasnovski/mini.pairs", enabled = false },

  -- enabled:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "cmake",
        "cpp",
        "dockerfile",
        "help",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },
  { "numToStr/Comment.nvim" },
  -- { "petertriho/nvim-scrollbar" },
  { "dstein64/nvim-scrollview" },
  { "ggandor/leap.nvim", commit = "a706fea726179be91af75f4030a7b65a6adafa90" },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
}
