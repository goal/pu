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
Plug 'deoplete-plugins/deoplete-dictionary'
Plug 'deoplete-plugins/deoplete-tag'

Plug 'machakann/vim-swap'
Plug 'kassio/neoterm'

if has("win32")
    Plug 'goal/LanguageClient-neovim', { 'branch': 'master', 'do': ':UpdateRemotePlugins' }
else
    Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': 'bash install.sh' }
endif

Plug 'mhinz/vim-signify'

Plug 'sbdchd/neoformat'
Plug 'jsfaint/gen_tags.vim'

Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fireplace'

Plug 'easymotion/vim-easymotion'

Plug 'iCyMind/NeoSolarized'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'agude/vim-eldar'
Plug 'haishanh/night-owl.vim'
Plug 'bluz71/vim-moonfly-colors'
Plug 'NLKNguyen/papercolor-theme'
Plug 'gruvbox-community/gruvbox'
Plug 'chriskempson/base16-vim'

Plug 'itchyny/lightline.vim'

" Archlinux vimfiles
Plug '/usr/share/vim/vimfiles'
" homebrew fzf vimfiles
Plug '/home/linuxbrew/.linuxbrew/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'

Plug 'luochen1990/rainbow'

Plug 'neoclide/denite-extra'

Plug 'goal/neovim_wdebug', { 'do': ':UpdateRemotePlugins' }
Plug 'goal/denite-gtags'

" Plug 'git@gitlab.rd.175game.com:qn/qtz-pastec-vim.git'

" Initialize plugin system
call plug#end()

syntax enable
syntax on
set tabstop=4
set shiftwidth=4
set expandtab
set termguicolors
set fileencodings=utf-8,gb18030
set encoding=UTF-8
set scrolloff=3

set background=dark
" colorscheme NeoSolarized
" colorscheme dracula
" colorscheme eldar
" colorscheme night-owl
" colorscheme moonfly
colorscheme PaperColor
" colorscheme gruvbox

set noshowmode
let g:lightline={'colorscheme': 'PaperColor'}

set completeopt-=preview
set completeopt+=noinsert

let g:deoplete#enable_at_startup = 1
setlocal dictionary+=/usr/share/dict/american-english
" Remove this if you'd like to use fuzzy search
call deoplete#custom#source('dictionary', 'matchers', ['matcher_head'])
" If dictionary is already sorted, no need to sort it again.
call deoplete#custom#source('dictionary', 'sorters', [])
" Do not complete too short words
call deoplete#custom#source('dictionary', 'min_pattern_length', 4)

" Tell Vim which characters to show for expanded TABs,
" trailing whitespace, and end-of-lines. VERY useful!
set listchars=tab:»\ ,trail:-,extends:>,precedes:<,nbsp:+
set list                " Show problematic characters.

let g:ultisnips_python_style = 'google'

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
  call deoplete#custom#buffer_option('auto_complete', v:false)
endfunction

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
call denite#custom#option('_', {'split': 'floating', 'auto_resize': v:true})
" call denite#custom#option('_', {'split': 'floating', 'wincol': 17, 'winwidth': 102, 'auto_resize': v:true})

nnoremap <C-p> :<C-u>Denite -start-filter file/rec<CR>
nnoremap <leader>s :<C-u>Denite buffer<CR>
nnoremap <leader>8 :<C-u>DeniteCursorWord -no-empty grep<CR>
nnoremap <leader>/ :<C-u>Denite -no-empty grep<CR>
nnoremap <leader>q :<C-u>Denite quickfix<CR>
nnoremap <leader>c :<C-u>Denite colorscheme<CR>
nnoremap <leader>` :<C-u>Denite mark<CR>
nnoremap <leader>m :AutoMark<CR>

" hi link deniteMatchedChar Special

" denite-extra

" nnoremap <leader>c :<C-u>Denite workspaceSymbol -mode=normal<CR>
nnoremap <leader>t :<C-u>Denite -start-filter outline<CR>
nnoremap <leader>x :<C-u>Denite -start-filter command_history<CR>

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
let g:LanguageClient_serverCommands = {"python": ['pyls', '--log-file=/tmp/pyls.log', '-v'], 'c': ['cquery', '--log-file=/tmp/cq.log', '--init={"cacheDirectory":"/tmp/cquery/"}'], 'cpp': ['cquery', '--log-file=/tmp/cq.log', '--init={"cacheDirectory":"/tmp/cquery/"}']}
" Automatically start language servers.
let g:LanguageClient_autoStart = 0
let g:LanguageClient_loggingFile = '/tmp/lc.log'

function LC_maps()
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <C-x>f :call LanguageClient_textDocument_formatting()<CR>
    nnoremap <C-x>r :call LanguageClient_textDocument_rangeFormatting()<CR>
    nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
    nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <buffer> <silent> <leader>R :call LanguageClient#textDocument_rename()<CR>
  endif
endfunction

augroup LanguageClient_config
    autocmd!
    autocmd User LanguageClientStarted call LanguageClient_setLoggingLevel('DEBUG')
    autocmd VimEnter *.py LanguageClientStart
    autocmd FileType * call LC_maps()
augroup end

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
