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
apt install fzf
apt install wget
apt install git
apt install htop
apt install gotop
apt install neofetch
apt install hexyl
apt install bat
apt install nmap
apt install xclip
apt install fd-find
ln -s $(which fdfind) usr/bin/fd

# Install rustc/cargo/exa (ls replacement)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
apt install exa

curl -sS https://starship.rs/install.sh | sh
cp starship.toml $HOME/.config/

cargo install git-delta
cp .gitconfig $HOME/

# install fish
apt-add-repository ppa:fish-shell/release-3
apt update
apt install fish
cp config.fish $HOME/.config/

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
# your system-wide PATH)
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
echo 'kitty.desktop' > ~/.config/xdg-terminals.list

cp -r ./kitty/ $HOME/.config/kitty

# Install nvim and it's dependencies.
apt install neovim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir $HOME/.config/nvim
mkdir $HOME/.config/nvim/backup
mkdir $HOME/.config/nvim/swp
cp -r ./nvim/ $HOME/.config/nvim

# Install tmux and setup
apt install tmux
cp ./.tmux.conf $HOME/

update-alternatives --config x-terminal-emulator

curl -LO https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep_14.1.0-1_amd64.deb
dpkg -i ripgrep_14.1.0-1_amd64.deb

mkdir $HOME/.talon
mkdir $HOME/.talon/user
git clone https://github.com/talonhub/community.git $HOME/.talon/user/
cp -r ./talon/kitty/ $HOME/.talon/user/community

echo ""
echo ""
echo ""
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo "Thank you for trusting Boilard's script TM"
echo "Please close the terminal, logout and log back in."
