local function setup()
    local poi = require "poimandres"
    poi.setup()
    vim.cmd.colorscheme "poimandres"
end

local M = {
    'olivercederborg/poimandres.nvim',
    config = setup
}

return M

