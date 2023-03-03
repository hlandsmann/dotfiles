-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

map("n", "<leader>ct", "<cmd>lcd!- | lcd build | terminal<cr>", { desc = "open terminal; cd build" })
map("n", "<leader>cT", "<cmd>lcd!- | terminal<cr>", { desc = "open terminal" })
map("n", "<leader>cb", "<cmd>lcd!- | lcd build | te ninja<cr>", { desc = "build, and exit" })
map("n", "<leader>ch", require("builder").ninja_call, { desc = "my ninja_call plugin" })
map("t", "jk", "<C-\\><C-n>", { desc = "exit terminal" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "exit terminal, window move" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "exit terminal, window move" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "exit terminal, window move" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "exit terminal, window move" })
map(
  "n",
  "<leader>fs",
  require("telescope").extensions.live_grep_args.live_grep_args,
  { noremap = true, desc = "rg, but with options" }
)
