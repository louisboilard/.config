# Dotfiles.


Config files for Bash, NeoVim, Tmux, Zsh and Alacritty.
View the comments in the files for more specifications.



## Examples:


![telescope](https://user-images.githubusercontent.com/39924874/160036224-b64a3aee-d09a-4adc-a640-4fa27c846bda.png)


![nvim](https://user-images.githubusercontent.com/39924874/160037643-d9ce55ee-cf80-4e58-a513-9a9d3ce8cedb.png)


![exa-bat](https://user-images.githubusercontent.com/39924874/160037655-08dd584b-b624-4321-8147-ba073f788962.png)


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
to be installed). Mostly unused (using zsh).


## Nvim


See comments in the file for details on how to use and for keys.


Requirements for all the features: FZF, ripgrep,
and language servers that you want to use installed on the system (LspInstall).


Use treesitter + native lsp + nvim-cmp + snippets + telescope
for a full feature experience.


Nerdtree plugin for file tree (although I recommend navigating files using telescope/FZF
with the ctrl-p shortcut).


Vim-commentary to comment highlighted text or current line by 
using gc/gcc keystrokes.


FZF-vim to navigate/access different files. Simply do ctrl-p to access the :Lines
display in order to switch files (opens a new buffer). You can then cycle through 
buffers using :b <tab> or ctrl-^ to switch between the two most recently used 
buffers.


Theme/colorscheme: onenord, neodark... Just make sure you're using a 256color term.


#### Workflow:


Open vim at the root of the project (ideally), then use
telescope with ctrl-p to open the file finder and find the file you want to work
on. To open another file simply do
ctrl-p again and select the other file. If you want it in a split do ctrl-v
once the file is selected, else simply do enter. To switch between the two
most recent buffers, use ctrl-^ (<F2>) (very useful for when there are only
two buffers opened). To navigate between multiple buffers, do :b <tab> and 
simply select the one you want to open. To split do ctrl-v in normal mode.
To search for files that contain a string do <leader><space> in normal mode,
to search for files containing the string on cursor do <space> in normal mode
(uses ripgrep). Use ctrl-o/ctrl-i to travel through the jumplist for easy
navigation.


## Tmux


Includes mouse scrolling. Default prefix is remapped to C-a as 
opposed to the default C-b.


## Zsh


.zshrc file to see my Z shell config.
Vi mode specifics, use of the zsh-syntax-highlighting plugin 
for highlighting and ctrl-o bind to access fzf. Using lf
as the terminal file manager. Aliases are
shared with the bash config (fetched from
the .bash_aliases file).


## Alactritty


alactritty.yml file to see the config for the
Alactritty terminal emulator. Includes transparency and 
other slight windows adjustments. Runs Zsh by default.
