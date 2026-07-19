-- blink.cmp: completion. Triggers as you type, fuzzy matching, signature help,
-- native vim.snippet integration. Ships a prebuilt fuzzy binary on tagged
-- versions, so no build step needed.
return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    event = "InsertEnter",
    opts = {
      keymap = {
        -- <CR> accepts, Tab moves through the menu / jumps snippet
        -- placeholders, C-Space toggles, C-n/C-p also select.
        preset = "enter",
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
      completion = {
        -- Calm behavior:
        --  * don't preselect or auto-insert text into the buffer as you type
        --  * no ghost text, no docs window popping open on its own
        list = { selection = { preselect = false, auto_insert = false } },
        menu = { auto_show = true },
        documentation = { auto_show = false }, -- press <C-space> or navigate to view
        ghost_text = { enabled = false },
      },
      signature = { enabled = true },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}
