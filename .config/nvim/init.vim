" Install dein
let $CACHE = expand('~/.cache')
if !($CACHE->isdirectory())
  call mkdir($CACHE, 'p')
endif
if &runtimepath !~# '/dein.vim'
  let s:dir = 'dein.vim'->fnamemodify(':p')
  if !(s:dir->isdirectory())
    let s:dir = $CACHE .. '/dein/repos/github.com/Shougo/dein.vim'
    if !(s:dir->isdirectory())
      execute '!git clone https://github.com/Shougo/dein.vim' s:dir
    endif
  endif
  execute 'set runtimepath^='
        \ .. s:dir->fnamemodify(':p')->substitute('[/\\]$', '', '')
endif


"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim


" Required:
call dein#begin('~/.cache/dein')

" Let dein manage dein
" Required:
call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')


if exists('g:vscode')
    " plugins for vscode
    call dein#add('asvetliakov/vim-easymotion', { 'merged': 0 })
    call dein#load_toml('~/.dotfiles/.config/nvim/dein_vscode.toml', {'lazy': 0 })
else
    " plugins for nvim
    call dein#add('easymotion/vim-easymotion', { 'merged': 0 })
    call dein#load_toml('~/.dotfiles/.config/nvim/dein.toml', {'lazy': 0 })
    call dein#load_toml('~/.dotfiles/.config/nvim/dein_lazy.toml', {'lazy': 1 })
endif

" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"End dein Scripts-------------------------


if !exists('g:vscode')
  luafile ~/.config/nvim/plugins/treesitter.lua
  luafile ~/.config/nvim/plugins/barbar.lua
  source ~/.config/nvim/plugins/fern.vim
  source ~/.config/nvim/keymap.rc.vim
  source ~/.config/nvim/options.rc.vim
  source ~/.config/nvim/plugins/vim-sandwich.vim
  luafile ~/.config/nvim/plugins/dial.lua
  luafile ~/.config/nvim/plugins/telescope.lua
  luafile ~/.config/nvim/plugins/devicons.lua
endif

" Your .vimrc
highlight QuickScopePrimary gui=underline
hi EasyMotionShade ctermfg=black guifg=#3b3d4a

