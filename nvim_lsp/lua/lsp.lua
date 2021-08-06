-- lsp setup
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    signs = false, --side symbols (E, W by default)
    underline = true, -- line under the faulty code.
    update_in_insert = false, -- update when typing.
    virtual_text = { -- the text that displays the diagnostic
        spacing = 2,
        prefix = '✞',
        severity_limit = "Warning"
    }
    -- virtual_text = false,
  }
)

-- LspSage plugin config. A config layer for lsp.
local saga = require 'lspsaga'
saga.init_lsp_saga {
  use_saga_diagnostic_sign = false, -- usure about that one.
  border_style = "plus",
  max_preview_lines = 60,
  finder_definition_icon = '🔥 ',
  finder_reference_icon =  '🔥 ',
  code_action_keys = { quit = 'q', exec = '<CR>' },
  finder_action_keys = { open = '<CR>', vsplit = 'v',split = 's',quit = 'q',scroll_down = '<C-f>', scroll_up = '<C-b>' },
  rename_prompt_prefix = '➤',
  code_action_prompt = {
    enable = false,
    sign = false,
    sign_priority = 20,
    virtual_text = false,
  },
}

-- symbols for autocomplete
vim.lsp.protocol.CompletionItemKind = {
    " 🔥  (Text) ",
    " 🔥  (Method)",
    " 🔥  (Function)",
    " 🔥  (Constructor)",
    " 🔥  (Field)",
    " 🔥  (Variable)",
    " 🔥  (Class)",
    " 🔥  (Interface)",
    " 🔥  (Module)",
    " 🔥  (Property)",
    " 🔥  (Unit)",
    " 🔥  (Value)",
    " 🔥  (Enum)",
    " 🔥  (Keyword)",
    " 🔥  (Snippet)",
    " 🔥  (Color)",
    " 🔥  (File)",
    " 🔥  (Reference)",
    " 🔥  (Folder)",
    " 🔥  (EnumMember)",
    " 🔥  (Constant)",
    " 🔥  (Struct)",
    " 🔥  (Event)",
    " 🔥  (Operator)",
    " 🔥  (TypeParameter)"
}

local function documentHighlight(client, bufnr)
    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec(
            [[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceText cterm=bold ctermbg=red guibg=#464646
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#464646
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]],
            false
        )
    end
end

local lsp_config = {}

function lsp_config.common_on_attach(client, bufnr)
    documentHighlight(client, bufnr)
end
function lsp_config.tsserver_on_attach(client, bufnr)
    lsp_config.common_on_attach(client, bufnr)
    client.resolved_capabilities.document_formatting = false
end

local function setup_servers()
  require'lspinstall'.setup()
  local servers = require'lspinstall'.installed_servers()
  for _, server in pairs(servers) do
    require'lspconfig'[server].setup{}
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
require'lspinstall'.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
