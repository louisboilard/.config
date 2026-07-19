local opt = vim.opt

-- Folding: treesitter-based (folds by real code structure), open by default
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99

-- No swap/backup; keep persistent undo + views
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.viewdir = vim.fn.stdpath("state") .. "/views"

opt.ruler = true
opt.showcmd = true
opt.signcolumn = "yes"

-- Tabs: 4-wide, expanded to spaces
opt.tabstop = 4
opt.expandtab = true
opt.shiftwidth = 4

opt.path:append("**")
opt.wildmenu = true
opt.scrolloff = 8

opt.wrap = true
opt.linebreak = true

opt.mouse = "a"

-- System clipboard as default register
opt.clipboard = "unnamedplus"

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

opt.relativenumber = true
opt.number = true

opt.hidden = true
opt.termguicolors = true
opt.textwidth = 80

-- Native completion menu (0.11+: `popup` shows info, `fuzzy` for fuzzy match)
opt.completeopt = "menuone,noselect,popup,fuzzy"

-- Show trailing whitespace
opt.list = true
opt.listchars:append({ trail = "·" })

-- Hand-rolled statusline (no lualine)
opt.laststatus = 2
opt.statusline = " %f 🧙 %= %l:%c "

-- OSC52 clipboard over SSH (built-in since 0.10). Only kicks in inside an SSH
-- session; local macOS keeps using pbcopy.
if vim.env.SSH_TTY then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
end
