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

if has("mac")
    let g:python3_host_prog = '/usr/local/opt/python@3.8/bin/python3'
endif

" snippets
Plug 'honza/vim-snippets'
" snippet plugin
Plug 'SirVer/ultisnips'

" autocomplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" deoplete source for /usr/share/dict
Plug 'deoplete-plugins/deoplete-dictionary'
" deoplete source for ctags
Plug 'deoplete-plugins/deoplete-tag'

" swap text objects
Plug 'machakann/vim-swap'

" helper to use terminal
Plug 'kassio/neoterm'

" similar to gitgutter for emacs
Plug 'mhinz/vim-signify'

" format code
Plug 'sbdchd/neoformat'
" gen ctags/gtags
Plug 'jsfaint/gen_tags.vim'

" add/change/remove surround
Plug 'tpope/vim-surround'
" git
Plug 'tpope/vim-fugitive'
" add/remove comment
Plug 'tpope/vim-commentary'
" clojure REPL
Plug 'tpope/vim-fireplace'

" easymotion quick jump
Plug 'easymotion/vim-easymotion'

" colorscheme
Plug 'iCyMind/NeoSolarized'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'agude/vim-eldar'
Plug 'haishanh/night-owl.vim'
Plug 'bluz71/vim-moonfly-colors'
Plug 'NLKNguyen/papercolor-theme'
Plug 'gruvbox-community/gruvbox'
Plug 'chriskempson/base16-vim'

" status line
Plug 'itchyny/lightline.vim'

" Archlinux vimfiles
Plug '/usr/share/vim/vimfiles'
" homebrew fzf vimfiles
Plug '/home/linuxbrew/.linuxbrew/opt/fzf'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'

" parathesis colorize
Plug 'luochen1990/rainbow'

" restructedText
Plug 'gu-fan/riv.vim'

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
setlocal dictionary+=/usr/share/dict/words
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
nnoremap <leader>m :AutoMark<CR>

" delete
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
