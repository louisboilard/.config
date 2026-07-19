-- Native LSP (Neovim 0.11+ vim.lsp.config / vim.lsp.enable) + Mason for
-- auto-installing every server. Completion capabilities come from blink.cmp;
-- inlay hints and rust_analyzer's own features are used natively.
return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", build = ":MasonUpdate", config = true },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      -- Servers installed & enabled out of the box.
      local servers = {
        -- Languages
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "ts_ls", -- typescript + javascript
        "eslint",
        "pyright", -- python
        "ruff",
        "clangd", -- c / c++
        "bashls", -- shell
        "vimls", -- vimscript
        -- Web / markup
        "html",
        "cssls",
        -- Config & data formats
        "jsonls",
        "yamlls",
        "taplo", -- toml
        "dockerls",
        "terraformls",
        "marksman", -- markdown
      }

      require("mason").setup()

      -- Everything installs automatically on launch. Manually: `:Mason` (UI),
      -- `:MasonToolsInstall` (formatters + linters below), `:MasonInstall <pkg>`.
      -- Auto-install formatters used by conform + linters used by nvim-lint (LSP
      -- servers are handled by mason-lspconfig below). rustfmt/gofmt come with
      -- their toolchains.
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua", "prettierd", "goimports", "shfmt", -- formatters (conform)
          "shellcheck", "markdownlint", "hadolint", -- linters (nvim-lint)
        },
        run_on_start = true,
      })

      -- Global defaults applied to every server (registered BEFORE enabling).
      -- blink.cmp supplies the completion capabilities.
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = capabilities })

      -- Per-server overrides
      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
          },
        },
      })
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      -- mason-lspconfig 2.0: installs the servers and auto-runs vim.lsp.enable()
      -- for each (automatic_enable defaults to true).
      require("mason-lspconfig").setup({
        ensure_installed = servers,
        automatic_enable = true,
      })

      -- ---- Diagnostics (modern vim.diagnostic.config; no sign_define) --------
      vim.diagnostic.config({
        virtual_text = false,
        -- Native 0.11+ inline multi-line diagnostics, current line only (no
        -- plugin needed). The float on [d/]d still shows the full message.
        virtual_lines = { current_line = true },
        underline = true,
        update_in_insert = false, -- avoids diagnostics lag while typing
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
        float = {
          focusable = false,
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
      })

      -- Rounded borders for hover / signature help (replaces the deprecated
      -- vim.lsp.with(vim.lsp.handlers...) approach)
      vim.o.winborder = "rounded"

      -- ---- Buffer-local LSP keymaps ----------------------------------------
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local b = function(desc)
            return { buffer = bufnr, silent = true, desc = desc }
          end

          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, b("Go to declaration"))
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, b("Go to definition"))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, b("Hover"))
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, b("Signature help"))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, b("Rename"))
          vim.keymap.set("n", "ga", vim.lsp.buf.code_action, b("Code action"))
          -- References on grr (matches Neovim 0.11's native gr* scheme; the
          -- built-in grr uses the quickfix list, this overrides it with the
          -- nicer Telescope picker). gri (implementation) and gO (document
          -- symbols) remain the native 0.11 defaults.
          vim.keymap.set("n", "grr", "<cmd>Telescope lsp_references theme=get_ivy<cr>", b("References"))
          vim.keymap.set("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols theme=get_ivy<cr>", b("Document symbols"))
          vim.keymap.set("n", "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols theme=get_ivy<cr>", b("Workspace symbols"))
          -- <leader>f is owned by conform.nvim (see plugins/format.lua)
          vim.keymap.set("n", "[d", function()
            vim.diagnostic.jump({ count = -1, float = true })
          end, b("Prev diagnostic"))
          vim.keymap.set("n", "]d", function()
            vim.diagnostic.jump({ count = 1, float = true })
          end, b("Next diagnostic"))
          vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, b("Diagnostics to loclist"))

          -- (Completion is handled by blink.cmp, not native vim.lsp.completion.)

          -- Inlay hints (native; e.g. rust type hints)
          if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
          end

          -- Document highlight: underline other uses of the symbol under the
          -- cursor on CursorHold, cleared on CursorMoved.
          if client and client:supports_method("textDocument/documentHighlight") then
            local grp = vim.api.nvim_create_augroup("user_lsp_doc_hl_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd("CursorHold", {
              buffer = bufnr,
              group = grp,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
              buffer = bufnr,
              group = grp,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })

      vim.api.nvim_create_user_command("Format", function()
        require("conform").format({ lsp_format = "fallback" })
      end, {})
    end,
  },
}
