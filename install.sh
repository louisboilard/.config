#!/usr/bin/bash

echo "Welcome to Boilard's config installer TM"

# .config dir where most config files will be stored.
echo "Creating .config directory."
configDir=$HOME/.config
if [ ! -d "$configDir" ]; then
  mkdir $HOME/.config
  echo ".config directory created."
else
  echo ".config already exists. Moving on.."
fi

# bash configs
cp ./.bashrc $HOME
cp ./.bash_aliases $HOME

# Update and upgrade apt packages and install basic dependencies
apt update && apt upgrade
apt install build-essential
apt install curl
apt install wget
apt install git
apt install htop
apt install gotop
apt install neofetch

# Install rustc/cargo/exa (ls replacement)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
apt install exa

curl -sS https://starship.rs/install.sh | sh

# install fish
apt-add-repository ppa:fish-shell/release-3
apt update
apt install fish

cp -r ./kitty/ $HOME/.config/kitty

# Install nvim and it's dependencies.
apt install neovim
apt install fzf
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

nvimDir=$HOME/.config/nvim
if [ ! -d "$nvimDir" ]; then
  cp -R ./nvim_lsp $HOME/.config/
else
  cp ./nvim_lsp/init.vim $HOME/.config/nvim/
  cp -R ./nvim_lsp/lua $HOME/.config/nvim/
fi

mkdir $HOME/.config/nvim/backup
mkdir $HOME/.config/nvim/swp

# Install tmux and setup
apt install tmux
cp ./.tmux.conf $HOME/

# Alacritty installation and setup (config + making it the default terminal)
cargo install alacritty
cp ./alacritty.yml $HOME/
update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator $(which alacritty) 50

echo ""
echo ""
echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Thank you for trusting Boilard's script TM"
echo "Please close the terminal, logout and log back in."
