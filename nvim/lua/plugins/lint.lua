-- nvim-lint: linters that aren't provided by an LSP. Complements conform
-- (formatting) and the LSP diagnostics. Runs on read, save, and leaving insert.
return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        markdown = { "markdownlint" },
        dockerfile = { "hadolint" },
      }

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("user_nvim_lint", { clear = true }),
        callback = function()
          -- No-op for filetypes without a configured linter.
          require("lint").try_lint()
        end,
      })
    end,
  },
}
