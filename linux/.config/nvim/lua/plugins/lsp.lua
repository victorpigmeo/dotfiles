-- LSP core (language-agnostic). mason installs servers, mason-lspconfig
-- auto-enables the installed ones, blink's completion capabilities are
-- advertised to every server, and the SPC c keymaps bind per-buffer on attach.
--
-- Language-specific setup lives in its own file, not here:
--   Java       -> jdtls.lua      (nvim-jdtls; adds jdtls to mason, excludes it
--                                  from auto-enable since nvim-jdtls starts it)
--   TypeScript -> typescript.lua (ts_ls / eslint / tailwindcss for Next.js)
-- Those files append their servers via opts FUNCTIONS that extend the lists in
-- place (lazy REPLACES list-valued table opts on merge and runs fragments in
-- filename order, so a base list here would be clobbered -- the language files
-- own and initialise the lists defensively instead).
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
    opts = {}, -- ensure_installed / automatic_enable come from the language files
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
          m("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          -- SPC c f (format) is a global keymap in conform.lua so it works even
          -- without an LSP attached.
        end,
      })
    end,
  },
}
