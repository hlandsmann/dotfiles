-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")
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

map("v", "Y", '"+y', { desc = "yank to clipboard" })
map("n", "<leader>ct", "<cmd>lcd!- | lcd build | terminal<cr>", { desc = "open terminal; cd build" })
map("n", "<leader>cT", "<cmd>lcd!- | terminal<cr>", { desc = "open terminal" })
map("n", "<leader>cb", "<cmd>lcd!- | lcd build | te ninja<cr>", { desc = "build, and exit" })
map("n", "<leader>ch", require("builder").ninja_call, { desc = "my ninja_call plugin" })
map("t", "jk", "<C-\\><C-n>", { desc = "exit terminal" })

-- move between windows
map("i", "<C-h>", "<Esc><C-w>h", { desc = "exit insert, window move" })
map("i", "<C-j>", "<Esc><C-w>j", { desc = "exit insert, window move" })
map("i", "<C-k>", "<Esc><C-w>k", { desc = "exit insert, window move" })
map("i", "<C-l>", "<Esc><C-w>l", { desc = "exit insert, window move" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "exit terminal, window move" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "exit terminal, window move" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "exit terminal, window move" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "exit terminal, window move" })

-- rg with options
map("n", "<leader>fs", function()
  require("telescope").extensions.live_grep_args.live_grep_args({ cwd = Util.get_root() })
end, { noremap = true, desc = "rg, but with options" })

map("n", "<leader><tab><tab>", "<cmd>tabnew %<cr>", { desc = "New Tab" })
