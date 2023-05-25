set number

set list
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<

if !exists('g:vscode')
    " ordinary neovim
    set termguicolors
    colorscheme ayu-mirage
endif

