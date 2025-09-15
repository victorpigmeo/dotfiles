return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'stevearc/conform.nvim',
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        'j-hui/fidget.nvim',
        'folke/neodev.nvim',
        'saghen/blink.cmp',
    },
    config = function()
        require('fidget').setup {}
        -- Neodev for neovim config
        require('neodev').setup {}

        -- Conform setup
        require('conform').setup {
            formatters_by_ft = {
                lua = { 'stylua', 'codespell' },
                typescript = { 'biome', 'codespell' },
                javascript = { 'biome', 'codespell' },
                typescriptreact = { 'biome', 'codespell' },
                javascriptreact = { 'biome', 'codespell' },
                json = { 'biome', 'codespell' },
                yaml = { 'yamlfmt', 'codespell' },
            },
           -- format_on_save = {
           --     timeout_ms = 500,
           --     lsp_format = 'fallback',
           -- },
        }

        --  This function gets run when an LSP connects to a particular buffer.
        local on_attach = function(client, bufnr)
            local nmap = function(keys, func, desc)
                if desc then
                    desc = 'LSP: ' .. desc
                end

                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true)
            end

            nmap('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
            nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

            nmap('<leader>cd', vim.lsp.buf.definition, '[G]oto [D]efinition')
            nmap(
                '<leader>cD',
                require('telescope.builtin').lsp_references,
                '[G]oto [R]eferences'
            )
            nmap(
                '<leader>cI',
                require('telescope.builtin').lsp_implementations,
                '[G]oto [I]mplementation'
            )
            -- See `:help K` for why this keymap
            nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

            vim.keymap.set({ 'v', 'n' }, '<leader>cf', function()
                vim.lsp.buf.format()
            end)
        end

        -- Mason setup
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
        require('mason').setup()
        require('mason-lspconfig').setup {
            ensure_installed = {
                'lua_ls',
                'rust_analyzer',
                'gopls',
                'ts_ls',
            },
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup {
                        capabilities = capabilities,
                        on_attach = on_attach,
                    }
                end,
            },
            automatic_installation = false,
        }
    end,
}
