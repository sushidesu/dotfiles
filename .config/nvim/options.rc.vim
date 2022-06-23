
" --- color ---
set termguicolors     " enable true colors support
let ayucolor="mirage"
colorscheme ayu

" background None
hi Normal guibg=NONE ctermbg=NONE

" --- option ---
" 全角文字をちゃんと表示する
set ambiwidth=double
" スワップファイルを作らない
set noswapfile
" バッファを隠す
set hidden
" クリップボードとNeovimの無名レジスタを一体化
set clipboard=unnamed
" 行番号
set number
" 空白文字等、不可視な文字の可視化
set list
set listchars=tab:>-,trail:*,nbsp:+
" インデントとか
" set smartindent
" set autoindent
" set visualbell

" アイコン表示用の幅を確保
set signcolumn=yes

" タブ関連
set expandtab " スペースを使う
set tabstop=2
set shiftwidth=2

" gitconfigではタブを使う
if expand("%:t") =~ ".*\.gitconfig"
  set noexpandtab
  set tabstop=4
  set shiftwidth=4
endif

set nowrap
set ignorecase
nmap <Esc><Esc> :nohlsearch<CR><Esc> 

" status bar
set laststatus=2
set statusline+=%y

" filetype
au BufNewFile,BufRead *.toml setf toml

