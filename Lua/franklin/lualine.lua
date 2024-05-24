local function setup()
    require('lualine').setup {
      options = {
        icons_enabled = false,
        component_separators = '|',
        section_separators = '|',
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {'mode'},
        lualine_x = {'branch', 'diff'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
      }
    }
end

local M = {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = setup
}

return M


