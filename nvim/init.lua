-- Minimal Neovim config
-- Work in progress
--
-- Change default leader
vim.g.mapleader = " "

-- Theme
vim.opt.termguicolors = true
vim.cmd.colorscheme("retrobox")

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
    'https://github.com/Saghen/blink.cmp', -- code completion, requires rust tools
    'https://github.com/nvim-treesitter/nvim-treesitter-context', -- code context
    'https://github.com/romus204/tree-sitter-manager.nvim', -- manage parsers 
    'https://github.com/nvim-mini/mini.statusline' -- basic status line
})

-- Setup packages w/ no additional configuration
local packageDefaultSetup = {'nvim-autopairs', 'mason', 'mason-lspconfig', 'mini.statusline'}
for _, val in ipairs(packageDefaultSetup) do
    require(val).setup()
end

-- treesitter config
require('tree-sitter-manager').setup({
    auto_install = true
})

-- Scope context 
require('treesitter-context').setup({
    enable = true,
    mode = 'topline' -- you can also use cursor
})

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

-- Open Lazy Git
vim.api.nvim_create_user_command("LGit", "terminal lazygit", {})

-- View pre-save diff ("What's up?")
vim.api.nvim_create_user_command("WUp", "w !diff % -", {})

-- Search current selection
local fzf = require("fzf-lua")
fzf.setup({ fzf_colors = true })
vim.keymap.set("v", "<leader>fv", fzf.grep_visual, { desc = "FzfLua grep visual selection" })
vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Open FzfLua files" })
vim.keymap.set("n", "<leader>fl", fzf.lines, { desc = "Fzf current file" })
