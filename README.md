# Dotfiles.


Config files for Neovim, Fish, Bash aliases, Tmux, and Kitty.
View the comments in the files for more specifications.


## Examples:


![telescope](https://user-images.githubusercontent.com/39924874/160036224-b64a3aee-d09a-4adc-a640-4fa27c846bda.png)


![nvim](https://user-images.githubusercontent.com/39924874/160037643-d9ce55ee-cf80-4e58-a513-9a9d3ce8cedb.png)


![cava-cmatrix](https://user-images.githubusercontent.com/39924874/160253252-b8231c1a-db07-4dbe-b1ad-a2ef0ed03af9.png)

## Auto install


To automatically install the config run install.sh.



On first nvim launch, lazy.nvim bootstraps and installs all plugins, and mason
installs the LSP servers / formatters / linters automatically.


---


## Bash


Basic bash configurations. In vi mode by default (defaults to insert mode on launch).


Aliases in .bash_aliases (shared/mirrored in the fish config).


Very standard except for the Rust specific exports. ls replaced by exa (exa needs
to be installed).


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

