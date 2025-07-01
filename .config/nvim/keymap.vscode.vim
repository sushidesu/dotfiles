let mapleader = "\<Space>"

"" tailwind classes to quotes
" vnoremap <Leader>t :s/\([^ ,][^ ,]*\)/"\1"/g<CR>:s/"" \|" "/", /g<CR>:s/^""\|""$//g<CR>
"" tailwind classes to quotes
" vnoremap <Leader>t :s/\([^ ]\+\)/"\1"/g<CR>:s/^""\|""$//g<CR>:s/" "/", /g<CR>
"" tailwind classes to quotes
" vnoremap <Leader>t :s/\([^ ]\+\)/"\1"/g<CR>:'<,'>s/^""\|""$//g<CR>:'<,'>s/" "/", /g<CR>
"" tailwind classes to quotes
" vnoremap <Leader>t :s/\([^ ]\+\)/"\1"/g<CR>:'<,'>s/^""\|",$//g<CR>:'<,'>s/" "/", /g<CR>
"" tailwind classes to quotes
" vnoremap <Leader>t :s/\([^ ]\+\)/"\1"/g<CR>:'<,'>s/^[ ]*""//g<CR>:'<,'>s/","$//g<CR>:'<,'>s/" "/", /g<CR>
"" tailwind classes to quotes
" vnoremap <Leader>t :s/\([^ ,]\+\)/"\1"/g<CR>
"" tailwind classes to quotes
" vnoremap <Leader>t :s/^\s*"//"<CR>:s/"",\s*$//e<CR>:s/" "/", "/g<CR>
"" tailwind classes to quotes
" vnoremap <Leader>t :'<,'>s/^\s*"//"<CR>:'<,'>s/"",\s*$//e<CR>:'<,'>s/" "/", "/g<CR>
"" tailwind classes to quotes
vnoremap <Leader>t :s/^\s*"\(.*\)",\?$/\=substitute(submatch(1), '\S\+', '"&"', 'g')/e<CR>:'<,'>s/" "/", "/g<CR>
