-- Minimal Neovim config
-- Work in progress
-- Possible future additions: conform.nvm, nvim.lint

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

-- Packages
vim.pack.add({
    'https://github.com/nvim-mini/mini.nvim', -- file tree
    'https://github.com/windwp/nvim-autopairs', -- add pairs in insert mode
    'https://github.com/mbbill/undotree', -- undotree
    'https://github.com/ibhagwan/fzf-lua', -- fast fzf searching, requires fzf
    'https://github.com/kylechui/nvim-surround', -- add pairs in visual/normal mode
    'https://github.com/mason-org/mason.nvim', -- LSP package manager
    'https://github.com/neovim/nvim-lspconfig', -- LSP configurations 
    'https://github.com/mason-org/mason-lspconfig.nvim', -- links lspconfig and mason
    'https://github.com/saghen/blink.lib', -- blink dependency
    'https://github.com/Saghen/blink.cmp' -- code completion, requires rust tools
})

-- Setup packages w/ no additional configuration
local packageDefaultSetup = {'nvim-autopairs', 'fzf-lua', 'mason', 'mason-lspconfig'}
for _, val in ipairs(packageDefaultSetup) do
    require(val).setup()
end

-- blink build and setup
local cmp = require('blink.cmp')
cmp.build():wait(60000)
cmp.setup()

-- Mini.files configuration 
local minifiles = require('mini.files').setup({
    options = {
        use_as_default_explorer = true
    }
})
vim.keymap.set('n', '-', function() -- Maps mini files to '-'
    local minifiles = require('mini.files')
    if not minifiles.close() then
        minifiles.open(vim.api.nvim_buf_get_name(0), true)
    end
end, { desc = "Toggle mini.files menu" })

-- Undo tree mapped to f5
vim.keymap.set('n', '<F5>', vim.cmd.UndotreeToggle)
