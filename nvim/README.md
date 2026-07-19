# Neovim config (0.12.4)

A minimal config that leans on Neovim 0.12 built-ins (native `vim.lsp.config` /
`vim.lsp.enable`, `gc` commenting, `vim.snippet`, OSC52 yank, treesitter folds
and highlighting) so it needs few plugins.

## Layout

```
init.lua
lua/config/{options,keymaps,autocmds,lazy,review}.lua
lua/plugins/{lsp,treesitter,telescope,editor,ui,qol,completion,format,lint}.lua
```

Data and state:

- Data:  `~/.local/share/nvim`  (plugins, mason, treesitter parsers)
- State: `~/.local/state/nvim`  (undo, views)

Leader is `\`.

## Git review workflow (`lua/config/review.lua`)

A self-contained feature for the "something changed a bunch of files → drill
into each in nvim and make small edits" loop. All git keymaps live in this one
file.

```
:Review               review uncommitted changes vs HEAD (staged + unstaged
                      + untracked)
:Review origin/main   PR-style review vs a branch (tab-completes branches;
                      untracked files are skipped). Ranges work too, e.g.
                      :Review origin/main...HEAD
:ReviewQuit           end the session (also <leader>gx)
```

Starting a session repoints gitsigns' base to match the review scope, turns on
inline diff decorations (deleted lines shown as virtual text + word-level
highlighting, drawn right in the editable buffer — no floating window, and you
can edit freely while it's shown), and opens the first hunk. A hint footer on
every jump shows where you are and the available keys:

```
review · hunk 2/4 · foo.rs (file 3/8)  ⏎ next · ⌫ prev · \gs stage · …
```

**While a session is active:**

| Key          | Action                                                  |
|--------------|---------------------------------------------------------|
| `<CR>`       | Next hunk — walks all hunks, auto-crossing into files   |
| `<BS>`       | Previous hunk (crosses back into the prior file)        |
| `<leader>gx` | Quit the session (unmaps `<CR>`/`<BS>`, word-diff off)  |

**Always available (in or out of a session):**

| Key            | Action                                             |
|----------------|----------------------------------------------------|
| `<leader>gn`   | Jump to next file (skip the rest of this one)      |
| `<leader>gN`   | Jump to previous file                              |
| `<leader>gc`   | Fuzzy changed-files picker (`Telescope git_status`)|
| `<leader>gq`   | Send all hunks to the quickfix list                |
| `<F3>` / `<F4>`| Next / prev hunk within the current file           |
| `<leader>gs`   | Stage hunk                                          |
| `<leader>gr`   | Reset hunk                                          |
| `<leader>gu`   | Undo stage hunk                                     |
| `<leader>gp`   | Preview hunk (float)                               |
| `<leader>gb`   | Blame current line                                 |
| `<leader>gd`   | Native side-by-side diff of the file vs base       |

## LSP servers (auto-installed by mason)

- **Languages:** lua_ls, rust_analyzer, gopls, ts_ls (TS + JS), eslint,
  pyright, ruff, clangd, bashls, vimls
- **Web / markup:** html, cssls
- **Config & data:** jsonls, yamlls, taplo (TOML), dockerls, terraformls,
  marksman (Markdown)

Edit the `servers` list in `lua/plugins/lsp.lua` to change.

### Installing servers & tools

Everything installs automatically on first launch: LSP servers via
mason-lspconfig, and formatters/linters via mason-tool-installer (`run_on_start`).
To install or refresh manually:

```
:Mason                 open the UI to view / install / update anything
:MasonToolsInstall     install the formatters + linters now (async)
:MasonToolsUpdate      update them
:MasonInstall <pkg>    install a single package by name
```

Formatters (conform): stylua, prettierd, goimports, shfmt.
Linters (nvim-lint): shellcheck, markdownlint, hadolint.

## Treesitter (main branch) — requires the tree-sitter CLI

Treesitter uses nvim-treesitter's **`main`** branch (master is EOL and its
markdown grammar crashes 0.12.4). The main branch builds parsers with the
**tree-sitter CLI ≥ 0.25**. On macOS:

```sh
brew install tree-sitter-cli   # NOT `tree-sitter` (that's only the library)
```

Parsers install to `~/.local/share/nvim/site/parser`. Update with
`:TSUpdate`. Highlighting is native (`vim.treesitter.start()` on FileType);
incremental selection (gnn/grn/grc/grm) is reimplemented in treesitter.lua.
