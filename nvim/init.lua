-- ============================================================================
-- Neovim 0.12.4 config
-- ----------------------------------------------------------------------------
-- A minimal config that leans on Neovim 0.12 built-ins (native LSP
-- config/enable, completion, snippets, gc commenting, OSC52 yank, better
-- diagnostics) so it needs few plugins.
-- ============================================================================

-- Leader = backslash. Must be set before lazy loads plugin keymaps.
vim.g.mapleader = [[\]]
vim.g.maplocalleader = [[\]]

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
require("config.review") -- homemade git-review workflow (:Review, <leader>g*)
