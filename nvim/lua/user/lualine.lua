-- tango is my custom theme in .local/share/nvim/plugged/lualine/lua/themes
-- local custom_theme = require'lualine.themes.tango'
local pyramid = require'lualine.themes.pyramid'

-- Change the background of lualine_c section to transparant for all modes
-- Most themes only have normal.c and inactive.c!
-- custom_theme.normal.c.bg = 'NONE'
-- custom_theme.insert.c.bg = 'NONE'
-- custom_theme.command.c.bg = 'NONE'
-- custom_theme.visual.c.bg = 'NONE'
-- custom_theme.inactive.c.bg = 'NONE'

-- i wanna make my own config. with the b section being non invisible but with some cool colors
-- custom_theme.normal.b.bg = 'NONE'
-- custom_theme.insert.b.bg = 'NONE'
-- custom_theme.command.b.bg = 'NONE'
-- custom_theme.visual.b.bg = 'NONE'
-- custom_theme.inactive.b.bg = 'NONE'

require('lualine').setup {
  options = {
    icons_enabled = true,
    -- theme = 'auto', -- auto matches the nvim theme (neodark, onenord..)
    theme = pyramid,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  -- This is the statusline
  sections = {
    lualine_a = {'mode'},
    -- set file status to true to display modified/readonly icons
    lualine_b = {{'filename', icon = '🧙', file_status = false,
      symbols = { unnamed = '~', modified = '[+]', readonly = '[-]'}
    }},
    lualine_c = {
        -- {'filename', icon = '🧙' },
    },
    lualine_x = {'filetype', 'progress'},
    lualine_y = {},
    lualine_z = {'location'}
  },
  inactive_sections = {},
  tabline = {},
  -- tabline = {
    -- lualine_a = {},
    -- lualine_b = {},
    -- lualine_c = {},
    -- lualine_x = {},
    -- lualine_y = {},
    -- lualine_z = {} -- 'tabs' for tab number, 'filename' for filename
  -- },
  extensions = {}
}
