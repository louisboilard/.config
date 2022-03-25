#Configuration file for zsh

# Path to your oh-my-zsh installation.
export ZSH="/home/boilou/.oh-my-zsh"

export ZSH=$HOME/.oh-my-zsh

#theme
# ZSH_THEME=""

#sets the ZSH source.
source $ZSH/oh-my-zsh.sh

# Enable colors and change prompt:
autoload -U colors && colors
#PS1="%B%{$fg[black]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[yellow]%}ツ% %{$fg[magenta]%}%~%{$fg[black]%}]%{$reset_color%}$%b "

# PS1="%B%{$fg[white]%}[%{$fg[yellow]%}ツ% %{$fg[magenta]%}%~%{$fg[white]%}]%{$reset_color%}$%b "

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode on startup (defaults to insert mode)
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[2 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[6 q'
  fi
}

zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[6 q"
}
zle -N zle-line-init
echo -ne '\e[6 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.

# Ctrl-p will open fzf with preview (bat must be installed).
bindkey -s '^p' 'fzf\n'
export FZF_DEFAULT_OPTS='--layout=reverse --preview "bat --style=numbers --color=always --line-range :500 {}"'

#displays current date when opening new shell.
date +%d-%m-%Y

# Plugins.
plugins=(zsh-syntax-highlighting)

# Load aliases and shortcuts if existent.
[ -f "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"

export PATH=$PATH:/usr/local/go/bin

export GOPATH=$HOME/go
# Load zsh-syntax-highlighting; should be last thing of the file
source $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(starship init zsh)"
