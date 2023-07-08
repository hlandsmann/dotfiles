local builder = {}

local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local util = require 'misc.util'
local custom_lsp = require 'config.lspconfig'
local log = require 'builder.debugbuf'

local get_json = function(json_fn)
  local f = assert(io.open(json_fn, "r"))
  local content = f:read("*all")
  f:close()
  return vim.json.decode(content)
end

local get_cmake_presets_filename = function(workspace_dir)
  local user_presets_fn = workspace_dir .. "/CMakeUserPresets.json"
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

local get_cmake_presets = function(workspace_dir)
  local cmake_presets_fn = get_cmake_presets_filename(workspace_dir)
  if not cmake_presets_fn then
    return
  end
  return get_json(cmake_presets_fn)
end

local get_configurePresets = function(workspace_dir)
  local cmake_presets = get_cmake_presets(workspace_dir)
  if cmake_presets == nil then return nil end
  return cmake_presets.configurePresets
end


Builder = {
  terminal = nil,
  selected = nil,
  configurePresets = nil,
  workspace_dir = nil,
}

local obj = nil
function Builder.get(cwd)
  if obj ~= nil and cwd == nil then return obj end

  cwd = cwd or vim.fn.getcwd()
  print("cwd is: " .. (cwd or "nil"))
  obj = Builder
  obj.workspace_dir = cwd
  obj.configurePresets = get_configurePresets(cwd)
  obj.selected = nil
  obj.terminal = nil
  return obj
end

function Builder:close()
  if self.terminal == nil then return end
  if self.terminal:is_open() then self.terminal:close() end
  -- obj = nil
end

function Builder:select_build_mode(title, choice, opts)
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
        self:apply_selection(selection[1])
      end)
      return true
    end,
  }):find()
end

function Builder:set_compile_commands()
  custom_lsp.setup_clangd(self:get_build_directory())
end

function Builder:apply_selection(name)
  for _, v in pairs(self.configurePresets) do
    if name == v.name then self.selected = v end
  end

  if self.terminal ~= nil then
    self.terminal:send('cd ' .. self:get_build_directory())
  end
  self:set_compile_commands()
end

function Builder:configure_build(build_mode)
  -- log.open_buffer()
  -- log.log("build mode is: " .. (build_mode or "nil"))
  -- print("build mode is: " .. (build_mode or "nil"))

  if self.configurePresets == nil then return end
  local options = {}

  if build_mode == nil then
    for i, v in pairs(self.configurePresets) do
      options[i] = v.name
    end
    self:select_build_mode("architecture, mode", options)
  else
    self:apply_selection(build_mode)
  end
end

function Builder:get_build_directory()
  if self.selected == nil then
    return self.workspace_dir
  else
    return self.selected.binaryDir:gsub("${sourceDir}", self.workspace_dir)
  end
end

function Builder:toggle_terminal()
  -- log.open_buffer()
  if self.terminal == nil then
    local terminal = require('toggleterm.terminal').Terminal
    -- log.log(self:get_build_directory())
    self.terminal = terminal:new({
      dir = self:get_build_directory(),
      -- window = vim.api.nvim_get_current_win(),
      direction = 'tab',
      on_exit = function()
        self.terminal = nil
      end
    })
  end
  self.terminal:toggle()
end

return Builder
