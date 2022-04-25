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
set signcolumn=yes

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

"===== Replace at center of screen when scrolling through code ======
nnoremap [[ [[zz
nnoremap ]] ]]zz

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

" Indent the current block by doing == instead of =Ab
nnoremap == =aB

"====== Remap ctrl-^ with <F2> ===== "
nnoremap <C-^> <F2>
nnoremap <F2> <C-^>

"====== Move to new split when splitting ====== "
nnoremap <C-v> <C-w>v<C-w>l
nnoremap <C-s> <C-w>s<C-w>j

"====== Move more easily between splits with C-l/h/j/k ====== "
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

"====[ Mappings to activate spell-checking alternatives ]================
nmap  ;s     :set invspell spelllang=en<CR>
nmap  ;ss    :set    spell spelllang=en-basic<CR>

"====[ Plugins ]====

" Vim plug automated install
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" Selection UI fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-media-files.nvim'

" Icons && Colors
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/lsp-colors.nvim'
Plug 'norcalli/nvim-colorizer.lua'

" nvim 0.5+ integrated LSP plugins.
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

" Completion plugin and sub plugins for lsp/paths/snippets/buffers
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'saadparwaiz1/cmp_luasnip'

" Toggle terminal (set to <leader>Enter)
Plug 'akinsho/toggleterm.nvim'

" snippets
Plug 'L3MON4D3/LuaSnip/'
Plug 'rafamadriz/friendly-snippets'

" Treesitter aware auto-pairing for brackets
Plug 'windwp/nvim-autopairs'

" Prettier diagnostics/lsp/telescope results
" Basic usage: C-x
Plug 'folke/trouble.nvim'

" Tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'

" Status and tab line
Plug 'nvim-lualine/lualine.nvim'

" NerdTree -> file tree displayer.
Plug 'scrooloose/nerdtree'

" Bufferline
Plug 'akinsho/bufferline.nvim'

" Comments. usage: gcc to comment line, gc to comment block.
Plug 'tpope/vim-commentary'

" Centers text. Usage: :Goyo to run. :Goyo! to close.
Plug 'junegunn/goyo.vim'

" Markdown preview. Start with :MarkdownPreview stop with :MarkdownPreviewStop
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" Themes
Plug 'KeitaNakamura/neodark.vim'
Plug 'luisiacc/gruvbox-baby', {'branch': 'main'}
Plug 'bluz71/vim-moonfly-colors'
Plug 'savq/melange'
Plug 'rmehri01/onenord.nvim'
Plug 'yonlu/omni.vim'
Plug 'Mofiqul/dracula.nvim'
" Plug 'louisboilard/pyramid.nvim'

" Initialize plugin system
call plug#end()

" ==[ Plugins Config ]==

" Theme colorscheme
set termguicolors
" colorscheme neodark
" colorscheme moonfly
" colorscheme melange
" colorscheme omni
colorscheme onenord
" colorscheme dracula
" colorscheme gruvbox-baby

" let g:pyramid_background_color = "dark"
" let g:pyramid_transparent_mode = 1
" colorscheme pyramid

" Find files using Telescope command-line sugar.
" To preview media files, use :Telescope media_files
" To see all possible keys, do Ctrl-p to open telescope, Esc
" to go normal mode and type ?
" possible themes are: get_dropdown, get_cursor, get_ivy or none.
nnoremap <C-p>      <cmd>Telescope find_files theme=get_ivy <cr>
nnoremap <F10>      <cmd>Telescope find_files theme=get_ivy <cr>

" Lsp lsp_references inside telescope with gr
nnoremap gr <cmd>lua require'telescope.builtin'.lsp_references{} theme=get_ivy<cr>

" Treesitter symbols with <F9>
nnoremap <silent><F9> <cmd>lua require'telescope.builtin'.treesitter{} theme=get_ivy<cr>

" use ga for code actions and display them in telescope (type enter to complete)
nnoremap ga <cmd>lua require'telescope.builtin'.lsp_code_actions{} theme=get_ivy<cr>

" Grep string under cursor in current dir and search for string
nnoremap <space> <cmd>Telescope grep_string theme=get_ivy<cr>
nnoremap <leader><space> <cmd>Telescope live_grep theme=get_ivy<cr>

"Remaps for trouble.nvim TODO: open this with telescope, not in the
"quickfix list.
nnoremap <C-x> <cmd>TroubleToggle<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>

" NerdTree plugin opens with ctrl-e
nnoremap <C-e> :NERDTreeToggle<CR>

" Cycle through buffers
" nnoremap <silent>[b :BufferLineCycleNext<CR>
" nnoremap <silent>b] :BufferLineCyclePrev<CR>

" Required for operations modifying multiple buffers like rename.
set hidden

" Autocomplete preview.
" set completeopt-=preview
set completeopt=menuone,noinsert,noselect


"====[ End of Plugin Section ]===="

"====[ set the background to the color of the terminal ]===========
" This is in the actual .local/share/nvim/plugged/<colorscheme>
" HERE
" hi NonText ctermbg=none guibg=NONE
" hi Normal guibg=NONE ctermbg=NONE

" NC == non current, like a split

" HERE
" hi NormalNC guibg=NONE ctermbg=NONE
" Left most side bar where signs (diagnostics) are displayed
" hi SignColumn ctermbg=NONE ctermfg=NONE guibg=NONE

" HERE
" Used for some floating windows
" hi Pmenu ctermbg=NONE ctermfg=NONE guibg=NONE
" hi FloatBorder ctermbg=NONE ctermfg=NONE guibg=NONE
" hi NormalFloat ctermbg=NONE ctermfg=NONE guibg=NONE



" hi TabLine ctermbg=NONE ctermfg=NONE guibg=NONE
" hi TabLineSel ctermbg=NONE ctermfg=NONE guibg=NONE
" hi TabLineFill ctermbg=NONE ctermfg=NONE guibg=NONE

lua << EOF
require("user.lsp")
require("user.treesitter")
require("user.cmp")
require("user.telescope")
require("user.autopairs")
require("user.toggleterm")
require("user.colorizer")
require("user.bufferline")
require("user.lualine")
EOF
