-- nvim-treesitter MAIN branch (the 0.12+ native line; master is EOL and its
-- markdown grammar/queries crash 0.12.4's injection parser). Highlighting is
-- Neovim-native via vim.treesitter.start(); textobjects use the new API; and
-- incremental selection is reimplemented since main dropped that module.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
    },
    config = function()
      require("nvim-treesitter").setup()

      local langs = {
        "lua", "rust", "go", "typescript", "javascript", "tsx",
        "html", "css", "python", "c", "cpp", "bash", "json", "yaml",
        "markdown", "markdown_inline", "vim", "vimdoc", "query",
      }
      require("nvim-treesitter").install(langs)

      -- Enable highlighting + (experimental) indent per buffer.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_ts_start", { clear = true }),
        callback = function(ev)
          -- start() maps filetype -> language; pcall so filetypes without an
          -- installed parser are a no-op instead of an error.
          if pcall(vim.treesitter.start) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      -- ---- Textobjects (main-branch API) -----------------------------------
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local sel = require("nvim-treesitter-textobjects.select")
      local swap = require("nvim-treesitter-textobjects.swap")
      local move = require("nvim-treesitter-textobjects.move")

      local function map_sel(key, obj)
        vim.keymap.set({ "x", "o" }, key, function()
          sel.select_textobject(obj, "textobjects")
        end, { desc = "TS select " .. obj })
      end
      map_sel("af", "@function.outer")
      map_sel("if", "@function.inner")
      map_sel("ab", "@block.outer")
      map_sel("ib", "@block.inner")
      map_sel("as", "@statement.outer")
      map_sel("is", "@statement.inner")

      vim.keymap.set("n", "<leader>a", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap next parameter" })
      vim.keymap.set("n", "<leader>A", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap previous parameter" })

      local function map_move(key, fn, obj)
        vim.keymap.set({ "n", "x", "o" }, key, function()
          move[fn](obj, "textobjects")
        end, { desc = "TS " .. fn .. " " .. obj })
      end
      map_move("[f", "goto_next_start", "@function.outer")
      map_move("[c", "goto_next_start", "@class.outer")
      map_move("]M", "goto_next_end", "@function.outer")
      map_move("]f", "goto_previous_start", "@function.outer")
      map_move("]c", "goto_previous_start", "@class.outer")
      map_move("[M", "goto_previous_end", "@function.outer")

      -- ---- Incremental selection (gnn / grn / grc / grm) --------------------
      -- Minimal reimplementation of the module master had (main dropped it).
      local stacks = {}
      local function range_eq(a, b)
        local a1, a2, a3, a4 = a:range()
        local b1, b2, b3, b4 = b:range()
        return a1 == b1 and a2 == b2 and a3 == b3 and a4 == b4
      end
      local function visual_select(node)
        local sr, sc, er, ec = node:range()
        vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
        vim.cmd("normal! v")
        if ec == 0 then -- node ends at column 0 -> last char is on previous line
          er = er - 1
          ec = #(vim.api.nvim_buf_get_lines(0, er, er + 1, false)[1] or "")
        end
        vim.api.nvim_win_set_cursor(0, { er + 1, math.max(ec - 1, 0) })
      end
      local function init_sel()
        local buf = vim.api.nvim_get_current_buf()
        local node = vim.treesitter.get_node()
        if not node then return end
        stacks[buf] = { node }
        visual_select(node)
      end
      local function expand_sel()
        local buf = vim.api.nvim_get_current_buf()
        local st = stacks[buf]
        if not st or #st == 0 then return init_sel() end
        local node = st[#st]
        local parent = node:parent()
        while parent and range_eq(parent, node) do
          parent = parent:parent()
        end
        if parent then
          st[#st + 1] = parent
          visual_select(parent)
        end
      end
      local function shrink_sel()
        local buf = vim.api.nvim_get_current_buf()
        local st = stacks[buf]
        if not st or #st < 2 then return end
        table.remove(st)
        visual_select(st[#st])
      end
      vim.keymap.set("n", "gnn", init_sel, { desc = "TS init selection" })
      vim.keymap.set("x", "grn", expand_sel, { desc = "TS expand node" })
      vim.keymap.set("x", "grc", expand_sel, { desc = "TS expand (scope)" })
      vim.keymap.set("x", "grm", shrink_sel, { desc = "TS shrink node" })
    end,
  },
}
