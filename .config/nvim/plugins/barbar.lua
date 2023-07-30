require'bufferline'.setup {
}
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Move to previous/next
map('n', '<C-h>', '<Cmd>BufferPrevious<CR>', opts)
map('n', '<C-l>', '<Cmd>BufferNext<CR>', opts)
-- Close buffer
-- map('n', '<C-a>', '<Cmd>BufferClose<CR>', opts)
