local status_ok, mason_lspconf = pcall(require, "mason-lspconfig")
if not status_ok then
	return
end

mason_lspconf.setup_handlers {
    -- Automatically starts the any lsp servers with default config setup
    function (server_name)
        -- use our config
        local opts = {
            on_attach = require("user.lsp.handlers").on_attach,
            capabilities = require("user.lsp.handlers").capabilities,
        }
            require("lspconfig")[server_name].setup(opts)
        end,

        -- Can provide a dedicated handler for specific servers.
        -- For example, a handler override for the `rust_analyzer`:
        -- ["rust_analyzer"] = function ()
        --     require("rust-tools").setup {}
        -- end
}
