set nocompatible
syntax on

set nofen  "nofoldenable
set nu  "number"
set autochdir
set foldmethod=indent
set fileencodings=utf-8 "",ucs-bom,gb18030,ucs-2
set encoding=utf-8
set smartindent
set expandtab
set tabstop=4
set shiftwidth=4
set backupdir=~/.backup
set dy=lastline
set showcmd
set ambiwidth=double  "width of ambigous char
set scrolloff=4
set backspace=indent,eol,start
set laststatus=2
set clipboard+=unnamed
set hlsearch

let g:lpc_syntax_for_c=1
source ~/S/vimp/vim-pathogen/autoload/pathogen.vim
call pathogen#infect('~/S/vimp/{}')
filetype indent plugin on
" press v in quickfix window to preview
au FileType qf :nnoremap <buffer> v <Enter>zz:wincmd p<Enter>
set cul

colorscheme peachpuff

autocmd BufRead *.decl set filetype=c
autocmd BufRead *.py,*.pyw set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
""autocmd BufWritePre *.py,*.pyw :%s/\s\+$//e
autocmd BufWritePre *.py,*.pyw set encoding=utf-8

autocmd BufRead *.html nmap <F5> :set ft=jinja <CR> :set sw=2 <CR>
autocmd BufRead *.c setf lpc
autocmd BufEnter *.c,*.h set noexpandtab
autocmd BufLeave *.c,*.h set expandtab
autocmd BufRead *.c nmap <F5> :set ft=c <CR>
autocmd BufNewFile,BufRead *.snip,*.snippet setf snippet
"autocmd InsertCharPre * let v:char=toupper(v:char)
"autocmd VimEnter,VimLeave * silent !tmux set status > /dev/null 2> /dev/null
autocmd VimEnter * silent QuickfixsignsDisable

""nmap <Tab> :ls<CR>:confirm:b!
nnoremap <Tab> <ESC>:call SwitchBuf()<CR>
nmap <silent> <F2> :bp<CR>
nmap <silent> <F3> :bn<CR>
nmap <silent> <F4> :b#<CR>:bd#<CR>
"nmap <silent> <F7> :s/^\(.*\)\$ "\(.*\) = " ++ (show \$ \(.*\))$/\1\$ "\2 = " ++ (show \$ \2)/g<CR>
nnoremap <silent> <F6> <ESC>:%s/(\s*\([^)]*\S\)\s*)/(\1)/g<CR>:noh<CR>
nnoremap <silent> <F7> :NERDTreeToggle<CR>
nnoremap <silent> <F9> <ESC>:s/\("[^"]*"\)/T(\1)/g<CR>:noh<CR>
nmap <silent> <F11> :%s/^\(\s*print\)\s\+\([^(].*\)\s*$/\1(\2)/g<CR>
nnoremap <silent> <F12> <ESC>:call ToggleComment()<CR>
inoremap <CR> <C-R>=CEndLine()<CR>
vnoremap // y/<C-R>"<CR>

function! TString()
python <<PYTHONEOF
import vim
line = vim.current.line
_sline = line.split('"')
_sline = [j + "T(" if i // 2 % 2 == 0 else j + ")" for i, j in enumerate(_sline)]
vim.current.line = '"'.join(_sline)
PYTHONEOF
endfunction

function! CEndLine()
python <<PYTHONEOF
import vim
line = vim.current.line
cw = vim.current.window
r, c = cw.cursor
if c > 1 and line[c - 1] == ';' and ')' in line[c:]:
    vim.current.line = line[:c - 1] + line[c:] + ';'
    cw.cursor = r, 9999
    vim.command('return ""')
else:
    vim.command('return "\<CR>"')
PYTHONEOF
endfunction

function! SwitchBuf()
python <<PYTHONEOF
import vim
vim.command("ls")
def py_input(msg = "input"):
    vim.command("call inputsave()")
    vim.command("let user_input = input('" + msg +": ')")
    vim.command("call inputrestore()")
    return vim.eval('user_input')
bs = py_input("Select buffer[#]")
bs = bs if bs else '#'
bs = '%' if bs == ' ' else bs
try:
    vim.command("b!" + bs)
except vim.error:
    print "SwitchBuf Error!"
PYTHONEOF
endfunction

function! ToggleComment()
python << PYTHONEOF
import vim
ft = vim.eval("&ft").lower()
line = vim.current.line
if ft == 'python':
    comment_sign = '#'
    if line.lstrip().startswith(comment_sign):
        while line.lstrip().startswith(comment_sign):
            p = line.index(comment_sign)
            line = line[:p] + line[p + 1:]
            vim.current.line = line
    else:
        vim.current.line = '#' + line
elif ft in ['c', 'cpp']:
    if line.lstrip().startswith("/*"):
        p1 = line.index("/*")
        p2 = line.index("*/")
        vim.current.line = line[:p1] + line[p1 + 2: p2] + line[p2 + 2:]
    else:
        vim.current.line = '/*' + line + '*/'
PYTHONEOF
endfunction

function! CCC(s)
python <<PYTHONEOF
import vim
print(vim.eval("a:s"))
PYTHONEOF
endfunction

autocmd filetype c,cpp inoremap { <ESC>:call CloseBrace()<CR>a

function CloseBrace()
python << PYTHONEOF
import vim
line = vim.current.line
cw = vim.current.window
r, c = cw.cursor
if "=" in line or line.split():
    vim.current.line = line[:c + 1] + '{}' + line[c + 1:]
    cw.cursor = (r, c + 1)
else:
    cb = vim.current.buffer
    tline = cb[r - 2]
    n = tline.index(tline.strip()[0])
    if tline.startswith(" "):
        cb[r - 1:r - 1] = [' ' * n + '{', ' ' * (n + 4), ' ' * n + '}']
    else:
        cb[r - 1:r - 1] = ['\t' * n + '{', '\t' * (n + 1), '\t' * n + '}']
    del cb[r + 2]
    cw.cursor = (r + 1, 188)
PYTHONEOF
endfunction

"let g:tagbar_ctags_bin = '/home/wyj/bin/ctags'
let g:tagbar_left=1
let g:tagbar_sort=0
let g:tagbar_width=30
let g:tagbar_autoshowtag=1
let g:tagbar_expand=1
""autocmd VimEnter * nested :call tagbar#autoopen(1)
nnoremap <silent> <F8> :TagbarToggle<CR>

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

dig 1o 9312
dig 2o 9313
dig 3o 9314
dig 4o 9315
dig 5o 9316
dig 6o 9317
dig 7o 9318
dig 8o 9319
dig 9o 9320
dig 0o 9321

function! GetName()
python <<PYTHONEOF
import os
import vim
#path = os.getcwd()
path = vim.eval('expand("%:p:h")')
cnt = path.count("/")
if cnt > 2:
    for i in range(cnt - 2):
        path = path[path.index("/")+1:]
vim.command('let show_name="' + path + '"')
vim.command('return show_name')
PYTHONEOF
endfunction

set statusline=
set statusline +=%1*\ %n\ %*            "buffer number
set statusline +=%4*\ %<%t\ %*            "file name(tail)
set statusline +=%2*[%*
set statusline +=%5*%{&filetype}%*                "file type
set statusline +=%2*\,%*
set statusline +=%3*\ %{&fenc}%*          "file encoding
set statusline +=%2*\,%*
set statusline +=%5*\ %{&ff}%*            "file format
set statusline +=%2*]%*
set statusline +=%2*%m%*                "modified flag
set statusline +=%3*%=%{GetName()}%*
set statusline +=%1*%5l%*             "current line
set statusline +=%2*/%L%*               "total lines
set statusline +=%1*%4v\ %*             "virtual column number
set statusline +=%2*0x%04B\ %*          "character under cursor

hi User1 ctermfg=Brown   ctermbg=Black
hi User2 ctermfg=DarkRed ctermbg=Black
hi User3 ctermfg=LightRed  ctermbg=Black
hi User4 ctermfg=Magenta ctermbg=Black
hi User5 ctermfg=Yellow ctermbg=Black

let g:ctrlp_regexp = 1
let g:ctrlp_max_height = 15
let g:ctrlp_open_new_file = 'h'
let g:ctrlp_extensions = ['mixed']

" Multiple VCS's:
let g:ctrlp_user_command = {
\ 'types': {
  \ 1: ['.git', 'cd %s && git ls-files'],
  \ 2: ['.hg', 'hg --cwd %s locate -I .'],
  \ },
\ 'fallback': 'find %s -type f'
\ }

"let g:Powerline_theme = 'default'
let g:syntastic_check_on_open = 1
let g:syntastic_enable_signs = 1
"let g:syntastic_error_symbol='✗'
"let g:syntastic_warning_symbol='⚠'
let g:syntastic_echo_current_error = 1
let g:syntastic_python_checkers = ['python', 'flake8', 'pyflakes', 'pylint']
"let g:syntastic_mode_map = {'mode': 'active', 'passive_filetypes': ["c"]}

let g:gundo_width = 60
let g:gundo_preview_height = 40
let g:gundo_right = 1

"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/S/m/vimp/vim-snippets/snippets'

