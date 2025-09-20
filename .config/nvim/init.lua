-- Minimal Neovim configuration
-- Convert options from options.rc.vim to Lua

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.opt.number = true

vim.opt.list = true
vim.opt.listchars = {eol='$', tab='>-', trail='~', extends='>', precedes='<'}

-- General vim options (moved from coc-options.vim for better organization)
-- if hidden is not set, TextEdit might fail.
vim.opt.hidden = true

-- Some servers have issues with backup files, see #649
vim.opt.backup = false
vim.opt.writebackup = false

-- Better display for messages
vim.opt.cmdheight = 2

-- You will have bad experience for diagnostic messages when it's default 4000.
vim.opt.updatetime = 300

-- don't give |ins-completion-menu| messages.
vim.opt.shortmess:append('c')

-- always show signcolumns
vim.opt.signcolumn = 'yes'

if not vim.g.vscode then
    -- ordinary neovim
    vim.opt.termguicolors = true
    -- colorscheme ayu-mirage (commented out as plugin not available)
    -- vim.cmd('colorscheme ayu-mirage')
    -- vim.cmd('colorscheme gruvbox')
    -- vim.opt.background = 'dark'
else
    -- fold
    -- https://github.com/vscode-neovim/vscode-neovim/pull/502#issuecomment-831682643
    vim.keymap.set('n', 'za', '<Cmd>call VSCodeNotify("editor.toggleFold")<CR>', { silent = true })
    vim.keymap.set('n', 'zR', '<Cmd>call VSCodeNotify("editor.unfoldAll")<CR>', { silent = true })
    vim.keymap.set('n', 'zM', '<Cmd>call VSCodeNotify("editor.foldAll")<CR>', { silent = true })
    vim.keymap.set('n', 'zo', '<Cmd>call VSCodeNotify("editor.unfold")<CR>', { silent = true })
    vim.keymap.set('n', 'zO', '<Cmd>call VSCodeNotify("editor.unfoldRecursively")<CR>', { silent = true })
    vim.keymap.set('n', 'zc', '<Cmd>call VSCodeNotify("editor.fold")<CR>', { silent = true })
    vim.keymap.set('n', 'zC', '<Cmd>call VSCodeNotify("editor.foldRecursively")<CR>', { silent = true })

    vim.keymap.set('n', 'z1', '<Cmd>call VSCodeNotify("editor.foldLevel1")<CR>', { silent = true })
    vim.keymap.set('n', 'z2', '<Cmd>call VSCodeNotify("editor.foldLevel2")<CR>', { silent = true })
    vim.keymap.set('n', 'z3', '<Cmd>call VSCodeNotify("editor.foldLevel3")<CR>', { silent = true })
    vim.keymap.set('n', 'z4', '<Cmd>call VSCodeNotify("editor.foldLevel4")<CR>', { silent = true })
    vim.keymap.set('n', 'z5', '<Cmd>call VSCodeNotify("editor.foldLevel5")<CR>', { silent = true })
    vim.keymap.set('n', 'z6', '<Cmd>call VSCodeNotify("editor.foldLevel6")<CR>', { silent = true })
    vim.keymap.set('n', 'z7', '<Cmd>call VSCodeNotify("editor.foldLevel7")<CR>', { silent = true })

    vim.keymap.set('x', 'zV', '<Cmd>call VSCodeNotify("editor.foldAllExcept")<CR>', { silent = true })

    -- move fold
    -- https://github.com/vscode-neovim/vscode-neovim/issues/58#issuecomment-630551787
    -- vim.keymap.set('n', 'j', 'gj')
    -- vim.keymap.set('n', 'k', 'gk')
end

-- Setup lazy.nvim with plugins
local plugins = {
    -- Auto close parentheses (both VSCode and regular Neovim)
    "cohama/lexima.vim",
    
    -- Surround text objects (both VSCode and regular Neovim)
    "machakann/vim-sandwich",
}

-- Add regular Neovim-only plugins
if not vim.g.vscode then
    -- Colorscheme (only in regular Neovim)
    table.insert(plugins, {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    })
    
    -- Add more regular Neovim-only plugins here
else
    -- VSCode-specific plugins can be added here
    -- Example:
    -- table.insert(plugins, "some-vscode-specific-plugin")
end

require("lazy").setup(plugins)