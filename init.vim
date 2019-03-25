" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
if has("win32")
    call plug#begin('~/appdata/local/nvim-data/nplug')
    let g:python3_host_prog = 'py'
    set acd
else
    call plug#begin('~/.local/share/nvim/nplug')
endif

Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'

Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

if has("win32")
    Plug 'goal/LanguageClient-neovim', { 'branch': 'master', 'do': ':UpdateRemotePlugins' }
else
    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
endif

Plug 'airblade/vim-gitgutter'

Plug 'sbdchd/neoformat'
Plug 'jsfaint/gen_tags.vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'

Plug 'justinmk/vim-sneak'

Plug 'iCyMind/NeoSolarized'

Plug 'itchyny/lightline.vim'

Plug 'goal/neovim_wdebug', { 'do': ':UpdateRemotePlugins' }

Plug 'git@gitlab.rd.175game.com:qn/qtz-pastec-vim.git'

" Initialize plugin system
call plug#end()

syntax enable
syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set termguicolors

set background=dark
colorscheme NeoSolarized

let g:deoplete#enable_at_startup = 1
set completeopt-=preview
set completeopt+=noinsert

" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
set listchars=tab:»\ ,trail:-,extends:>,precedes:<,nbsp:+
set list                " Show problematic characters.

" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace guifg=brown
" guibg=darkgray
match ExtraWhitespace /\s\+$\|\t/

let g:lightline={'colorscheme': 'solarized'}

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

nnoremap <C-x>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-x>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-x>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-x>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-x>T :cs find t 
nnoremap <C-x>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-x>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-x>F :cs find f 
nnoremap <C-x>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nnoremap <C-x>d :cs find d <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-x>a :cs find a <C-R>=expand("<cword>")<CR><CR>

nnoremap <M-1> :1winc w<CR>
nnoremap <M-2> :2winc w<CR>
nnoremap <M-3> :3winc w<CR>
nnoremap <M-4> :4winc w<CR>

" neoformat
nnoremap <C-x>o :Neoformat<CR>
vnoremap <C-x>o :Neoformat<CR>

" denite

let mapleader=","

" reset 50% winheight on window resize
augroup deniteresize
  autocmd!
  autocmd VimResized,VimEnter * call denite#custom#option('default',
        \'winheight', winheight(0) / 2)
augroup end

if executable("fd")
    " denite will replace :directory with cwd
    call denite#custom#var('file_rec', 'command', ['fd', '-t', 'f', '-c', 'never', '', ':directory'])
elseif executable("rg")
    call denite#custom#var('file_rec', 'command', ['rg', '--files', '--glob', '!.git'])
endif

call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts',
      \ ['--hidden', '--vimgrep', '--no-heading', '-S'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#map('insert', '<Esc>', '<denite:enter_mode:normal>',
      \'noremap')
call denite#custom#map('normal', '<Esc>', '<NOP>',
      \'noremap')
call denite#custom#map('insert', '<C-v>', '<denite:do_action:vsplit>',
      \'noremap')
call denite#custom#map('normal', '<C-v>', '<denite:do_action:vsplit>',
      \'noremap')
call denite#custom#map('normal', 'dw', '<denite:delete_word_after_caret>',
      \'noremap')
call denite#custom#map('insert', '<C-j>', '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-k>', '<denite:move_to_previous_line>', 'noremap')

nnoremap <C-p> :<C-u>Denite file_rec<CR>
nnoremap <leader>s :<C-u>Denite buffer<CR>
nnoremap <leader>8 :<C-u>DeniteCursorWord grep:. -mode=normal<CR>
nnoremap <leader>/ :<C-u>Denite grep:. -mode=normal<CR>

hi link deniteMatchedChar Special

" denite-extra

" nnoremap <leader>c :<C-u>Denite workspaceSymbol -mode=normal<CR>
nnoremap <leader>t :<C-u>Denite outline<CR>
nnoremap <leader>x :<C-u>Denite command_history<CR>

" language server

" Required for operations modifying multiple buffers like rename.<Paste>
set hidden
" "c": ['/home/wyj/bin/lpcs'], 
let g:LanguageClient_serverCommands = {"python": ['pyls'], "java": ['/home/wyj/R/jdt/jls']}
", "c": ['clangd', '-compile-commands-dir=build']}
" Automatically start language servers.
let g:LanguageClient_autoStart = 1
let g:LanguageClient_diagnosticsDisplay = {}
let g:LanguageClient_diagnosticsDisplay[1] = {"name": "Error", "texthl": "ALEError", "signText": "♠", "signTexthl": "ALEErrorSign"}
let g:LanguageClient_diagnosticsDisplay[2] = {"name": "Warning", "texthl": "ALEWarning", "signText": "♥", "signTexthl": "ALEWarningSign"}
let g:LanguageClient_diagnosticsDisplay[3] = {"name": "Information", "texthl": "ALEInfo", "signText": "♣", "signTexthl": "ALEInfoSign"}
let g:LanguageClient_diagnosticsDisplay[4] = {"name": "Hint", "texthl": "ALEInfo", "signText": "♦", "signTexthl": "ALEInfoSign"}
nnoremap <C-x>f :call LanguageClient_textDocument_formatting()<CR>
nnoremap <C-x>r :call LanguageClient_textDocument_rangeFormatting()<CR>
nnoremap <C-x>g :call LanguageClient#textDocument_definition()<CR>

augroup LanguageClient_config
    autocmd!
    autocmd User LanguageClientStarted call LanguageClient_setLoggingLevel('DEBUG')
augroup end

let g:gen_tags#ctags_bin='exctags'
