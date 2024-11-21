local function setup()
    require('neoscroll').setup({})

    local t = {}
    t['<leader>j'] = {'scroll', {'vim.wo.scroll', 'true', '100'}}
    t['<leader>k'] = {'scroll', {'-vim.wo.scroll', 'true', '100'}}
    require('neoscroll.config').set_mappings(t)
end



local M = {
  "karb94/neoscroll.nvim",
  config = setup
}


return M
