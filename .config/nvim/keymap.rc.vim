let mapleader = "\<Space>"

" easy-motion
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

" Move to line
map <leader>l <Plug>(easymotion-bd-jk)

" Move to word
map  <Leader>w <Plug>(easymotion-bd-w)

" find
nmap s <Plug>(easymotion-s2)

"" Fern
nnoremap <silent> <Leader>e :<C-u>Fern . -drawer -toggle<CR>
nnoremap <silent> <Leader>E :<C-u>Fern . -drawer -toggle -reveal=%<CR>

"" fzf-preview
nnoremap <silent> <C-p> :<C-u>FzfPreviewFromResourcesRpc project_mru git<CR>

"" telescope
nnoremap <leader>ff <cmd>Telescope find_files hidden=true<cr>
nnoremap <leader>fg <cmd>Telescope live_grep hidden=true<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

"" split window
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap ss :<C-u>sp<CR><C-w>j
nnoremap sv :<C-u>vs<CR><C-w>l

"" snippet
vnoremap <Leader>cnvj :s/"\(\w+\)":\s*"\(.\+\)"/\1='\2'/g<CR>
vnoremap <Leader>cnvr :s/\(\w+\)='\(.\+\)'/"\1": "\2"/g<CR>

