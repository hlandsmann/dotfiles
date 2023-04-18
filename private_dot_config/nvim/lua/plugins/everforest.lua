local M = {
  "neanias/everforest-nvim",
}

M.config = function()
  require("everforest").setup({
    background = "hard",
    -- How much of the background should be transparent. Options are 0, 1 or 2.
    -- Default is 0.
    --
    -- 2 will have more UI components be transparent (e.g. status line
    -- background).
    transparent_background_level = 0,
    -- Whether italics should be used for keywords, builtin types and more.
    italics = false,
    -- Disable italic fonts for comments. Comments are in italics by default, set
    -- this to `true` to make them _not_ italic!
    disable_italic_comments = false,
    -- Your config here
  })
end

return M
