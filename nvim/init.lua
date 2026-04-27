-- Minimal Neovim config
-- Work in progress

-- Theme
vim.opt.termguicolors = true
vim.cmd.colorscheme("sorbet")

-- Line number
vim.opt.number = true
vim.opt.relativenumber = true

-- Navigation
vim.opt.wrap = false

-- Searching
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true

-- Misc
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.autowrite = false
vim.opt.mouse = "a" -- Mouse support

-- Tabbing
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- jk escape
vim.keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })

-- Mini.files browser 
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })
local minifiles = require('mini.files').setup({
    options = {
        use_as_default_explorer = true
    }
})

-- Map mini.files to '-'
vim.keymap.set('n', '-', function()
    local minifiles = require('mini.files')
    if not minifiles.close() then
        minifiles.open(vim.api.nvim_buf_get_name(0), true)
    end
end, { desc = "Toggle mini.files menu" })

-- Auto pairing for open and closing characters 
vim.pack.add({'https://github.com/windwp/nvim-autopairs'})
require("nvim-autopairs").setup()

-- Undo tree 
vim.pack.add({'https://github.com/mbbill/undotree'})
vim.keymap.set('n', '<F5>', vim.cmd.UndotreeToggle)

-- Surround selections 
vim.pack.add({'https://github.com/kylechui/nvim-surround'})

-- fzf for neovim
vim.pack.add({'https://github.com/ibhagwan/fzf-lua'})
require('fzf-lua').setup({})
