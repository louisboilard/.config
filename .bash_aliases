# Useful bash aliases.

# some ls aliases
alias la='exa -a'
alias ll='exa -l'
#replace ls by exa (a replacement for ls written in Rust)
alias ls='exa'


#gotop alias to replace top (always use gotop or htop over top)
alias top=gotop

# open ~/.bash_aliases in vim simply by typing bashalias in the shell.
alias bash_aliases='nvim ~/.bash_aliases'

# open ~/.bashrc in vim simply by typing bashrc in the shell.
alias bashrc='nvim ~/.bashrc'

# open ~/.zshrc in vim simply by typing zshrc in the shell
alias zshrc='nvim ~/.zshrc'

# opens the init.vim config file (equivalent of vimrc for neovim).
alias vimrc='nvim ~/.config/nvim/init.vim'

# open ~/.config/alacritty/alacritty.yml in vim simply by 
#typing alacrittyrc in the shell.
alias alacrittyrc='nvim ~/.config/alacritty/alacritty.yml'

#Vim alias
alias v=nvim

#Vim style exit
alias q=exit

#python aliases
alias python=python3
alias py=python3

#za for zathura document viewer
alias za=zathura

#Remove bluelight.
alias flux='redshift'

# pipe to X11 clipboard
alias xc='xclip -selection clipboard'

# grep coloring by default
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'


# Get today's bitcoin price graph within terminal
alias btc='curl http://rate.sx/btc@1d'
# get top 10 crypto currency info within terminal.
# for help simply do curl rate.sx/:help
alias crypto='curl rate.sx'




