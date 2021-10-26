" ==[Neovim Config]==

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
set clipboard=unnamedplus

" Makes searches case insensitive if not using capital letters
set ignorecase
set smartcase

" highlight strings inside C comments.
let c_comment_strings=1

" Switch syntax highlighting on
syntax on

" switch on highlighting the last used search pattern.
set hlsearch

"Override search highlighting (currently overwritten by fruit_punch)
highlight Search cterm=NONE ctermfg=Magenta ctermbg=None
highlight IncSearch cterm=NONE ctermfg=None ctermbg=black
highlight OnText cterm=inverse ctermfg=None

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

"=====[ Make Y do what it's meant to do ]=============
nnoremap  Y  y$

"===[ Keep cursor in the middle of the screen when doing next/line joins ]===
nnoremap n nzz
nnoremap J mzJ`z

"====[ Swap : and ; to make colon commands easier to type ]======
nnoremap  ;  :
nnoremap  :  ;

"====[ Swap v and CTRL-V, because Block mode is more useful that Visual mode "]======
nnoremap    v   <C-V>
nnoremap <C-V>     v

vnoremap    v   <C-V>
vnoremap <C-V>     v

"====== Auto completes brackets ===== "
" \c , \b for curly/regular brackets.
nnoremap <Leader>c o{<Esc>o<Esc>i}<Esc>
nnoremap <Leader>b a()<Esc>i
inoremap [ []<Esc>i
inoremap " ""<Esc>i

" Indent the current block by doing == instead of =Ab
nnoremap == =aB

"printf shortcut \p
nnoremap <Leader>p aprintf("\n");<Esc>F\i

"C-style if/else shortcut \i
nnoremap <Leader>i iif()<Esc>o{<Esc>o<Esc>i}<Esc>oelse<Esc>o{<Esc>o<Esc>i}<Esc>5kf(a

" C-style function declaration \f
nnoremap <Leader>f ivoid<space>fn()<Esc>o{<Esc>o<Esc>i}<Esc>2kf(a

"====== Remap ctrl-^ with <F2> ===== "
nnoremap <C-^> <F2>
nnoremap <F2> <C-^>

"====[ Always turn on syntax highlighting for diffs ]=========================
" use the filetype mechanism to select automatically...
" filetype on
" augroup PatchDiffHighlight
"     autocmd!
"     autocmd FileType  diff   syntax enable
" augroup END


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

" Multi-entry selection UI.
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" nvim 0.5 integrated LSP plugins.
Plug 'neovim/nvim-lspconfig'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'glepnir/lspsaga.nvim'
Plug 'hrsh7th/nvim-compe'

" Tree sitter
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" deoplete for auto completion
" Plug 'Shougo/deoplete.nvim'

" Transform multiline {} into one line and vice versa using gS and gJ
Plug 'AndrewRadev/splitjoin.vim'

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

" Better syntax highlighting
Plug 'sheerun/vim-polyglot'

" Initialize plugin system
call plug#end()

" ==[ Plugins Config ]==

" Use deoplete on startup
" let g:deoplete#enable_at_startup = 1

" Airline config
let g:airline_theme = 'fruit_punch'
" Remove title and trailing whitespace information.
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#whitespace#enabled = 0
" Only show file's title, not path.
let g:airline_section_c = '%t'

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

" NerdTree plugin opens with ctrl-e
nnoremap <C-e> :NERDTreeToggle<CR>

" ==[ Language Client config ]==
" Requires having the language servers.

" Required for operations modifying multiple buffers like rename.
set hidden

" Autocomplete preview.
" set completeopt-=preview
set completeopt=menuone,noinsert,noselect

" ==[ Language Client config ]==

nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gR <cmd>lua vim.lsp.buf.references()<CR>

" This shows the definition and references.
" v to open in a vertical split, s for horizontal split. enter to simply go (open)
nnoremap <silent> gr :Lspsaga lsp_finder<CR>

" basic hover doc
nnoremap <silent> K  <cmd>Lspsaga hover_doc<CR>
" signature information
nnoremap <silent> gs <cmd>Lspsaga signature_help<CR>
" preview definition.
nnoremap <silent> gk <cmd>Lspsaga preview_definition<CR>
" renaming
nnoremap <silent> gn <cmd>lua require('lspsaga.rename').rename()<CR>
" code actions
nnoremap <silent> ga <cmd>Lspsaga code_action<CR>
xnoremap <silent> gA <cmd>Lspsaga range_code_action<CR>
" open float terminal with \Enter and close it with \ESC
nnoremap <silent> <Leader><cr> :Lspsaga open_floaterm<CR>
tnoremap <silent> <Leader><ESC> <C-\><C-n>:Lspsaga close_floaterm<CR>

" Jump to previous/next diagnostic with [e and ]e
nnoremap <silent> [e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent> ]e <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>

" Errors in Red
hi LspDiagnosticsVirtualTextError guifg=Red ctermfg=Red
" Warnings in Yellow
hi LspDiagnosticsVirtualTextWarning guifg=Yellow ctermfg=Yellow
" Info and Hints in White
hi LspDiagnosticsVirtualTextInformation guifg=White ctermfg=White
hi LspDiagnosticsVirtualTextHint guifg=White ctermfg=White

" When cursor is on a diagnostic the diag will pop up
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })
"====[ End of Plugin Section ]===="

"====[ set the background to the color of the terminal ]===========
hi NonText ctermbg=none
hi Normal guibg=NONE ctermbg=NONE

lua << EOF
require("lsp")
require("treesitter")
require("completion")
EOF
