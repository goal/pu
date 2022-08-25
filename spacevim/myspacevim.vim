function! myspacevim#before() abort
    let g:mapleader=','
    nnoremap <silent><Leader>m m
endfunction

function! myspacevim#after() abort
    let g:airline_symbols.linenr = ''
endfunction
