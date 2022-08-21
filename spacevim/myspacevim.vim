function! myspacevim#before() abort
    let g:mapleader=','
endfunction

function! myspacevim#after() abort
	set listchars=tab:»\ ,trail:-,extends:>,precedes:<,nbsp:+
endfunction
