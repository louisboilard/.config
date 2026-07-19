if status is-interactive
    # Commands to run in interactive sessions can go here.
end

set -e fish_user_paths

# vi mode
function fish_user_key_bindings
  fish_vi_key_bindings
  # Ctrl-p opens fzf with a bat preview (in normal mode).
  bind \cp 'fzf'
end
set fish_vi_force_cursor
set -U fish_cursor_insert line

export FZF_DEFAULT_OPTS='--layout=reverse --preview "bat --style=numbers --color=always --line-range :500 {}"'

# autocomplete / highlight colors
set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# shared aliases
[ -f "$HOME/.bash_aliases" ] && source "$HOME/.bash_aliases"

# PATH + default editor
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim
export VISUAL=nvim

fzf --fish | source
starship init fish | source
