" ==[ NeoVim Config]==

" General settings
set fdm=indent " indent folding
set foldlevel=99 " by default folds are not collapsed
set backup             " keep a backup file (restore to previous version)
set backupdir=~/.config/nvim/backup " set backup file directory
set dir=~/.config/nvim/swp " set swap & undo files directory
set viewdir=~/.config/nvim/views
set undofile           " keep an undo file (undo changes after closing)
set ruler              " show the cursor position all the time
set showcmd            " display incomplete commands

"" Tab settings
set tabstop=4     " width that a <tab> is displayed as
set expandtab     " expand tabs to spaces (use :retab)
set shiftwidth=4  " width used in each step of autoindent (and << / >>)
set path+=**
set wildmenu

"enable mouse.
set mouse=a

" Uses system's clipboard as default.
set clipboard=unnamed

" switch on highlighting the last used search pattern.
set hlsearch

" highlight strings inside C comments.
let c_comment_strings=1

" Switch syntax highlighting on
syntax on 

" Set relative number && lines
set relativenumber
set number

" Enable file type detection.
filetype plugin indent on

augroup vimrcEx
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   execute "normal! g`\"" |
    \ endif

augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

"Make the 81st column stand out 
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn', '\%81v', 100)

"Highlight matches when jumping to next 
" This rewires n and N to do the highlighing.
nnoremap <silent> n   n:call HLNext(0.4)<cr>
nnoremap <silent> N   N:call HLNext(0.4)<cr>

"Override search highlighting
highlight Search cterm=NONE ctermfg=None ctermbg=black
highlight IncSearch cterm=NONE ctermfg=None ctermbg=black
highlight OnText cterm=inverse ctermfg=None

" Inverse color of currently selected text.
function! HLNext (blinktime)
    let [bufnum, lnum, col, off] = getpos('.')
    let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
    let target_pat = '\c\%#\%('.@/.'\)'
    let ring = matchadd('OnText', target_pat, 101)
endfunction

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
    set notermguicolors
endif


"====[ Make tabs, trailing whitespace, and non-breaking spaces visible ]======
exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
set list

"=====[ Remove highlighting (:noh) after search]=============
nnoremap <Esc> :noh<cr><Esc>

"====[ Swap : and ; to make colon commands easier to type ]======
nnoremap  ;  :
nnoremap  :  ;

"====[ Swap v and CTRL-V, because Block mode is more useful that Visual mode "]======
nnoremap    v   <C-V>
nnoremap <C-V>     v

vnoremap    v   <C-V>
vnoremap <C-V>     v

"====== Auto completes brackets ===== "
inoremap { {}<Esc>i
inoremap ( ()<Esc>i
inoremap [ []<Esc>i


"====[ Always turn on syntax highlighting for diffs ]=========================
" use the filetype mechanism to select automatically...
filetype on
augroup PatchDiffHighlight
    autocmd!
    autocmd FileType  diff   syntax enable
augroup END


"====[ Mappings to activate spell-checking alternatives ]================
nmap  ;s     :set invspell spelllang=en<CR>
nmap  ;ss    :set    spell spelllang=en-basic<CR>

" Make ambiguous tags the default
nnoremap <C-]> g<C-]>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Make filename completion while in insert mode easier
inoremap <C-F> <C-X><C-F>


"====[ Plugins ]====

" Vim plug automated install
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" Language Client support
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" Multi-entry selection UI.
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" deoplete for auto completion
Plug 'Shougo/deoplete.nvim'

" Transform multiline {} into one line and vice versa using gS and gJ
Plug 'AndrewRadev/splitjoin.vim'

" Tagbar: Browse tags of the current file. <F9> to activate
Plug 'majutsushi/tagbar'

" Better status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" NerdTree -> file tree displayer.
Plug 'scrooloose/nerdtree'

" Comments. usage: gcc to comment line, gc to comment block.
Plug 'tpope/vim-commentary'

" Centers text. Usage: :Goyo to run. :Goyo! to close.
Plug 'junegunn/goyo.vim'

" Theme
Plug 'KeitaNakamura/neodark.vim'

"" Better syntax highlighting
Plug 'sheerun/vim-polyglot'

"Pandoc for rMarkdown compilation. usage: :RMarkdown pdf
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

" Initialize plugin system
call plug#end()


" ==[ Plugins Config ]==

" Use deoplete on startup
let g:deoplete#enable_at_startup = 1

" Airline config
let g:airline_theme = 'fruit_punch'
let g:airline#extensions#tabline#enabled = 0

" Make FZF layout reverse and remap ctrl-p for easy access.
let $FZF_DEFAULT_OPTS = '--layout=reverse'
nnoremap <C-p> :Files<CR>

" Optional ways to open files while we are inside FZF.
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Theme colorscheme
colorscheme neodark

" Tagbar plugin open and close using <F9>, requires Ctags.
nnoremap <silent> <F9> :TagbarToggle<CR>
let g:tagbar_ctags_bin='~/Downloads/ctags/ctags'

" NerdTree plugin opens with ctrl-e
nnoremap <C-e> :NERDTreeToggle<CR>

" ==[ Language Client config ]==
" Requires having the language servers.

" Required for operations modifying multiple buffers like rename.
set hidden

" Autocomplete preview.
set completeopt-=preview

" start languageclient by default (on)
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rls', '/home/louis/.cargo/bin/rustup'],
    \ 'cpp' : ['ccls', '--log-file=/tmp/cc.log'],
    \ }

let g:LanguageClient_diagnosticsEnable = 1
let g:LanguageClient_diagnosticsList = "Quickfix"
let g:LanguageClient_useVirtualText = "No"

" Bindings for LSP. 
nmap <F5> <Plug>(lcn-menu)
nmap <silent> K <Plug>(lcn-hover)
nmap <silent> gd <Plug>(lcn-definition)


"====[ End of Plugin Section ]===="


"====[ set the background to the color of the terminal ]===========
hi NonText ctermbg=none
hi Normal guibg=NONE ctermbg=NONE
