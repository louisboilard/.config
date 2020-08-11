# Dotfiles.


Config files for Bash, NeoVim and Tmux.
View the comments in the files for more specifications.


---


## Bash


Basic bash configurations. In vi mode by default (defaults to insert mode on launch).


Aliases in .bash_aliases


Very standard except for the Rust specific exports. ls replaced by exa (exa needs
to be installed).


## Nvim


Standard vim config except some Rust specific plugins.
See comments in the file for details on how to use and for keys.


Uses Deoplete plugin and language server protocol support (languageClient-neovim plugin) 
for auto completion.


Uses vim-racer and Deoplete plugin (requires racer) for Rust code completion.
Also contains rls but turned off by default since vim-racer+deoplete+syntastic 
were doing better for me.


Nerdtree plugin for file tree.


rust-doc.vim plugin to generate searchable Rust documentation from within neovim.
Requires a local copy of the rust docs.


Syntastic plugin for syntax checking and tooglable error/warning window.


rust-vim plugin for automatic integration of Syntastic, rustfmt (code formatting),
file detection and syntax highlighting.


splitjoin.vim plugin to switch between single-line statement and multi-line.


Theme/colorscheme: neodark.


## Tmux


Includes mouse scrolling. Default prefix is remapped to C-a as 
opposed to the default C-b.
