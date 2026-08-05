-- LSP: mason installs language servers, nvim-lspconfig provides their configs.
-- Java (jdtls) is driven by nvim-jdtls (see jdtls.lua) for a per-project
-- workspace and the full code-action set, so it is excluded from
-- mason-lspconfig's auto-enable here to avoid a double start. Any other server
-- auto-enables. SPC c keymaps bind per-buffer on LspAttach for every LSP.
return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = { "jdtls" }, -- still install the binary; nvim-jdtls runs it
      automatic_enable = { exclude = { "jdtls" } }, -- jdtls is started by nvim-jdtls
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)

      -- Advertise blink.cmp's completion capabilities to every server so the
      -- LSP returns snippets and resolvable detail. Applied before servers
      -- attach (BufReadPre), which is why it lives here, not in blink's spec.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP buffer-local keymaps",
        callback = function(ev)
          local function m(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, desc = desc })
          end
          m("<leader>cd", vim.lsp.buf.definition, "Go to definition")
          m("<leader>cD", "<cmd>Telescope lsp_references<CR>", "Find usages")
          m("<leader>ca", vim.lsp.buf.code_action, "Code action")
          m("<leader>cf", function()
            -- Java -> Spotless (conform); other filetypes fall back to the LSP.
            require("conform").format({ async = true, lsp_format = "fallback" })
          end, "Format buffer")
        end,
      })
    end,
  },
}
