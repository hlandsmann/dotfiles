return {
    "ggandor/leap.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    opts ={
    safe_labels = { "s", "f",  "w",  "t", "u", "n", ",", "/", "q", "b"  },
    labels = { "s", "f", "a", "d", "j", "k", "l", "h", "m", "c", "v", "x", "n", "u", "i", "o", "r", "e", "w", "/", ",", ".", "J", "K", "L", "M", "U", "I", "A", "S", "Y", "B", "N", "O", "P", "T", "R", "E", "W", "Q", "?", "Z"}},
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
         leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  }
