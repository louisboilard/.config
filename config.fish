if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -e fish_user_paths

### SET EITHER DEFAULT EMACS MODE OR VI MODE ###
function fish_user_key_bindings
  # fish_default_key_bindings
  fish_vi_key_bindings
end
### END OF VI MODE ###

### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan
# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias la='exa -a'
alias ll='exa -l'
#replace ls by exa (a replacement for ls written in Rust)
alias ls='exa'

alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias fetchpull='git fetch && git pull'

#gotop alias to replace top (always use gotop or htop over top)
# alias top=gotop

alias agenda='nvim ~/Documents/Notes/AGENDA.md'
alias notes='cd ~/Documents/Notes/'
alias gym='nvim ~/Documents/Notes/gym.md'

# open ~/.bash_aliases in vim simply by typing bashalias in the shell.
alias bash_aliases='nvim ~/.bash_aliases'

# open ~/.bashrc in vim simply by typing bashrc in the shell.
alias bashrc='nvim ~/.bashrc'

# open ~/.zshrc in vim simply by typing zshrc in the shell
alias zshrc='nvim ~/.zshrc'
alias fishrc='nvim ~/.config/fish/config.fish'

# opens the init.vim config file (equivalent of vimrc for neovim).
alias vimrc='nvim ~/.config/nvim/init.vim'

# open ~/.config/alacritty/alacritty.yml
alias alacrittyrc='nvim ~/.config/alacritty.yml'

# open ~/.config/kitty/kitty.yml
alias kittyrc='nvim ~/.config/kitty/kitty.conf'

#Vim alias
alias v=nvim

#Vim style exit
alias q=exit

#python aliases
alias python=python3
alias py=python3

#za for zathura document viewer
# alias za=zathura

#Remove bluelight.
# alias flux='redshift'

# pipe to X11 clipboard
# alias xc='xclip -selection clipboard'

# macos specific
alias xc='pbcopy'

# grep coloring by default
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias pgrep='pgrep --color=auto'


# Get today's bitcoin price graph within terminal
alias btc='curl http://rate.sx/btc@1d'
# get top 10 crypto currency info within terminal.
# for help simply do curl rate.sx/:help
alias crypto='curl rate.sx'

alias claer="clear"
alias cler="clear"
alias celar="clear"
alias clar="clear"
alias clera="clear"

# requires "howdoi" to be installed
alias how="howdoi"

# requires ripgrep (rg).
# Use smart case (only case sensitive if contains capital letters)
alias rg="rg -S"

set -U fish_cursor_insert line
starship init fish | source

