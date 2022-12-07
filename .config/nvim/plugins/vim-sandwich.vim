let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)
let g:sandwich#recipes += [
\ {
\   'buns':         ['_', '_'],
\   'quoteescape':  1,
\   'expand_range': 0,
\   'nesting':      1,
\   'linewise':     0,
\   'match_syntax': 1,
\ },
\ {
\   'buns':         ['-', '-'],
\   'quoteescape':  1,
\   'expand_range': 0,
\   'nesting':      1,
\   'linewise':     0,
\   'match_syntax': 1,
\ },
\ {
\   'buns':         ['/', '/'],
\   'quoteescape':  1,
\   'expand_range': 0,
\   'nesting':      0,
\   'linewise':     0,
\   'match_syntax': 1,
\ },
\ {
\   'buns':     ['/* ', ' */'],
\   'input':    ['/*'],
\   'filetype': ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
\ },
\ {
\   'buns':     ['${', '}'],
\   'input':    ['$'],
\   'filetype': ['javascript', 'javascriptreact', 'typescript', 'typescriptreact'],
\ },
\ {
\   'buns':     ['#{', '}'],
\   'input':    ['#'],
\   'filetype': ['ruby', 'eruby'],
\ },
\ {
\   'buns':     ['-> () {', '}'],
\   'input':    ['->'],
\   'kind':     ['add'],
\   'filetype': ['ruby', 'eruby'],
\ },
\ {
\   'buns':     ['<% ', ' %>'],
\   'input':    ['%'],
\   'filetype': ['eruby'],
\ },
\ {
\   'buns':     ['<%= ', ' %>'],
\   'input':    ['='],
\   'filetype': ['eruby'],
\ },
\ ]

