local lsp = require('lsp-zero').preset({})
lsp.ensure_installed = ({'lua_ls', 'clangd'})
lsp.on_attach(function(client, bufnr)
lsp.default_keymaps({buffer = bufnr})
end)

lsp.setup_servers({'lua_ls', 'clangd'})

lsp.setup()
