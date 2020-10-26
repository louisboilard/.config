" ==[ NeoVim Configs]==


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

" FUZZY FILE FIND
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**


" Display all matching files when we tab complete
set wildmenu

"set mouse on.
set mouse=a

" switch on highlighting the last used search pattern.
set hlsearch

" I like highlighting strings inside C comments.
let c_comment_strings=1

" Switch syntax highlighting on
syntax on 

" Set relative number && line on
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

" deoplete for auto completion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

"***For Rust completion we use racer. install through rustup before. ***
Plug 'racer-rust/vim-racer'

" Transform multiline {} into one line and vice versa using gS and gJ
Plug 'AndrewRadev/splitjoin.vim'

"*** Requires install of rls via rustup to work properly! ***
" Rust plugin config. (Configures Syntastic for Rust, Tagbar, rustfmt and Playpen)
Plug 'rust-lang/rust.vim'

" syntastic: Syntax checking plugin.
Plug 'vim-syntastic/syntastic'

" Tagbar: Browse tags of the current file. set to <F9> to activate
Plug 'majutsushi/tagbar'

" Generates rust documentation from within nvim.
" Download the rust documentation locally for better usage.
Plug 'rhysd/rust-doc.vim'

" Better status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" NerdTree -> file tree displayer.
Plug 'scrooloose/nerdtree'

" Theme
Plug 'KeitaNakamura/neodark.vim'

"" Better syntax highlighting
Plug 'sheerun/vim-polyglot'

" Initialize plugin system
call plug#end()


" ==[ Plugins Config ]==

" Use deoplete on startup (autocomplete by default)
let g:deoplete#enable_at_startup = 1

" Airline config
let g:airline_theme = 'fruit_punch'
let g:airline#extensions#tabline#enabled = 1

" Theme colorscheme
colorscheme neodark


" Tagbar plugin open and close using <F9>
nnoremap <silent> <F9> :TagbarToggle<CR>

" NerdTree plugin opens with ctrl-e and <F4>
nnoremap <C-e> :NERDTreeToggle<CR>
nnoremap <F4>  :NERDTreeToggle<CR>

" ==[ Language Client config ]==
" Requires having lsp installed.
" Required for operations modifying multiple buffers like rename.
set hidden

" Remove autocomplete preview.
set completeopt-=preview

" start languageclient by default (off)
let g:LanguageClient_autoStart = 0

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rls']
    \ }


" Configs for racer (autocomplete with deoplete for Rust)
let g:racer_cmd = "/home/louis/.cargo/bin/racer"

let g:racer_experimental_completer = 1

" K will open the documentation of whats on the cursor if available.
nmap K <Plug>(rust-doc)

"Specify that our documentation is in ~/Document (needs to be local)
"Example to open a specific doc -> :RustDoc ::std::vec
let g:rust_doc#downloaded_rust_doc_dir = '~/Documents/rust-docs'


" ==[ Rust syntastic config (syntax checking) ]==
" To get info about whats currently going on: :SyntasticInfo
" read the manual. :help syntastic

"specifies we want cargo to check syntax.
let g:syntastic_rust_checkers = ['cargo']

" Basic configs
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"Always populate error list detected by syntastic.
let g:syntastic_always_populate_loc_list = 0

" Hides Rust warnings that can be annoying.
"let g:syntastic_rust_cargo_quiet_messages = {'regex': ['variant', 'unused'] }

" Custom symbol for errors
let g:syntastic_error_symbol = "✗"


" Turn highlighting on or off (1=on, 0=off)
let g:syntastic_enables_highlighting = 0

" Custom symbol for warnings
let g:syntastic_warning_symbol = "☯ "

" open window when theres an error, closes when none (1=on 0=off)
let g:syntastic_auto_loc_list = 0

" Open the Error window with <F5>
nnoremap <F5> :Errors<CR>

" Close the Error window with <F6>
nnoremap <F6> :lclose<CR>

" Enable balloon text box over error (only if vim compiled with +balloon_eval)
let g:syntastic_enables_balloons = 1

" Activates syntastics as soon as file is opened.
let g:syntastic_check_on_open = 1


" ==[ Rust formating using rustfmt ]==

" Activate format everytime we :w (save)
let g:rustfmt_autosave = 1

" press ctrl-f to run :RustFmt
nnoremap <C-f> :RustFmt<CR>

"====[ End of Plugin Section ]===="


"====[ set the background to the color of the terminal ]===========
hi NonText ctermbg=none
hi Normal guibg=NONE ctermbg=NONE
