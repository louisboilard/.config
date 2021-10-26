# Dotfiles.


Config files for Bash, NeoVim, Tmux, Zsh and Alacritty.
View the comments in the files for more specifications.


## Auto install


To automatically install the config, cd to where install.sh is located
(/Dotfiles/.config) and run install.sh (you will need to execute it
with sudo rights).


Some manual tweaking might be required post installation
(like running PlugUpdate/PlugInstall from nvim and running
LspInstall <server name> to setup neovim plugins and desired language servers).


---


## Bash


Basic bash configurations. In vi mode by default (defaults to insert mode on launch).


Aliases in .bash_aliases


Very standard except for the Rust specific exports. ls replaced by exa (exa needs
to be installed).


## Nvim


See comments in the file for details on how to use and for keys.


Requirements for all the features: FZF, ctags 
and language servers that you want to use installed on the system.


Uses Deoplete plugin and language server protocol support (languageClient-neovim plugin) 
for auto completion. To use the language client you need to have the proper 
language servers downloaded (ex rustc, clangd).. Go to symbol definition with gd,
hover with K and open the language server menu with F5.


Nerdtree plugin for file tree (although I recommend navigating files using FZF 
with the ctrl-p shortcut).


splitjoin.vim plugin to switch between single-line statement and multi-line.


Vim-commentary to comment highlighted text or current line by 
using gc/gcc keystrokes.


FZF-vim to navigate/access different files. Simply do ctrl-p to access the :Lines
display in order to switch files (opens a new buffer). You can then cycle through 
buffers using :b <tab> or ctrl-^ to switch between the two most recently used 
buffers.


Tagbar plugin for tags. Toggle on/off with F9. Requires ctags installed on 
the system. (not super useful when using a file type that has LSP enabled).


Theme/colorscheme: neodark.


#### Workflow:


Open vim at the root of the project (ideally), then use
fzf with ctrl-p to open the file finder and find the file you want to work
on.You can then work in that buffer. To open another file simply do 
ctrl-p again and select the other file. If you want it in a split do ctrl-v
once the file is selected, else simply do enter. To switch between the two 
most recent buffers, use ctrl-^ (very very useful for when there are only 
two buffers opened). To navigate between multiple buffers, do :b <tab> and 
simply select the one you want to open. I suggest always having vim opened 
once the session is started and use another tmux tab to use the terminal for 
other purposes.


## Tmux


Includes mouse scrolling. Default prefix is remapped to C-a as 
opposed to the default C-b.


## Zsh


.zshrc file to see my Z shell config. 
Vi mode specifics, use of the zsh-syntax-highlighting plugin 
for highlighting and ctrl-o bind to access the lf program 
(a terminal file manager written in Go). Aliases are 
shared with the bash config (they're fetched from 
the .bash_aliases file).


## Alactritty


alactritty.yml file to see the config for the 
Alactritty terminal emulator. Includes transparency and 
other slight windows adjustments. Runs Zsh by default.
