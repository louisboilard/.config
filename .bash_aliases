# Useful bash aliases.

# some ls aliases
alias la='ls -a'
alias ll='ls -alF'
alias l='ls -CF'
#replace ls by exa (a replacement for ls written in Rust)
alias ls='exa'


#gotop alias to replace top (use htop for something more top alike). 
alias top=gotop

# open ~/.bashrc in vim simply by typing bashrc in the shell.
alias bashrc='nvim ~/.bashrc'

# opens the init.vim config file (equivalent of vimrc for neovim).
alias vimrc='nvim ~/.config/nvim/init.vim'

#Vim alias
alias v=nvim


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



