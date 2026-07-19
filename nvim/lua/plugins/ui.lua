-- Colorscheme. Your own theme (pyramid.nvim). Custom highlights and
-- transparency are applied in config/autocmds.lua on the ColorScheme event.
return {
  {
    "louisboilard/pyramid.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("pyramid")
    end,
  },

  -- Top line: filename per tab + green modified dot (`●`).
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("bufferline").setup({
        options = {
          mode = "tabs", -- one entry per tabpage (shows the current file name)
          buffer_close_icon = "",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
        },
      })
    end,
  },
}
