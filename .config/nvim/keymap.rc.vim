inoremap { {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap ( ()<Left>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

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

