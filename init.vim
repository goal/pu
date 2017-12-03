" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/nplug')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'airblade/vim-gitgutter'

Plug 'mhinz/vim-grepper'

Plug 'ipod825/vim-netranger', { 'do': ':UpdateRemotePlugins' }

Plug 'mhartington/oceanic-next'

Plug 'sbdchd/neoformat'

" Initialize plugin system
call plug#end()

syntax enable
set tabstop=4
set expandtab
set termguicolors

let g:deoplete#enable_at_startup = 1

colorscheme OceanicNext

" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
set listchars=tab:»\ ,trail:-,extends:>,precedes:<,nbsp:+
set list                " Show problematic characters.

" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace guifg=red
match ExtraWhitespace /\s\+$\|\t/

if has("cscope")
    set csto=0
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif

nmap <C-x>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-x>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-x>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-x>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-x>T :cs find t 
nmap <C-x>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-x>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-x>F :cs find f 
nmap <C-x>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-x>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <C-x>a :cs find a <C-R>=expand("<cword>")<CR><CR>
