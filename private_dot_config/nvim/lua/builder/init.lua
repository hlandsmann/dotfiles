local builder = {}

local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local util = require 'misc.util'
local custom_lsp = require 'config.lspconfig'
local log = require 'builder.debugbuf'

builder.selection = function(title, choice, opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = title,
    finder = finders.new_table {
      results = choice
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        -- print(vim.inspect(selection))

        -- log.log(selection[1])
        builder.apply_selection(selection[1])
      end)
      return true
    end,
  }):find()
end

builder.apply_selection = function(name)
  for _, v in pairs(builder.configurePresets) do
    if name == v.name then builder.selected = v end
  end
  vim.g.build_directory = builder.get_build_directory()
  if builder.terminal ~= nil then
    -- builder.terminal:change_dir(builder.get_build_directory())
    builder.terminal:send('cd ' .. builder.get_build_directory())
  end
  builder.set_compile_commands()
end

builder.get_json = function(json_fn)
  local f = assert(io.open(json_fn, "r"))
  local content = f:read("*all")
  f:close()
  return vim.json.decode(content)
end

builder.get_cmake_presets_file = function()
  local user_presets_fn = vim.fn.getcwd() .. "/CMakeUserPresets.json"
  local presets_fn = vim.fn.getcwd() .. "/CMakePresets.json"
  if util.file_exists(user_presets_fn) then
    return user_presets_fn
  elseif util.file_exists(presets_fn) then
    return presets_fn
  else
    print("CMake[User]Presets" .. " does not exist!")
    return nil
  end
end

builder.get_cmake_presets = function()
  local cmake_presets_fn = builder.get_cmake_presets_file()
  if not cmake_presets_fn then
    return
  end
  return builder.get_json(cmake_presets_fn)
end

builder.set_compile_commands = function()
  custom_lsp.setup_clangd(builder.get_build_directory())
end

builder.configure_build = function()
  -- log.open_buffer()
  local cmake_presets = builder.get_cmake_presets()
  if cmake_presets == nil then return end
  if cmake_presets.configurePresets == nil then return end
  local options = {}

  for i, v in pairs(cmake_presets.configurePresets) do
    options[i] = v.name
  end
  builder.configurePresets = cmake_presets.configurePresets
  builder.selection("architecture, mode", options)
end

builder.get_build_directory = function()
  if builder.selected == nil then
    return vim.fn.getcwd()
  else
    return builder.selected.binaryDir:gsub("${sourceDir}", vim.fn.getcwd())
  end
end

builder.toggle_terminal = function()
  -- log.open_buffer()
  if builder.terminal == nil then
    local terminal = require('toggleterm.terminal').Terminal
    builder.terminal = terminal:new({
      dir = builder.get_build_directory(),
      -- window = vim.api.nvim_get_current_win(),
      direction = 'tab',
    })
  end
  builder.terminal:toggle()
end

return builder
