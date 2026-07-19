#!/usr/bin/env bash
#
# Bootstrap Louis's dotfiles on macOS or Ubuntu/Debian.
#
# Idempotent and safe to re-run. Installs the latest core tools, deploys the
# configs from this repo (by COPYING, backing up anything it replaces), rewrites
# a few hardcoded tool paths for this machine, sets fish as the default shell,
# and optionally sets up Rust + Talon.
#
# Usage:
#   ./install.sh            full bootstrap (packages + config deploy + shell)
#   ./install.sh --deploy   only (re)copy config files into place + fix up paths
#   ./install.sh --update   git pull, then redeploy configs
#   ./install.sh --help
#
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"
ARCH="$(uname -m)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# ---------------------------------------------------------------- pretty output
c_g=$'\033[1;32m'; c_y=$'\033[1;33m'; c_r=$'\033[1;31m'; c_0=$'\033[0m'
log()  { printf '%s==>%s %s\n' "$c_g" "$c_0" "$*"; }
warn() { printf '%s!  %s %s\n' "$c_y" "$c_0" "$*" >&2; }
die()  { printf '%sxx%s %s\n' "$c_r" "$c_0" "$*" >&2; exit 1; }
have() { command -v "$1" >/dev/null 2>&1; }

show_help() { awk 'NR>2 && /^#/{sub(/^# ?/,"");print;next} NR>2{exit}' "$0"; }

# Newest release tag (without leading v) for a GitHub owner/repo.
latest_release() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" 2>/dev/null \
    | grep -m1 '"tag_name"' | sed -E 's/.*"tag_name": *"v?([^"]+)".*/\1/'
}

# ============================================================ config deployment
backup() {
  local dst="$1"
  [ -e "$dst" ] || return 0
  local rel="${dst#"$HOME"/}"
  mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
  cp -a "$dst" "$BACKUP_DIR/$rel"
}

deploy_file() {                       # deploy_file <repo-relative> <dest>
  local src="$DOTFILES/$1" dst="$2"
  [ -e "$src" ] || { warn "missing in repo: $1"; return; }
  [ -e "$dst" ] && cmp -s "$src" "$dst" && return   # already identical
  backup "$dst"
  mkdir -p "$(dirname "$dst")"
  cp -a "$src" "$dst"
  log "deployed $dst"
}

deploy_dir() {                        # deploy_dir <repo-relative> <dest-dir>
  local src="$DOTFILES/$1" dst="$2"
  [ -d "$src" ] || { warn "missing dir in repo: $1"; return; }
  backup "$dst"
  mkdir -p "$dst"
  cp -a "$src/." "$dst/"
  log "deployed $dst/"
}

# Rewrite the few hardcoded /opt/homebrew paths to wherever the tools actually
# live on THIS machine (Intel mac, Apple-silicon mac, or Linux). Operates on the
# deployed copies only, so the repo stays canonical.
fixup_paths() {
  local fish nvim fzf
  fish="$(command -v fish || true)"
  nvim="$(command -v nvim || true)"
  fzf="$(command -v fzf  || true)"
  if [ -n "$fish" ] && [ -f "$HOME/.tmux.conf" ]; then
    perl -pi -e "s{/opt/homebrew/bin/fish}{$fish}g" "$HOME/.tmux.conf"
  fi
  if [ -f "$HOME/.config/kitty/kitty.conf" ]; then
    [ -n "$nvim" ] && perl -pi -e "s{/opt/homebrew/bin/nvim}{$nvim}g" "$HOME/.config/kitty/kitty.conf"
    [ -n "$fzf"  ] && perl -pi -e "s{/opt/homebrew/bin/fzf}{$fzf}g"  "$HOME/.config/kitty/kitty.conf"
  fi
  # Linux: swap macOS pbcopy for xclip in the clipboard binding/alias.
  if [ "$OS" = Linux ]; then
    [ -f "$HOME/.tmux.conf" ] && \
      perl -pi -e 's{pbcopy}{xclip -selection clipboard -i}g' "$HOME/.tmux.conf"
    [ -f "$HOME/.bash_aliases" ] && \
      perl -pi -e "s{alias xc='pbcopy'}{alias xc='xclip -selection clipboard'}g" "$HOME/.bash_aliases"
  fi
}

deploy_configs() {
  log "deploying configs (copying; backups -> $BACKUP_DIR)"
  deploy_file .bashrc       "$HOME/.bashrc"
  deploy_file .bash_aliases "$HOME/.bash_aliases"
  deploy_file .gitconfig    "$HOME/.gitconfig"
  deploy_file .tmux.conf    "$HOME/.tmux.conf"
  deploy_file config.fish   "$HOME/.config/fish/config.fish"
  deploy_file starship.toml "$HOME/.config/starship.toml"
  deploy_dir  kitty         "$HOME/.config/kitty"
  deploy_dir  nvim          "$HOME/.config/nvim"
  fixup_paths
}

# ================================================================ macOS packages
install_macos() {
  if ! have brew; then
    log "installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$('/opt/homebrew/bin/brew' shellenv 2>/dev/null || '/usr/local/bin/brew' shellenv)"
  fi
  log "brew update"
  brew update
  log "installing core tools (latest)"
  brew install neovim git git-lfs ripgrep fd bat fzf eza git-delta \
    tmux fish starship tree-sitter-cli node
  brew install --cask kitty || warn "kitty cask already present or failed"
  brew install --cask font-ubuntu-mono-nerd-font || warn "nerd font cask failed"
  git lfs install || true
}

# ================================================================ Linux packages
install_linux() {
  have apt-get || die "Linux support targets Debian/Ubuntu (apt) only"
  export DEBIAN_FRONTEND=noninteractive
  mkdir -p "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"

  log "apt update + base packages"
  sudo apt-get update -y
  sudo apt-get install -y \
    build-essential curl wget git git-lfs unzip tar ca-certificates gnupg \
    fontconfig ripgrep tmux fish xclip
  git lfs install || true

  # bat/fd ship with renamed binaries on Debian/Ubuntu.
  sudo apt-get install -y bat fd-find || true
  have batcat && ln -sf "$(command -v batcat)" "$HOME/.local/bin/bat"
  have fdfind && ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"

  install_node_linux
  install_neovim_linux
  install_fzf_linux
  install_eza_linux
  install_delta_linux
  install_treesitter_cli
  install_starship
  install_kitty_linux
  install_fonts_linux
}

install_node_linux() {
  have node && return
  log "installing Node.js (NodeSource LTS)"
  curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
  sudo apt-get install -y nodejs
}

install_neovim_linux() {
  log "installing latest Neovim (stable release)"
  local asset
  case "$ARCH" in
    x86_64|amd64)  asset="nvim-linux-x86_64.tar.gz" ;;
    aarch64|arm64) asset="nvim-linux-arm64.tar.gz"  ;;
    *) die "unsupported arch for neovim: $ARCH" ;;
  esac
  local base="https://github.com/neovim/neovim/releases/download/stable"
  local tmp; tmp="$(mktemp -d)"
  if ! curl -fsSL "$base/$asset" -o "$tmp/nvim.tar.gz"; then
    warn "$asset not found; trying legacy nvim-linux64.tar.gz"
    curl -fsSL "$base/nvim-linux64.tar.gz" -o "$tmp/nvim.tar.gz" \
      || die "neovim download failed"
  fi
  sudo rm -rf /opt/nvim
  sudo mkdir -p /opt/nvim
  sudo tar -xzf "$tmp/nvim.tar.gz" -C /opt/nvim --strip-components=1
  sudo ln -sf /opt/nvim/bin/nvim /usr/local/bin/nvim
  rm -rf "$tmp"
}

# Official git install -> latest fzf + the `fzf --fish` integration config.fish needs.
install_fzf_linux() {
  if [ -d "$HOME/.fzf/.git" ]; then
    git -C "$HOME/.fzf" pull --ff-only || true
  else
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
  fi
  "$HOME/.fzf/install" --bin >/dev/null
  ln -sf "$HOME/.fzf/bin/fzf" "$HOME/.local/bin/fzf"
}

install_eza_linux() {
  have eza && return
  log "installing eza (official apt repo)"
  sudo mkdir -p /etc/apt/keyrings
  if wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc \
       | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg; then
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" \
      | sudo tee /etc/apt/sources.list.d/gierens.list >/dev/null
    sudo apt-get update -y && sudo apt-get install -y eza && return
  fi
  warn "eza apt repo failed; trying cargo"
  have cargo && cargo install eza || warn "eza install failed"
}

install_delta_linux() {
  have delta && return
  log "installing git-delta"
  local ver deb tmp; ver="$(latest_release dandavison/delta)"
  case "$ARCH" in
    x86_64|amd64)  deb="git-delta_${ver}_amd64.deb" ;;
    aarch64|arm64) deb="git-delta_${ver}_arm64.deb" ;;
  esac
  tmp="$(mktemp -d)"
  if [ -n "$ver" ] && curl -fsSL \
       "https://github.com/dandavison/delta/releases/download/${ver}/${deb}" \
       -o "$tmp/delta.deb"; then
    sudo dpkg -i "$tmp/delta.deb" || sudo apt-get -f install -y
  else
    warn "delta .deb unavailable; trying cargo"
    have cargo && cargo install git-delta || warn "delta install failed"
  fi
  rm -rf "$tmp"
}

install_treesitter_cli() {
  have tree-sitter && return
  log "installing tree-sitter CLI"
  if have npm; then
    sudo npm install -g tree-sitter-cli || npm install -g tree-sitter-cli
  elif have cargo; then
    cargo install tree-sitter-cli
  else
    warn "need npm or cargo to install tree-sitter-cli"
  fi
}

install_fonts_linux() {
  fc-list 2>/dev/null | grep -qi "UbuntuMono Nerd Font" && return
  log "installing UbuntuMono Nerd Font"
  local ver url tmp dir="$HOME/.local/share/fonts"
  ver="$(latest_release ryanoasis/nerd-fonts)"
  url="https://github.com/ryanoasis/nerd-fonts/releases/download/${ver}/UbuntuMono.zip"
  tmp="$(mktemp -d)"; mkdir -p "$dir"
  if [ -n "$ver" ] && curl -fsSL "$url" -o "$tmp/font.zip"; then
    unzip -oq "$tmp/font.zip" -d "$dir/UbuntuMonoNerdFont"
    fc-cache -f >/dev/null 2>&1 || true
  else
    warn "nerd font download failed (install a Nerd Font manually)"
  fi
  rm -rf "$tmp"
}

install_kitty_linux() {
  have kitty && return
  log "installing kitty (official installer)"
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  mkdir -p "$HOME/.local/bin" "$HOME/.local/share/applications"
  ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/kitty.app/bin/kitten" \
    "$HOME/.local/bin/"
  cp "$HOME/.local/kitty.app/share/applications/kitty.desktop" \
     "$HOME/.local/share/applications/" 2>/dev/null || true
}

# ================================================================ cross-platform
install_starship() {
  have starship && return
  log "installing starship"
  curl -sS https://starship.rs/install.sh | sh -s -- --yes
}

install_rust() {
  have cargo && return
  log "installing Rust (rustup)"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # shellcheck disable=SC1091
  [ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
}

set_default_shell() {
  local fish_path; fish_path="$(command -v fish || true)"
  [ -n "$fish_path" ] || { warn "fish not found; skipping default-shell change"; return; }
  grep -qx "$fish_path" /etc/shells 2>/dev/null || \
    echo "$fish_path" | sudo tee -a /etc/shells >/dev/null
  if [ "${SHELL:-}" != "$fish_path" ]; then
    log "setting fish as default shell (may prompt for your password)"
    chsh -s "$fish_path" || warn "chsh failed; change your login shell manually"
  fi
}

set_default_terminal() {
  if [ "$OS" != Linux ]; then
    log "default terminal: macOS has no system setting for this; launch kitty directly"
    return
  fi
  local kbin; kbin="$(command -v kitty || true)"
  [ -n "$kbin" ] || { warn "kitty not found; skipping default-terminal"; return; }
  log "setting kitty as default terminal (xdg + update-alternatives)"
  mkdir -p "$HOME/.config"
  echo 'kitty.desktop' > "$HOME/.config/xdg-terminals.list"
  if have update-alternatives; then
    sudo update-alternatives --install /usr/bin/x-terminal-emulator \
      x-terminal-emulator "$kbin" 50 2>/dev/null || true
    sudo update-alternatives --set x-terminal-emulator "$kbin" 2>/dev/null || true
  fi
}

setup_talon() {
  log "setting up Talon (app + community + custom scripts)"
  if [ "$OS" = Darwin ]; then
    [ -d "/Applications/Talon.app" ] || brew install --cask talon || warn "talon cask failed"
  else
    warn "Talon Linux app has no apt/brew package — download it from https://talonvoice.com/"
  fi
  local community="$HOME/.talon/user/community"
  mkdir -p "$HOME/.talon/user"
  if [ -d "$community/.git" ]; then
    git -C "$community" pull --ff-only || true
  elif [ ! -d "$community" ]; then
    git clone https://github.com/talonhub/community.git "$community"
  fi
  mkdir -p "$community/kitty"
  cp -a "$DOTFILES/talon/kitty/." "$community/kitty/"
}

post_notes() {
  cat <<EOF

${c_g}Bootstrap complete.${c_0}
 * Open nvim once so lazy.nvim + mason install plugins, LSPs, formatters and
   linters (they rely on node + the tree-sitter CLI, both now installed).
 * Restart your terminal (or log out/in) for the default-shell change to apply.
 * Private, machine-specific aliases go in ~/.bash_aliases.local (untracked).
 * Set your git identity (the tracked .gitconfig leaves it blank on purpose):
     git config --global user.name  "Your Name"
     git config --global user.email "you@example.com"
 * Replaced files were backed up under: $BACKUP_DIR
EOF
}

# ============================================================================ main
main() {
  case "${1:-}" in
    --deploy)  deploy_configs; exit 0 ;;
    --update)  log "pulling latest dotfiles"; git -C "$DOTFILES" pull --ff-only; deploy_configs; exit 0 ;;
    --help|-h) show_help; exit 0 ;;
    "")        ;;
    *)         die "unknown option: $1 (try --help)" ;;
  esac

  export PATH="$HOME/.local/bin:$PATH"
  case "$OS" in
    Darwin) install_macos ;;
    Linux)  install_linux ;;
    *)      die "unsupported OS: $OS" ;;
  esac

  install_rust
  install_treesitter_cli   # no-op if already present (e.g. brew on macOS)
  deploy_configs
  set_default_shell
  set_default_terminal
  setup_talon
  post_notes
}

main "$@"
