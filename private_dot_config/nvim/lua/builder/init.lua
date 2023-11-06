local builder = {}

local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local conf = require("telescope.config").values
local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local util = require 'misc.util'
local custom_lsp = require 'config.lspconfig'
local log = require 'builder.debugbuf'
local cmake = require 'builder.cmake'

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
        self:apply_selection(selection[1])
      end)
      return true
    end,
  }):find()
end

function Builder:set_compile_commands()
  local build_dir = self:get_build_directory()
  if build_dir ~= nil then
    custom_lsp.setup_clangd(self:get_build_directory())
    return
  end

  local Path = require 'plenary.path'
  if (Path:new(self.workspace_dir .. 'compile_commands.json'):exists()) then
    custom_lsp.setup_clangd(self.workspace_dir)
    return build_dir
  end
end

function Builder:apply_selection(name)
  for _, v in pairs(self.configurePresets) do
    if name == v.name then self.selected = v end
  end

  if self.terminal ~= nil then
    local cbd_alias = 'alias cbd=\'cd ' .. self:get_build_directory() .. '\''
    self.terminal:send({ cbd_alias, 'cbd' })
  end
  self:set_compile_commands()
end

function Builder:configure_build(build_mode)
  -- log.open_buffer()

  if self.configurePresets == nil then return end
  local options = {}

  if build_mode == nil then
    for i, v in pairs(self.configurePresets) do
      options[i] = v.name
    end
    self:select_build_mode("architecture, mode", options)
  else
    self:apply_selection(build_mode)
    -- self:cmake_tools_setup()
  end
end

function Builder:get_build_directory()
  if self.selected ~= nil then
    return self.selected.binaryDir:gsub("${sourceDir}", self.workspace_dir)
  end
  return nil
end

function Builder:get_init_directory()
  local Path = require 'plenary.path'
  local build_dir = self:get_build_directory()
  if (build_dir ~= nil and Path:new(build_dir):exists()) then return build_dir end
  return self.workspace_dir
end

function Builder:toggle_terminal()
  -- log.open_buffer()
  if self.terminal == nil then
    local terminal = require('toggleterm.terminal').Terminal
    -- log.log(self:get_build_directory())
    self.terminal = terminal:new({
      dir = self:get_init_directory(),
      -- window = vim.api.nvim_get_current_win(),
      direction = 'tab',
      on_exit = function()
        -- self.terminal = nil
      end
    })
    local cwd_alias = 'alias cwd=\'cd ' .. self.workspace_dir .. '\''
    local cbd_alias = 'alias cbd=\'cd ' .. (self:get_build_directory() or self.workspace_dir) .. '\''
    self.terminal:spawn()
    self.terminal:send({ cwd_alias, cbd_alias, 'clear' })
  end
  self.terminal:toggle()
end

-- function Builder:cmake_tools_setup()
--   require("cmake-tools").setup {
--     cmake_command = "cmake",                                          -- this is used to specify cmake command path
--     cmake_regenerate_on_save = true,                                  -- auto generate when save CMakeLists.txt
--     cmake_generate_options = { "-DCMAKE_EXPORT_COMPILE_COMMANDS=1" }, -- this will be passed when invoke `CMakeGenerate`
--     cmake_build_options = {},                                         -- this will be passed when invoke `CMakeBuild`
--     cmake_build_directory = self:get_build_directory(),               -- this is used to specify generate directory for cmake
--     cmake_build_directory_prefix = "cmake_build_",                    -- when cmake_build_directory is set to "", this option will be activated
--     cmake_soft_link_compile_commands = true,                          -- this will automatically make a soft link from compile commands file to project root dir
--     cmake_compile_commands_from_lsp = false,                          -- this will automatically set compile commands file location using lsp, to use it, please set `cmake_soft_link_compile_commands` to false
--     cmake_kits_path = nil,                                            -- this is used to specify global cmake kits path, see CMakeKits for detailed usage
--     cmake_variants_message = {
--       short = { show = true },                                        -- whether to show short message
--       long = { show = true, max_length = 40 }                         -- whether to show long message
--     },
--     cmake_dap_configuration = {
--       -- debug settings for cmake
--       name = "cpp",
--       type = "codelldb",
--       request = "launch",
--       stopOnEntry = false,
--       runInTerminal = true,
--       console = "integratedTerminal",
--     },
--     cmake_always_use_terminal = false, -- if true, use terminal for generate, build, clean, install, run, etc, except for debug, else only use terminal for run, use quickfix for others
--     cmake_quickfix_opts = {
--       -- quickfix settings for cmake, quickfix will be used when `cmake_always_use_terminal` is false
--       show = "always",         -- "always", "only_on_error"
--       position = "belowright", -- "bottom", "top"
--       size = 10,
--     },
--     cmake_terminal_opts = {
--       -- terminal settings for cmake, terminal will be used for run when `cmake_always_use_terminal` is false or true, will be used for all tasks except for debug when `cmake_always_use_terminal` is true
--       name = "Main Terminal",
--       prefix_name = "[CMakeTools]: ", -- This must be included and must be unique, otherwise the terminals will not work. Do not use a simple spacebar " ", or any generic name
--       split_direction = "horizontal", -- "horizontal", "vertical"
--       split_size = 11,
--
--       -- Window handling
--       single_terminal_per_instance = true,  -- Single viewport, multiple windows
--       single_terminal_per_tab = true,       -- Single viewport per tab
--       keep_terminal_static_location = true, -- Static location of the viewport if avialable
--
--       -- Running Tasks
--       start_insert_in_launch_task = false, -- If you want to enter terminal with :startinsert upon using :CMakeRun
--       start_insert_in_other_tasks = false, -- If you want to enter terminal with :startinsert upon launching all other cmake tasks in the terminal. Generally set as false
--       focus_on_main_terminal = false,      -- Focus on cmake terminal when cmake task is launched. Only used if cmake_always_use_terminal is true.
--       focus_on_launch_terminal = false,    -- Focus on cmake launch terminal when executable target in launched.
--     }
--   }
-- end

function Builder:cmake_targets()
  -- log.open_buffer()
  -- log.log(log.dump(targets))
end

return Builder
