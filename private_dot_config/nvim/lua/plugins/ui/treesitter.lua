return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
  config = function()
    local treesitter = require("nvim-treesitter.configs")
    treesitter.setup({
      ignore_install = { 'help' },
      highlight = {
        enable = true
      },
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
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-Space>",
          node_incremental = "<C-Space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
