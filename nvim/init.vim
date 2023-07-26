" ==[Neovim Config]==

" General settings
set fdm=indent " indent folding
set foldlevel=99 " by default folds are not collapsed
set backup             " keep a backup file (restore to previous version)
set backupdir=~/.config/nvim/backup " set backup file directory
" set dir=~/.config/nvim/swp " set swap & undo files directory
set viewdir=~/.config/nvim/views
set undofile           " keep an undo file (undo changes after closing)
set ruler              " show the cursor position all the time
set showcmd            " display incomplete commands
set signcolumn=yes

" Tab settings
" To transform spaces to tabs-> :set noexpandtab and then :%retab!
set tabstop=4     " width that a <tab> is displayed as
set expandtab     " expand tabs to spaces (use :retab)
set shiftwidth=4  " width used in each step of autoindent (and << / >>)
set path+=**
set wildmenu
set scrolloff=8
" set sidescrolloff=20 " This + nowrap moves the screen horizontally
" set nowrap

set wrap
set linebreak
" set showbreak

"enable mouse.
set mouse=a

" Uses system's clipboard as default. (When not using smartyank)
set clipboard=unnamedplus
set clipboard^=unnamedplus

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
highlight IncSearch cterm=NONE ctermfg=None ctermbg=Black
highlight OnText cterm=inverse ctermfg=None

" Set relative number && lines
set relativenumber
set number

" Enable file type detection.
filetype plugin indent on

augroup vimrcEx
  autocmd!

  " For all text files set 'textwidth' to 78 characters.
  " autocmd FileType text setlocal textwidth=78

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
" exec "set listchars=tab:\uBB\uBB,trail:\uB7,nbsp:~"
" exec "set listchars=tab:\uB7\uB7,trail:\uB7,nbsp:~"
exec "set listchars+=trail:\uB7"
set list

inoremap <F6> if err != nil {<cr>}<Esc>
inoremap <F7> Console.WriteLine($"{}");<Esc>

"=====[ Remove highlighting (:noh) after search ]======
nnoremap <Esc> :noh<cr><Esc>

"=====[ See diffs of the current file  with <F8> ]======
nnoremap <F8> :w !diff % -<cr>

"=====[ Jump to next git hunk ]=============
nnoremap  <F3>  :Gitsigns next_hunk<cr>

"=====[ Copy full path of current file to clipboard ]======
nnoremap <F7> :let @+ = expand("%:p")<cr>

"===== Stay at center of screen when scrolling through code ======
" This is only valid on non-lsp buffers since [[ is used to move to functions
" when lsp is enabled
nnoremap [[ 5jzz
nnoremap ]] 5kzz

"===== Stay at center of screen when moving in change list ======
nnoremap g; g;zz
nnoremap g, g;zz

"=====[ Make Y do what it's meant to do ]=============
nnoremap  Y  y$

"=====[ Use <leader>p to paste 0 register (avoid pasting deletes) ]=====
nnoremap  <leader>p  "0p
vnoremap  <leader>p  "0p

"=====[ Select/highlight inside a block using <leader>h (\h) ]=====
nnoremap  <leader>h  vi{

"===[ Keep cursor in the middle of the screen when doing next/line joins ]===
nnoremap n nzz
nnoremap J mzJ`z

" Open new file adjacent to current file
nnoremap <leader>o :e <C-R>=expand("%:p:h") . "/" <CR>

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

"====== Move to new split when splitting ======
nnoremap <C-v> <C-w>v<C-w>l
nnoremap <C-s> <C-w>s<C-w>j

"====== Move more easily between splits with C-l/h/j/k ====== "
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" Open current window in new tab with T
nnoremap T     <C-w>T

"====[ Mappings to activate spell-checking alternatives ]====
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
Plug 'stevearc/dressing.nvim'
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
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'williamboman/mason.nvim', { 'do': ':MasonUpdate' }

" Completion plugin and sub plugins for lsp/paths/snippets/buffers
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'saadparwaiz1/cmp_luasnip'

" Lots of additional feature over regular lsp for rust
" See user/rust-tools.lua for commands.
" Plug 'simrat39/rust-tools.nvim'

" Debugger client
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'leoluz/nvim-dap-go'
Plug 'nvim-telescope/telescope-dap.nvim'

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
Plug 'nvim-treesitter/nvim-treesitter-context'

" Status and tab line
Plug 'nvim-lualine/lualine.nvim'

" File tree displayer.
Plug 'kyazdani42/nvim-tree.lua'

" Bufferline
Plug 'akinsho/bufferline.nvim'

" Comments. usage: gcc to comment line, gc to comment block.
Plug 'numToStr/Comment.nvim'

" Centers text. Usage: :Goyo to run. :Goyo! to close.
Plug 'junegunn/goyo.vim'

" Smart yanking. This overrides clipboard settings
Plug 'ibhagwan/smartyank.nvim'

" Markdown preview. Start with :MarkdownPreview stop with :MarkdownPreviewStop
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" Surround text objects.
" Surround: ys<text object><char> ex: ysw" (w is the word at cursor)
" Delete surrounding pair: ds<char that surrounds> ex: dsb (b for bracket) dsB
" for {} (B is for {asdasd})
" Change surrounding pair: cs<char that surrounds> ex: csb' (change bracket
" for ')
Plug 'kylechui/nvim-surround'

" Avoid getting lost in brackets
Plug 'lukas-reineke/indent-blankline.nvim'

" Highlight unique chars in a line to use f/F/t/T efficiently
Plug 'unblevable/quick-scope'

" Use s/S to navigate anywhere on the visible screen. Also overwrites F/f/T/t
" (but not when quick-scope plugin is active).
Plug 'ggandor/leap.nvim'

" Mark files per project and navigate between marked files
Plug 'ThePrimeagen/harpoon'

" Git signs
Plug 'lewis6991/gitsigns.nvim'

" Custom notifications
Plug 'rcarriga/nvim-notify'

" Smooth scrolling
Plug 'karb94/neoscroll.nvim'

" float minimap on right side.
" <leader>mf -> focus/onfocus window
" <leader>mm -> toggle
Plug 'gorbit99/codewindow.nvim'

" Themes
Plug 'KeitaNakamura/neodark.vim'
Plug 'luisiacc/gruvbox-baby', {'branch': 'main'}
Plug 'bluz71/vim-moonfly-colors'
Plug 'savq/melange'
Plug 'rmehri01/onenord.nvim'
Plug 'yonlu/omni.vim'
Plug 'rebelot/kanagawa.nvim'
Plug 'Mofiqul/dracula.nvim'
Plug 'louisboilard/pyramid.nvim'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
Plug 'rose-pine/neovim', {'as': 'rose-pine'}

" Initialize plugin system
call plug#end()

" ==[ Plugins Config ]==

" Theme colorscheme
set termguicolors
syntax enable

" colorscheme neodark
" colorscheme moonfly
" colorscheme melange
" colorscheme omni
" colorscheme onenord
" colorscheme catppuccin
" colorscheme kanagawa
colorscheme rose-pine
" colorscheme dracula
" colorscheme gruvbox-baby
" colorscheme pyramid

" let g:pyramid_background_color = "dark"
" let g:pyramid_transparent_mode = 1

" For quick-scope (only highlight when f/F/t/T is pressed)
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline

" Find files using Telescope command-line sugar.
" To preview media files, use :Telescope media_files
" To see all possible keys, do Ctrl-p to open telescope, Esc
" to go normal mode and type ?
" possible themes are: get_dropdown, get_cursor, get_ivy or none.
nnoremap <C-p> <cmd>Telescope find_files theme=get_ivy <cr>

" mm to open harpoon menu
autocmd FileType harpoon setlocal wrap
nnoremap mm <cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>
" mf to mark a file
nnoremap mf <cmd>lua require("harpoon.mark").add_file()<cr>

" Treesitter symbols with <F9>
nnoremap <silent><F9> <cmd>lua require'telescope.builtin'.treesitter{} theme=get_ivy<cr>

" Grep string under cursor in current dir and search for string
nnoremap <space> <cmd>Telescope grep_string theme=get_ivy<cr>
nnoremap <leader><space> <cmd>Telescope live_grep theme=get_ivy<cr>

"Remaps for trouble.nvim TODO: open this with telescope, not in the
"quickfix list.
nnoremap  <C-x> <cmd>lua require'telescope.builtin'.diagnostics{} theme=get_ivy<cr>

" NerdTree plugin opens with ctrl-e
nnoremap <C-e> :NvimTreeToggle<CR>

" Required for operations modifying multiple buffers like rename.
set hidden

" Autocomplete preview.
" set completeopt-=preview
set completeopt=menuone,noinsert,noselect
" set completeopt=menuone,menu,noselect

" Override some colorscheme for real "full transparency"
"====[ set the background to the color of the terminal ]===========
hi NonText ctermbg=none guibg=NONE
hi Normal guibg=NONE ctermbg=NONE

" NC == non current, like an unfocused split

hi NormalNC guibg=NONE ctermbg=NONE
" Left most side bar where signs (diagnostics) are displayed
hi SignColumn ctermbg=NONE ctermfg=NONE guibg=NONE

" Used for some floating windows
hi Pmenu ctermbg=NONE ctermfg=NONE guibg=NONE
hi FloatBorder ctermbg=NONE ctermfg=NONE guibg=NONE
hi NormalFloat ctermbg=NONE ctermfg=NONE guibg=NONE

hi TabLine ctermbg=None ctermfg=None guibg=None
" tablinesel is the lil colored bar at the leftmost part of current tab
" hi TabLineSel ctermbg=None ctermfg=NONE guibg=NONE
" hi TabLineFill ctermbg=None ctermfg=None guibg=None

" Show the current line
set cursorline
hi clear CursorLine
hi CursorLine gui=underline cterm=underline ctermfg=None guifg=None
set textwidth=80
"====[ End of Plugin Section ]===="

lua << EOF
require("mason").setup()
require("mason-lspconfig").setup()
require("user.lsp.init")

require("dapui").setup()
require("dap-go").setup()
require("nvim-dap-virtual-text").setup()
require("user.dap-config")

require("user.treesitter")
require("user.cmp")
require("user.telescope")
require("user.autopairs")
require("user.toggleterm")
require("user.colorizer")
require("user.bufferline")
require("nvim-web-devicons").setup()
require("lsp-colors").setup()
require("user.lualine")
require("user.nvimtree")
require("user.treesittercontext")
require("user.harpoon")
require("user.surround")
require("user.dressing")
require("user.indent-blankline")
require("user.smartyank")
require("gitsigns").setup()
require("Comment").setup()
require("neoscroll").setup()
require("codewindow").setup()
require("codewindow").apply_default_keybinds()
require("leap").add_default_mappings()
require("user.notify")
vim.notify = require("notify")
EOF

