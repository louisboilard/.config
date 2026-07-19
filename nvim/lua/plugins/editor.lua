-- Small editing plugins. Commenting (gc/gcc) uses the Neovim built-in.
return {
  -- File explorer (opened with <leader>e)
  {
    "stevearc/oil.nvim",
    cmd = "Oil",
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Git signs + hunk navigation. Powers the git-review workflow in
  -- config/review.lua; preview_config gives the word-diff float a rounded,
  -- cursor-anchored look.
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      preview_config = {
        border = "rounded",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },
    },
  },

  -- Surround: ys / ds / cs
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },

  -- Leap: s / S / gs motions  (repo moved from GitHub to Codeberg)
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    event = "VeryLazy",
    config = function()
      require("leap").add_default_mappings()
    end,
  },

  -- quick-scope: highlight f/F/t/T targets
  {
    "unblevable/quick-scope",
    event = "VeryLazy",
    init = function()
      vim.g.qs_highlight_on_keys = { "f", "F", "t", "T" }
    end,
  },

  -- Smooth scrolling for <C-d>/<C-u>/<C-b>/<C-f>
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = true,
  },

  -- Harpoon: mf to mark, mm for the menu
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = { "mf", "mm" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      vim.keymap.set("n", "mf", function()
        harpoon:list():add()
      end, { desc = "Harpoon add file" })
      vim.keymap.set("n", "mm", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon menu" })
    end,
  },

  -- Auto-close brackets/quotes + fast-wrap on <C-l>.
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
        ts_config = {
          lua = { "string", "source" },
          javascript = { "string", "template_string" },
          java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
          map = "<C-l>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          offset = 0,
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "PmenuSel",
          highlight_grey = "LineNr",
        },
      })
    end,
  },

  -- Sticky context header (function/class/if you're inside) while scrolling.
  -- Modern treesitter-context: `patterns`/`exact_patterns` were removed (it
  -- uses queries now), so only the still-valid options are kept.
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      max_lines = 0,
      trim_scope = "outer",
      mode = "cursor",
    },
  },

  -- Inline highlight of color codes (#ff0000, rgb(), etc.) -- maintained fork.
  {
    "catgoose/nvim-colorizer.lua",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("colorizer").setup()
    end,
  },
}
