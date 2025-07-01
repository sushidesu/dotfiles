let mapleader = "\<Space>"

"" tailwind classes to quotes
vnoremap <Leader>t :s/^\s*"\(.*\)",\?$/\=substitute(submatch(1), '\S\+', '"&"', 'g')/e<CR>:'<,'>s/" "/", "/g<CR>
