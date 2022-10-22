-- local pyramid = require'lualine.themes.pyramid'

-- require('lualine').setup {
--   options = {
--     icons_enabled = true,
--     -- theme = 'auto', -- auto matches the nvim theme (neodark, onenord..)
--     theme = pyramid,
--     component_separators = { left = '', right = ''},
--     section_separators = { left = '', right = ''},
--     disabled_filetypes = {},
--     always_divide_middle = true,
--     globalstatus = false,
--   },
--   -- This is the statusline
--   sections = {
--     lualine_a = {'mode'},
--     -- set file status to true to display modified/readonly icons
--     lualine_b = {{'filename', icon = '🧙', file_status = false,
--       symbols = { unnamed = '~', modified = '[+]', readonly = '[-]'}
--     }},
--     lualine_c = {
--         -- {'filename', icon = '🧙' },
--     },
--     lualine_x = {'filetype', 'progress'},
--     lualine_y = {},
--     lualine_z = {'location'}
--   },
--   inactive_sections = {},
--   tabline = {},
--   -- tabline = {
--     -- lualine_a = {},
--     -- lualine_b = {},
--     -- lualine_c = {},
--     -- lualine_x = {},
--     -- lualine_y = {},
--     -- lualine_z = {} -- 'tabs' for tab number, 'filename' for filename
--   -- },
--   extensions = {}
-- }








local colors = {
  blue   = '#80a0ff',
  cyan   = '#79dac8',
  black  = '#080808',
  white  = '#c6c6c6',
  red    = '#ff5189',
  violet = '#d183e8',
  grey   = '#303030',
  NONE   = '',
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.NONE },
    c = { fg = colors.NONE, bg = colors.NONE },
  },

  insert = { a = { fg = colors.black, bg = colors.blue } },
  visual = { a = { fg = colors.black, bg = colors.cyan } },
  replace = { a = { fg = colors.black, bg = colors.red } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.NONE, bg = colors.NONE },
  },
}

require('lualine').setup {
  options = {
    theme = bubbles_theme,
    component_separators = '|',
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    -- lualine_b = { 'filename', icon = '🧙', 'branch' },
    lualine_b = {{'filename', icon = '🧙', file_status = false,
      symbols = { unnamed = '~', modified = '[+]', readonly = '[-]'}
    }},
    lualine_c = { },
    lualine_x = { },
    lualine_y = { 'filetype', 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
}
