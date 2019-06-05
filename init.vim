" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
if has("win32")
    call plug#begin('~/appdata/local/nvim-data/nplug')
    let g:python3_host_prog = 'py'
    set acd
    set clipboard+=unnamedplus
    vnoremap <C-c> "+y
    inoremap <C-v> <C-o>"+p
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
Plug 'tpope/vim-commentary'

Plug 'justinmk/vim-sneak'

Plug 'iCyMind/NeoSolarized'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'agude/vim-eldar'
Plug 'haishanh/night-owl.vim'
Plug 'bluz71/vim-moonfly-colors'
Plug 'NLKNguyen/papercolor-theme'
Plug 'gruvbox-community/gruvbox'
Plug 'chriskempson/base16-vim'

Plug 'itchyny/lightline.vim'

Plug 'junegunn/vim-easy-align'

Plug 'goal/neovim_wdebug', { 'do': ':UpdateRemotePlugins' }

" Plug 'git@gitlab.rd.175game.com:qn/qtz-pastec-vim.git'
"
Plug 'luochen1990/rainbow'

Plug 'neoclide/denite-extra'

Plug 'goal/denite-gtags'

" Initialize plugin system
call plug#end()

syntax enable
syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set termguicolors

set background=dark
" colorscheme NeoSolarized
" colorscheme dracula
" colorscheme eldar
" colorscheme night-owl
" colorscheme moonfly
colorscheme PaperColor
" colorscheme gruvbox

let g:lightline={'colorscheme': 'default'}

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
" nnoremap <C-x>c :cs find c <C-R>=expand("<cword>")<CR><CR>
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

" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-c>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter
\ call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  inoremap <silent><buffer><expr> <C-c>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <C-c>
  \ denite#do_map('quit')
endfunction

" reset 50% winheight on window resize
augroup deniteresize
  autocmd!
  autocmd VimResized,VimEnter * call denite#custom#option('default',
        \'winheight', winheight(0) / 2)
augroup end

if executable("fd")
    " denite will replace :directory with cwd
    call denite#custom#var('file/rec', 'command', ['fd', '-t', 'f', '-c', 'never', '', ':directory'])
elseif executable("rg")
    call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
endif

call denite#custom#var('grep', 'command', ['rg'])
call denite#custom#var('grep', 'default_opts',
      \ ['--hidden', '--vimgrep', '--no-heading', '-S'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#option('_', {'split': 'floating', 'wincol': 27, 'winwidth': 82, 'auto_resize': 1, "mathcers": ["matcher/regexp"]})

nnoremap <C-p> :<C-u>Denite file/rec<CR>
nnoremap <leader>s :<C-u>Denite buffer<CR>
nnoremap <leader>8 :<C-u>DeniteCursorWord -no-empty grep<CR>
nnoremap <leader>/ :<C-u>Denite -no-empty grep<CR>
nnoremap <leader>q :<C-u>Denite quickfix<CR>
nnoremap <leader>c :<C-u>Denite colorscheme<CR>

" hi link deniteMatchedChar Special

" denite-extra

" nnoremap <leader>c :<C-u>Denite workspaceSymbol -mode=normal<CR>
nnoremap <leader>t :<C-u>Denite outline<CR>
nnoremap <leader>x :<C-u>Denite command_history<CR>

nnoremap <leader>g :DeniteCursorWord -buffer-name=gtags_def gtags_def<cr>
nnoremap <leader>r :DeniteCursorWord -buffer-name=gtags_ref gtags_ref<cr>
" list all tags
nnoremap <leader>l :Denite -buffer-name=gtags_completion gtags_completion<cr>
" nnoremap <leader>a :DeniteCursorWord -buffer-name=gtags_context gtags_context<cr>
" nnoremap <leader>g :DeniteCursorWord -buffer-name=gtags_grep gtags_grep<cr>
" nnoremap <leader>f :Denite -buffer-name=gtags_file gtags_file<cr>
" nnoremap <leader>F :Denite -buffer-name=gtags_files gtags_files<cr>
" nnoremap <leader>p :Denite -buffer-name=gtags_path gtags_path<cr>

" delete
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" language server

" Required for operations modifying multiple buffers like rename.<Paste>
set hidden
" "c": ['/home/wyj/bin/lpcs'], 
let g:LanguageClient_serverCommands = {"python": ['pyls'], 'c': ['cquery', '--log-file=/tmp/cq.log', '--init={"cacheDirectory":"/tmp/cquery/"}'], 'cpp': ['cquery', '--log-file=/tmp/cq.log', '--init={"cacheDirectory":"/tmp/cquery/"}']}
" Automatically start language servers.
let g:LanguageClient_autoStart = 0
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
    autocmd VimEnter *.py LanguageClientStart
augroup end

let g:gen_tags#ctags_bin='exctags'

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
