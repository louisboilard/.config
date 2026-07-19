# Dotfiles.


Config files for Neovim, Fish, Bash aliases, Tmux, and Kitty.
View the comments in the files for more specifications.


## Examples:


![telescope](https://user-images.githubusercontent.com/39924874/160036224-b64a3aee-d09a-4adc-a640-4fa27c846bda.png)


![nvim](https://user-images.githubusercontent.com/39924874/160037643-d9ce55ee-cf80-4e58-a513-9a9d3ce8cedb.png)


![cava-cmatrix](https://user-images.githubusercontent.com/39924874/160253252-b8231c1a-db07-4dbe-b1ad-a2ef0ed03af9.png)

## Install

`install.sh` bootstraps everything on **macOS or Ubuntu/Debian**. It's
idempotent (safe to re-run).

Prerequisites — just enough to clone this repo; the script installs the rest
(including Homebrew on macOS):

- **macOS:** `curl` is built in; `git` ships with the Xcode Command Line Tools.
  Run `xcode-select --install` once, then clone. You do **not** install Homebrew
  yourself — `install.sh` does that.
- **Ubuntu/Debian:** `sudo apt update && sudo apt install -y git curl`.

Then:

```sh
git clone <this-repo> ~/Dotfiles && ~/Dotfiles/.config/install.sh
```

What it does:

- Installs the latest core tools — neovim, git (+lfs), ripgrep, fd, bat, fzf,
  eza, git-delta, tmux, fish, starship, kitty, node, the tree-sitter CLI, and
  the UbuntuMono Nerd Font (via Homebrew on macOS; apt + official release
  binaries on Linux), plus the Rust toolchain and Talon community setup.
- Deploys the configs by **copying** them into place (`~` and `~/.config`),
  backing up anything it replaces to `~/.dotfiles-backup/<timestamp>/`.
- Rewrites the hardcoded `/opt/homebrew` tool paths in `.tmux.conf` / `kitty.conf`
  to wherever those tools actually live on the machine.
- Sets fish as the default login shell.

Other entry points:

```sh
./install.sh --deploy   # only (re)copy configs + fix up paths (no packages)
./install.sh --update   # git pull, then redeploy configs
```

On first `nvim` launch, lazy.nvim bootstraps its plugins and mason installs the
LSP servers / formatters / linters automatically.

Private, machine-specific aliases go in `~/.bash_aliases.local` (untracked).


---


## Bash


Basic bash configurations. In vi mode by default (defaults to insert mode on launch).


Aliases in .bash_aliases (shared with the fish config, which sources it).


Very standard except for the Rust specific exports. ls is replaced by eza.


## Nvim


Neovim 0.12 config that leans on the editor's built-ins (native LSP, treesitter,
`gc` commenting, snippets) with a small, modern plugin set managed by lazy.nvim.
LSP servers, formatters and linters install automatically via mason on first
launch. See `nvim/README.md` for the full layout, LSP list, and the built-in
git-review workflow (`:Review`).


Requirements: ripgrep + fzf (telescope), and the tree-sitter CLI
(`brew install tree-sitter-cli`) for parser builds.


Theme: pyramid.


#### Workflow:


Open nvim at the project root, then:

- `ctrl-p` — telescope file finder (`ctrl-v` on a result opens it in a split)
- `space` — grep the word under the cursor; `leader-space` — live grep (ripgrep)
- `ctrl-^` / `F2` — switch between the two most recent buffers
- `ctrl-v` / `ctrl-s` — vertical / horizontal split
- `ctrl-o` / `ctrl-i` — jumplist; `g;` / `g,` — change list
- `leader-enter` — toggle the built-in terminal

Leader is `\`. See the config for the (many) other custom maps.


## Tmux


Includes mouse scrolling. Default prefix is remapped to C-a as
opposed to the default C-b.


## Fish


In vi mode by default. Alternative to zsh/bash/dash.
Better out of the box autocomplete and has some nice features
and default cmd's. Config file -> config.fish


## Kitty


Terminal emulator. Config in kitty.conf.

