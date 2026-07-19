-- ============================================================================
-- Git review workflow (homemade)
-- ----------------------------------------------------------------------------
-- Optimizes the "something changed a bunch of files (Claude in the terminal,
-- a branch, ...) -> drill into each in nvim and make small edits" loop.
--
--   :Review [base]   snapshot the changed-file set, enter a guided session,
--                    and open the first hunk. No base -> uncommitted changes
--                    vs HEAD (staged + unstaged + untracked). A branch/range
--                    base (e.g. origin/main, origin/main...HEAD) does PR-style
--                    review, skipping untracked noise.
--
-- Guided session: while active, <CR> walks to the next hunk and <BS> to the
-- previous one, automatically crossing file boundaries. Each landing scrolls to
-- the hunk and prints a hint footer, so there is nothing to memorize.
-- :ReviewQuit / <leader>gx ends the session.
--
-- Diff viewing is inline, drawn right in the editable buffer: deleted lines
-- show as virtual text and intra-line changes get word-level highlighting (a
-- delta-like, in-context view -- no floating window, and you can edit freely
-- while it's shown). Native side-by-side (<leader>gd) stays as an escape hatch;
-- <leader>gp still gives a one-off float; delta stays in the terminal for the
-- read-only scan pass.
--
-- Self-contained: this module owns ALL git keymaps + the session mode, so the
-- whole feature lives in one file. Registered from init.lua.
-- ============================================================================
local M = {}

local state = { files = {}, idx = 0, base = "HEAD", active = false }

-- Run git with list-form args (no shell, so paths/spaces are safe). Returns
-- stdout lines, or nil if git failed (not a repo, no HEAD, etc.).
local function git_lines(args)
  local cmd = { "git" }
  vim.list_extend(cmd, args)
  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return out
end

-- The ordered, de-duplicated set of changed files vs `base`, as absolute paths.
-- Deletes are filtered out (nothing to open); untracked files are included only
-- for the working-tree case (base == "HEAD").
local function changed_files(base)
  local files = git_lines({ "diff", "--name-only", "--diff-filter=ACMRT", base }) or {}
  if base == "HEAD" then
    vim.list_extend(files, git_lines({ "ls-files", "--others", "--exclude-standard" }) or {})
  end
  local root = (git_lines({ "rev-parse", "--show-toplevel" }) or {})[1]
  local seen, result = {}, {}
  for _, f in ipairs(files) do
    if f ~= "" and not seen[f] then
      seen[f] = true
      result[#result + 1] = root and (root .. "/" .. f) or f
    end
  end
  return result
end

-- Sorted list of the start lines of every hunk in `bufnr`, or nil if gitsigns
-- has not attached / computed the diff yet.
local function hunk_starts(bufnr)
  local ok, gs = pcall(require, "gitsigns")
  local hunks = ok and gs.get_hunks(bufnr) or nil
  if not hunks then
    return nil
  end
  local starts = {}
  for _, h in ipairs(hunks) do
    starts[#starts + 1] = math.max((h.added and h.added.start) or 1, 1)
  end
  table.sort(starts)
  return starts
end

-- Trim `s` to at most `w` display columns (multibyte-safe).
local function truncate(s, w)
  if w <= 0 then
    return ""
  end
  local n = vim.fn.strchars(s)
  while n > 0 and vim.fn.strdisplaywidth(vim.fn.strcharpart(s, 0, n)) > w do
    n = n - 1
  end
  return vim.fn.strcharpart(s, 0, n)
end

-- One hint/HUD line: position in the changeset + the session key legend. Kept
-- to a single screen line -- a wrapped :echo triggers the "Press ENTER" prompt,
-- which would eat every other <CR>.
local function show_hint(bufnr)
  local starts = hunk_starts(bufnr) or {}
  local cur = vim.api.nvim_win_get_cursor(0)[1]
  local hi = 0
  for i, s in ipairs(starts) do
    if s <= cur then
      hi = i
    end
  end
  local file = vim.fn.fnamemodify(state.files[state.idx], ":t")
  local info = string.format("review %d/%d · %s · file %d/%d  ", hi, #starts, file, state.idx, #state.files)
  local legend = "⏎ next  ⌫ prev  ·  gs stage  gr reset  gd diff  gx quit"
  local width = math.max(vim.o.columns - 1, 10)
  local dw = vim.fn.strdisplaywidth
  if dw(info) >= width then
    info, legend = truncate(info, width), ""
  else
    legend = truncate(legend, width - dw(info))
  end
  vim.api.nvim_echo({ { info, "Title" }, { legend, "Comment" } }, false, {})
end

-- Turn the in-buffer diff decorations on/off (global gitsigns config, so it
-- covers every file opened during the session). Deleted lines render inline as
-- virtual text and intra-line changes get word-level highlighting -- a
-- delta-like view drawn directly in the editable buffer, no floating window.
-- Explicit-boolean toggles are idempotent, so re-applying is safe.
local function set_decorations(on)
  pcall(function()
    local gs = require("gitsigns")
    gs.toggle_word_diff(on)
    gs.toggle_deleted(on)
  end)
end

-- Scroll the cursor onto `line`, center it, and refresh the hint footer. The
-- diff itself is the always-on inline decorations (set_decorations), so there
-- is no popup to manage.
local function focus_hunk_line(line, bufnr)
  line = math.min(line, vim.api.nvim_buf_line_count(bufnr))
  vim.api.nvim_win_set_cursor(0, { line, 0 })
  vim.cmd("normal! zz")
  show_hint(bufnr)
end

-- Jump to the first ("first") or last ("last") hunk of `bufnr`. gitsigns
-- computes the diff asynchronously, so hunk_starts() is briefly nil right after
-- opening -- poll (capped ~800ms) until ready. Bails if the user moved on.
local function goto_edge_hunk(bufnr, which, tries)
  tries = tries or 0
  if not vim.api.nvim_buf_is_valid(bufnr) or vim.api.nvim_get_current_buf() ~= bufnr then
    return
  end
  local starts = hunk_starts(bufnr)
  if not starts or #starts == 0 then
    if tries < 40 then
      vim.defer_fn(function()
        goto_edge_hunk(bufnr, which, tries + 1)
      end, 20)
    end
    return
  end
  focus_hunk_line(which == "last" and starts[#starts] or starts[1], bufnr)
end

-- Open the file at the current index and land on its first/last hunk.
local function open_current(which)
  local path = state.files[state.idx]
  if not path then
    return
  end
  vim.cmd.edit(vim.fn.fnameescape(path))
  if state.active then
    set_decorations(true) -- ensure the freshly opened buffer is decorated
  end
  goto_edge_hunk(vim.api.nvim_get_current_buf(), which or "first")
end

-- ---- Session mode ----------------------------------------------------------
-- While active, <CR>/<BS> walk hunks. Normal-mode <CR>/<BS> are otherwise
-- unmapped in this config, so set-on-enter / del-on-quit clobbers nothing.
local function enable_mode()
  state.active = true
  set_decorations(true)
  vim.keymap.set("n", "<CR>", M.next_hunk, { silent = true, desc = "Review: next hunk" })
  vim.keymap.set("n", "<BS>", M.prev_hunk, { silent = true, desc = "Review: prev hunk" })
end

local function disable_mode()
  state.active = false
  set_decorations(false)
  pcall(vim.keymap.del, "n", "<CR>")
  pcall(vim.keymap.del, "n", "<BS>")
  vim.cmd("echo ''")
end

-- Start (or restart) a guided review session against `base` (defaults to HEAD).
function M.start(base)
  base = (base ~= nil and base ~= "") and base or "HEAD"
  local files = changed_files(base)
  if #files == 0 then
    vim.notify("Review: no changed files vs " .. base, vim.log.levels.WARN)
    return
  end
  state.base = base
  state.files = files
  state.idx = 1
  -- Point gitsigns at the same base so the inline hunk marks match the review
  -- scope (global = true applies it to every buffer, not just the current one).
  pcall(function()
    require("gitsigns").change_base(base, true)
  end)
  enable_mode()
  open_current("first")
end

function M.quit()
  disable_mode()
  vim.notify("Review: session ended", vim.log.levels.INFO)
end

local function require_session()
  if #state.files == 0 then
    vim.notify("Review: run :Review first", vim.log.levels.WARN)
    return false
  end
  return true
end

-- ---- Hunk walk (crosses file boundaries) -----------------------------------
function M.next_hunk()
  if not require_session() then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local cur = vim.api.nvim_win_get_cursor(0)[1]
  for _, s in ipairs(hunk_starts(bufnr) or {}) do
    if s > cur then
      return focus_hunk_line(s, bufnr)
    end
  end
  -- No more hunks below the cursor in this file -> next file's first hunk.
  state.idx = state.idx % #state.files + 1
  open_current("first")
end

function M.prev_hunk()
  if not require_session() then
    return
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local cur = vim.api.nvim_win_get_cursor(0)[1]
  local starts = hunk_starts(bufnr) or {}
  for i = #starts, 1, -1 do
    if starts[i] < cur then
      return focus_hunk_line(starts[i], bufnr)
    end
  end
  -- No earlier hunk in this file -> previous file's last hunk.
  state.idx = (state.idx - 2) % #state.files + 1
  open_current("last")
end

-- ---- File-level jumps (skip a whole file) ----------------------------------
function M.next()
  if not require_session() then
    return
  end
  state.idx = state.idx % #state.files + 1
  open_current("first")
end

function M.prev()
  if not require_session() then
    return
  end
  state.idx = (state.idx - 2) % #state.files + 1
  open_current("first")
end

-- ---- Commands --------------------------------------------------------------
vim.api.nvim_create_user_command("Review", function(opts)
  M.start(opts.args)
end, {
  nargs = "?",
  complete = function(arglead)
    local branches = git_lines({ "branch", "--all", "--format=%(refname:short)" }) or {}
    return vim.tbl_filter(function(b)
      return b:find(arglead, 1, true) ~= nil
    end, branches)
  end,
  desc = "Start a guided git review session (base defaults to HEAD)",
})

vim.api.nvim_create_user_command("ReviewQuit", function()
  M.quit()
end, { desc = "End the git review session" })

-- ---- Keymaps (all git maps live here so the feature is self-contained) ------
local map = vim.keymap.set
local function d(desc)
  return { noremap = true, silent = true, desc = desc }
end

-- Session control + navigation. <CR>/<BS> (hunk walk) are mapped only while a
-- session is active; the maps below are always available.
map("n", "<leader>gn", M.next, d("Review: next file"))
map("n", "<leader>gN", M.prev, d("Review: prev file"))
map("n", "<leader>gx", M.quit, d("Review: quit session"))
map("n", "<leader>gc", "<cmd>Telescope git_status theme=get_ivy<cr>", d("Changed files picker"))
map("n", "<leader>gq", function()
  require("gitsigns").setqflist("all")
end, d("All hunks to quickfix"))

-- Per-hunk navigation within the current file (works outside a session too).
map("n", "<F3>", "<cmd>Gitsigns nav_hunk next<cr>", d("Next git hunk"))
map("n", "<F4>", "<cmd>Gitsigns nav_hunk prev<cr>", d("Prev git hunk"))

-- Hunk operations.
map("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", d("Stage hunk"))
map("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", d("Reset hunk"))
map("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", d("Undo stage hunk"))
map("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", d("Preview hunk (float)"))
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", d("Blame line"))

-- Native side-by-side diff of the current file against the review base.
map("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", d("Diff this file (side-by-side)"))

return M
