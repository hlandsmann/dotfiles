local Util = require("misc.util")
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
local wk = require("which-key")
map("v", "Y", '"+y', { desc = "yank to clipboard" })
-- map("n", "<leader>ct", "<cmd>lcd!- | lcd build | terminal<cr>", { desc = "open terminal; cd build" })
map("n", "<leader>t", function() require 'builder'.get():toggle_terminal() end, { desc = "Toggle build terminal" })
map("n", "<leader>cT", "<cmd>lcd!- | terminal<cr>", { desc = "open terminal" })
map("n", "<leader>cb", "<cmd>lcd!- | lcd build | te ninja<cr>", { desc = "build, and exit" })
map("n", "<leader>ch", function() require("builder").get():configure_build() end, { desc = "my ninja_call plugin" })
map("t", "JK", "<C-\\><C-n>", { desc = "exit terminal" })

-- git
wk.register({ c = { name = "git conflict", }, }, { prefix = "<leader>c" })
wk.register({ g = { name = "git", }, }, { prefix = "<leader>" })
map("n", "<leader>cci", '<plug>(git-conflict-theirs)', { desc = "choose incoming" })
map("n", "<leader>ccc", '<Plug>(git-conflict-ours)', { desc = "choose current" })
map("n", "<leader>gg", function() Util.float_term({ "lazygit" }, { cwd = Util.get_root(), esc_esc = false }) end,
  { desc = "Lazygit (root dir)" })
map("n", "<leader>gG", function() Util.float_term({ "lazygit" }, { esc_esc = false }) end, { desc = "Lazygit (cwd)" })

-- windows
map("i", "<C-h>", "<Esc><C-w>h", { desc = "exit insert, window move" })
map("i", "<C-j>", "<Esc><C-w>j", { desc = "exit insert, window move" })
map("i", "<C-k>", "<Esc><C-w>k", { desc = "exit insert, window move" })
map("i", "<C-l>", "<Esc><C-w>l", { desc = "exit insert, window move" })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "exit terminal, window move" })
map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "exit terminal, window move" })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "exit terminal, window move" })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "exit terminal, window move" })
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

if Util.has("bufferline.nvim") then
  map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
end

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- lsp
wk.register({ c = { name = "code", }, }, { prefix = "<leader>" })
wk.register({ g = { name = "GoTo" } })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
map("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format buffer" })
map("v", "<leader>cf", vim.lsp.buf.format, { desc = "Format selection" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
-- map("n", "]d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
-- map("n", "[d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
-- map("n", "]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
-- map("n", "[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" }) map("n", "]w", M.diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
-- map("n", "[w", M.diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
-- map("n", "<leader>cf", format, { desc = "Format Document", has = "documentFormatting" })
-- map("n", "<leader>cf", format, { desc = "Format Range", mode = "v", has = "documentRangeFormatting" })
-- map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", mode = { "n", "v" }, has = "codeAction" })

--toggle
map("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>uf", require("misc.format").toggle, { desc = "Toggle format on Save" })
-- rg with options
map("n", "<leader>fs", function()
  require("telescope").extensions.live_grep_args.live_grep_args({ cwd = vim.fn.getcwd() })
end, { noremap = true, desc = "rg, but with options" })

-- floating terminal
local lazyterm = function() Util.float_term(nil, { cwd = Util.get_root() }) end
map("n", "<leader>fT", lazyterm, { desc = "Terminal (root dir)" })
map("n", "<leader>ft", function() Util.float_term() end, { desc = "Terminal (cwd)" })

-- help
wk.register({ h = { name = "help", }, }, { prefix = "<leader>" })
map("n", "<leader>ha", "<cmd>Telescope autocommands<cr>", { desc = "Auto Commands" })
map("n", "<leader>hk", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps" })

-- session
wk.register({ s = { name = "session", }, }, { prefix = "<leader>" })
map("n", "<leader>sl", function() require('telescope').extensions.possession.list() end,
  { desc = "load session telescope" })
map("n", "<leader>ss", function() require 'plugins.startup.possession'.session_save() end, { desc = "session save" })
map("n", "<leader>sn", function() require 'plugins.startup.possession'.session_save_new() end, { desc = "session save" })

-- misc
map("n", "<leader><tab><tab>", "<cmd>tabnew %<cr>", { desc = "New Tab" })
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
