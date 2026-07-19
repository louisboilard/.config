-- General keybindings. LSP-specific maps live in plugins/lsp.lua (buffer-local,
-- on LspAttach).
-- Picker maps that need Telescope also live here (Telescope loads on demand).
local map = vim.keymap.set
local o = { noremap = true, silent = true }
-- d(desc): shared opts (noremap+silent) plus a which-key/Telescope description.
local function d(desc)
  return vim.tbl_extend("force", o, { desc = desc })
end

-- Clear search highlight on Esc
map("n", "<Esc>", "<cmd>noh<cr><Esc>", d("Clear search highlight"))

-- Make Y behave like C and D
map("n", "Y", "y$", d("Yank to end of line"))

-- Keep the cursor centered on common motions
map("n", "n", "nzz", d("Next search match (centered)"))
map("n", "N", "Nzz", d("Prev search match (centered)"))
map("n", "J", "mzJ`z", d("Join lines (keep cursor)"))
map("n", "[[", "5jzz", d("Down 5 lines (centered)"))
map("n", "]]", "5kzz", d("Up 5 lines (centered)"))
map("n", "g;", "g;zz", d("Older change (centered)"))
map("n", "g,", "g,zz", d("Newer change (centered)"))

-- Deletes go to a dedicated `d` register (so `p` never pastes a delete);
-- <leader>p pastes from that delete register.
map({ "n", "v" }, "d", '"dd', d("Delete to d register"))
map({ "n", "v" }, "<leader>p", '"dp', d("Paste from delete register"))

-- Select inside the current {} block
map("n", "<leader>h", "vi{", d("Select inside {} block"))

-- Open a new file adjacent to the current one
map("n", "<leader>o", ':e <C-R>=expand("%:p:h") . "/"<CR>', { noremap = true, desc = "Open file in current dir" })

-- Swap : and ; (colon commands on ;)
map("n", ";", ":", { noremap = true, desc = "Command line (: on ;)" })
map("n", ":", ";", { noremap = true, desc = "Repeat f/t (; on :)" })

-- Prefer block-visual: `v` starts block mode, C-v (in visual) returns to
-- charwise. (Note: C-v in normal mode opens a vsplit, below.)
map("n", "v", "<C-v>", d("Block visual"))
map("v", "v", "<C-v>", d("Block visual"))
map("v", "<C-v>", "v", d("Charwise visual"))

-- Indent the current block with ==
map("n", "==", "=aB", d("Reindent current block"))

-- Swap C-^ and F2 (alternate-file toggle)
map("n", "<C-^>", "<F2>", d("Alternate file"))
map("n", "<F2>", "<C-^>", d("Alternate file"))

-- Splits: open then jump into the new one
map("n", "<C-v>", "<C-w>v<C-w>l", d("Vertical split"))
map("n", "<C-s>", "<C-w>s<C-w>j", d("Horizontal split"))
-- Move between splits
map("n", "<C-l>", "<C-w>l", d("Go to right split"))
map("n", "<C-h>", "<C-w>h", d("Go to left split"))
map("n", "<C-j>", "<C-w>j", d("Go to lower split"))
map("n", "<C-k>", "<C-w>k", d("Go to upper split"))

-- Open current file in a new tab
map("n", "T", ":tabnew<CR><C-o>", d("Open file in new tab"))

-- Spell-checking toggles
map("n", ";s", "<cmd>set invspell spelllang=en<CR>", d("Toggle spell (en)"))
map("n", ";ss", "<cmd>set spell spelllang=en-basic<CR>", d("Spell on (en-basic)"))

-- Diff current buffer against file on disk
map("n", "<F8>", ":w !diff % -<CR>", d("Diff buffer vs disk"))

-- Git maps (hunk nav/ops, native diff, review session) live in
-- config/review.lua so the whole git-review feature is self-contained.

-- Copy full path of current file to clipboard
map("n", "<F7>", ':let @+ = expand("%:p")<CR>', d("Copy file path to clipboard"))

-- Insert-mode boilerplate snippets
map("i", "<F6>", "if err != nil {<cr>}<Esc>", d("Insert err-check boilerplate"))
map("i", "<F7>", 'Console.WriteLine($"{}");<Esc>', d("Insert Console.WriteLine"))

-- ---------------------------------------------------------------------------
-- Telescope pickers
-- ---------------------------------------------------------------------------
map("n", "<C-p>", "<cmd>Telescope find_files theme=get_ivy<cr>", d("Find files"))
map("n", "<space>", "<cmd>Telescope grep_string theme=get_ivy<cr>", d("Grep word under cursor"))
map("n", "<leader><space>", "<cmd>Telescope live_grep theme=get_ivy<cr>", d("Live grep"))
map("n", "<C-x>", "<cmd>Telescope diagnostics theme=get_ivy<cr>", d("Diagnostics picker"))
map("n", "<F9>", "<cmd>Telescope treesitter theme=get_ivy<cr>", d("Treesitter symbols"))
map("n", "<leader>b", "<cmd>Telescope buffers theme=get_ivy<cr>", d("Buffers"))
map("n", "<leader>R", "<cmd>Telescope resume theme=get_ivy<cr>", d("Resume last picker"))
map("n", "<leader>?", "<cmd>Telescope oldfiles theme=get_ivy<cr>", d("Recent files"))

-- File explorer
map("n", "<leader>e", "<cmd>Oil<cr>", d("File explorer (Oil)"))

-- Completion & snippet keymaps are provided by blink.cmp
-- (see plugins/completion.lua) -- nothing to map here.

-- ---------------------------------------------------------------------------
-- Toggleable terminal, bound to <leader><CR>
-- ---------------------------------------------------------------------------
local term = { buf = nil, win = nil }
local function toggle_term()
  if term.win and vim.api.nvim_win_is_valid(term.win) then
    vim.api.nvim_win_hide(term.win)
    term.win = nil
    return
  end
  vim.cmd("botright 15split")
  term.win = vim.api.nvim_get_current_win()
  if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
    vim.api.nvim_win_set_buf(term.win, term.buf)
  else
    vim.cmd("terminal")
    term.buf = vim.api.nvim_get_current_buf()
  end
  vim.cmd("startinsert")
end
map({ "n", "t" }, "<leader><CR>", toggle_term, d("Toggle terminal"))

-- ---------------------------------------------------------------------------
-- User commands
-- ---------------------------------------------------------------------------
vim.api.nvim_create_user_command("RunRust", "tabnew | terminal cargo r", {})
vim.api.nvim_create_user_command("DiffOrig", function()
  vim.cmd("vert new | set buftype=nofile | read ++edit # | 0d_ | diffthis | wincmd p | diffthis")
end, {})
