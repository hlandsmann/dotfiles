local M = {
  'jedrzejboczar/possession.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' }
}

M.config = function()
  local possession = require 'possession'
  local Path = require 'plenary.path'
  possession.setup {

    session_dir = (Path:new(vim.fn.stdpath('data')) / 'possession'):absolute(),
    silent = false,
    load_silent = true,
    debug = false,
    logfile = false,
    prompt_no_cr = false,
    autosave = {
      current = false,  -- or fun(name): boolean
      tmp = false,      -- or fun(): boolean
      tmp_name = 'tmp', -- or fun(): string
      on_load = true,
      on_quit = true,
    },
    commands = {
      save = 'PossessionSave',
      load = 'PossessionLoad',
      rename = 'PossessionRename',
      close = 'PossessionClose',
      delete = 'PossessionDelete',
      show = 'PossessionShow',
      list = 'PossessionList',
      migrate = 'PossessionMigrate',
    },
    hooks = {
      before_save = function()
        local selected_build_mode = require 'builder'.selected
        if selected_build_mode ~= nil then
          return { build_mode = selected_build_mode.name }
        else
          return {}
        end
      end,
      after_save = function(name, user_data, aborted) end,
      before_load = function(name, user_data)
        require 'builder'.get():close()
        return user_data
      end,
      after_load = function(name, user_data)
        local paths = require('possession.paths')
        local path = paths.session(name)
        local data = vim.json.decode(path:read())
        local builder = require 'builder'.get(data.cwd)
        -- print("data cwd :" .. (data.cwd or nil))
        if user_data.build_mode ~= nil then
          builder:configure_build(user_data.build_mode)
        else
          builder:set_compile_commands()
        end
        require'neocmake'.get():set_workspace_dir(data.cwd)
      end,
    },
    plugins = {
      close_windows = {
        hooks = { 'before_save', 'before_load' },
        preserve_layout = true, -- or fun(win): boolean
        match = {
          floating = true,
          buftype = {},
          filetype = {},
          custom = false, -- or fun(win): boolean
        },
      },
      delete_hidden_buffers = false,
      nvim_tree = true,
      tabby = true,
      dap = true,
      delete_buffers = true,
    },
    telescope = {
      list = {
        default_action = 'load',
        mappings = {
          save = { n = '<c-x>', i = '<c-x>' },
          load = { n = '<c-v>', i = '<c-v>' },
          delete = { n = '<c-t>', i = '<c-t>' },
          rename = { n = '<c-r>', i = '<c-r>' },
        },
      },
    },
  }
end

M.session_save_new = function()
  vim.ui.input({ prompt = "Name of session:" }, function(input)
    if input == nil or input == '' then return end
    require 'possession.session'.save(input)
  end)
end

M.session_save = function()
  local session_name = require('possession.session').session_name
  if session_name == nil then
    vim.ui.input({ prompt = "Name of session:" }, function(input)
      if input == nil or input == '' then return end
      require 'possession.session'.save(input)
    end)
  else
    require 'possession.session'.save(session_name, { no_confirm = true })
  end
end

return M
