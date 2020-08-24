# Useful bash aliases.

# some ls aliases
#replace ls by exa (a replacement for ls written in Rust)
alias la='exa -a'
alias ll='exa -l'
alias ls='exa'


#gotop alias to replace top (use htop for something more top alike). 
alias top=gotop

# open ~/.bashrc in vim simply by typing bashrc in the shell.
alias bashrc='nvim ~/.bashrc'

# open ~/.bash_aliases in vim simply by typing bashalias in the shell.
alias bashalias='nvim ~/.bash_aliases'

# opens the init.vim config file (equivalent of vimrc for neovim).
alias vimrc='nvim ~/.config/nvim/init.vim'

#Vim alias
alias v=nvim

#Vim style exit
alias q=exit

#python aliases
alias python=python3
alias py=python3


# pipe to X11 clipboard
alias xc='xclip -selection clipboard'
# trash is safer than rm
alias rm='trash'

# grep coloring by default
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'



