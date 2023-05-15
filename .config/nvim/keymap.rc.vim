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
nnoremap <silent> <Leader>e :<C-u>Fern . -drawer<CR>
nnoremap <silent> <Leader>E :<C-u>Fern . -drawer -reveal=%<CR>

"" fzf-preview
nnoremap <silent> <C-p> :<C-u>FzfPreviewFromResourcesRpc project_mru git<CR>

"" split window
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap ss :<C-u>sp<CR><C-w>j
nnoremap sv :<C-u>vs<CR><C-w>l

