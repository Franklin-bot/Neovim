local function setup()


    local mode_width = 0
    local file_width = 0
    local active = false

    -- coloring for active/inactive harpoon entry
    local function get_harpoon_indicator(index, harpoon_entry)
        local path = harpoon_entry.value
        local last_file = path:match("^.+/(.+)$") or path
        return "%#LualineInactiveIndicator#" .. index .. " " .. last_file
    end

    local function get_active_indicator(index, harpoon_entry)
        local path = harpoon_entry.value
        local last_file = path:match("^.+/(.+)$") or path
        return "%#LualineActiveIndicator#" .. index .. " " .. last_file
    end

    local mode = {
        "mode",
        fmt = function(str)
            mode_width = #str
            return str
        end
        }

    local filename = {
        "filename",

        symbols = {
          modified = '',      -- Text to show when the file is modified.
          readonly = '',      -- Text to show when the file is non-modifiable or readonly.
          unnamed = '[No Name]', -- Text to show for unnamed buffers.
       },
        fmt = function(str)
            file_width = #str
            return str
        end
        }

    local hll =
        {
            "harpoon2",
            indicators = {
                function(harpoon_entry) return get_harpoon_indicator(1, harpoon_entry) end,
                function(harpoon_entry) return get_harpoon_indicator(2, harpoon_entry) end,
                function(harpoon_entry) return get_harpoon_indicator(3, harpoon_entry) end,
                function(harpoon_entry) return get_harpoon_indicator(4, harpoon_entry) end
            },
            active_indicators = {
                function(harpoon_entry) return get_active_indicator(1, harpoon_entry) end,
                function(harpoon_entry) return get_active_indicator(2, harpoon_entry) end,
                function(harpoon_entry) return get_active_indicator(3, harpoon_entry) end,
                function(harpoon_entry) return get_active_indicator(4, harpoon_entry) end
            },
            _separator = " ",
            no_harpoon = "Harpoon not loaded",
            fmt = function(str)
                    local utils = require "harpoon-lualine.utils"
                    local harpoon = require("harpoon")

                    local harpoon_entries = harpoon:list()
                    local len = harpoon_entries:length()
                    local total_width = vim.opt.columns:get()
                    local current_file_path = vim.api.nvim_buf_get_name(0)
                    local root_dir = harpoon_entries.config:get_root_dir()

                    local multiplier = 3 + 0.5 * len
                    local padding = math.floor(total_width/2) - math.floor(#str/multiplier) - mode_width - file_width

                    for i = 1, len do
                        local harpoon_path = harpoon:list():get(i).value
                        local full_path = nil
                        if utils.is_relative_path(harpoon_path) then
                            full_path = utils.get_full_path(root_dir, harpoon_path)
                        else
                            full_path = harpoon_path
                        end

                        if full_path == current_file_path or active == false then
                            padding = padding - 1
                            break
                        end
                    end

                    str = string.rep(" ", padding) .. str
                    return str
                end,
            cond = function()
                return vim.opt.columns:get() > 100
            end
        }

    local diff =
            {
                'diff',
                colored = true,
                always_visible = true,
                symbols = {added = '+', modified = '~', removed = '-'},
                diff_color = {
                    added    = { fg = '#ADD7FF', bg = '#282c34' }, -- Green foreground, custom background
                    modified = { fg = '#e4f0fb', bg = '#282c34' }, -- Yellow foreground, custom background
                    removed  = { fg = '#d0679d', bg = '#282c34' }, -- Red foreground, custom background
                },
            }


    -- configure lualine
    require('lualine').setup {
        options = {
            icons_enabled = false,
            component_separators = '',
            section_separators = '',
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = {mode},
            lualine_b = {filename},
            lualine_c = {hll},
            lualine_x = {},
            lualine_y = {'branch'},
            lualine_z = {diff},
        },
    }
    vim.cmd('highlight LualineActiveIndicator guifg=#d0679d')
    vim.cmd('highlight LualineInactiveIndicator guifg=#e4f0fb')
end

local M = {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = setup
}

return M
