return {
  -- which-key: popup showing available keymaps as you type a prefix.
  -- Great for recalling your many custom maps + `\` leader bindings.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- Auto close/rename HTML/JSX/TSX/Vue tags (treesitter-based).
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte", "markdown" },
    opts = {},
  },

  -- Highlight + search TODO / FIX / HACK / NOTE comments.
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>t", "<cmd>TodoTelescope<cr>", desc = "Todo list (Telescope)" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
    },
  },

  -- In-editor markdown rendering (headings, lists, code blocks, tables).
  -- Renders inline; the cursor line shows raw markdown so you can edit.
  -- Toggle with <leader>m or `:RenderMarkdown toggle`.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    keys = {
      { "<leader>m", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render" },
    },
  },

  -- Trouble: unified list UI for diagnostics / references / symbols / quickfix
  -- / loclist. Grouped by file, live-previews as you move, auto-refreshes.
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (workspace)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP defs/refs" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Loclist" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
    },
  },
}
