# Useful shell aliases (sourced by both bash and fish).
# Machine-specific / private aliases go in ~/.bash_aliases.local (untracked).

# ls -> exa
alias la='exa -a'
alias ll='exa -l --icons'
alias ls='exa'

# git
alias gs='git status -uno'          # -uno: hide untracked files
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gcm='git checkout main'
alias fetchpull='git fetch && git pull'

# open configs quickly
alias bash_aliases='nvim ~/.bash_aliases'
alias bashrc='nvim ~/.bashrc'
alias fishrc='nvim ~/.config/fish/config.fish'
alias kittyrc='nvim ~/.config/kitty/kitty.conf'
alias vimrc='nvim ~/.config/nvim/init.lua'

# editor / misc
alias v=nvim
alias q=exit
alias py=python3

# osx clipboard
alias xc='pbcopy'
alias f='fzf | xc'

# grep coloring
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# kubernetes
alias k8="kubectl"
# Pick a pod with fzf, then describe it. ($s are escaped so they survive alias
# definition; xargs -I% means a cancelled fzf selection runs nothing.)
alias kube_describe="kubectl get pods -A --no-headers | fzf | awk '{print \$1, \$2}' | xargs -I% sh -c 'set -- %; kubectl describe pod \"\$2\" -n \"\$1\"'"

# ripgrep (smart case); rgp also excludes json
alias rg="rg -S"
alias rgp="rg -S -g '!*.json'"

# clear typos
alias claer="clear"
alias cler="clear"
alias celar="clear"
alias clar="clear"
alias clera="clear"

# Machine-specific / private aliases, not tracked in git.
[ -f "$HOME/.bash_aliases.local" ] && source "$HOME/.bash_aliases.local"
