-- Autocommands.
local aug = function(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

-- Jump to last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = aug("last_cursor"),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug("yank_hl"),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

-- Soft-wrap inside the harpoon menu
vim.api.nvim_create_autocmd("FileType", {
  group = aug("harpoon_wrap"),
  pattern = "harpoon",
  callback = function()
    vim.opt_local.wrap = true
  end,
})

-- Terminal buffer keymaps
vim.api.nvim_create_autocmd("TermOpen", {
  group = aug("term"),
  callback = function()
    local t = { buffer = 0, noremap = true }
    vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], t)
    vim.keymap.set("t", "jk", [[<C-\><C-n>]], t)
    vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], t)
    vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], t)
    vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], t)
    vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], t)
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Custom highlights + transparency tweaks, re-applied on every colorscheme
-- change so they always stick.
local function custom_highlights()
  local hl = function(name, spec)
    vim.api.nvim_set_hl(0, name, spec)
  end
  -- Transparency: let the terminal background show through for the editor
  -- itself, but NOT floating windows / popup menus -- those need a solid
  -- background so completion, hover and signature-help popups stay readable
  -- (a transparent NormalFloat makes them bleed over the code behind them).
  for _, group in ipairs({
    "Normal", "NormalNC", "NonText", "SignColumn", "TabLine",
  }) do
    hl(group, { bg = "none" })
  end
  -- ColorColumn is reused by render-markdown (code blocks) and doc/hover
  -- popups, so keep it subtle.
  hl("ColorColumn", { bg = "#2b2825" })
  -- Inlay hints (LSP type/parameter hints): dim like comments, not bright.
  hl("LspInlayHint", { link = "Comment" })
  -- quick-scope highlight colors
  hl("QuickScopePrimary", { fg = "#afff5f", underline = true })
  hl("QuickScopeSecondary", { fg = "#5fffff", underline = true })
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = aug("highlights"),
  callback = custom_highlights,
})
