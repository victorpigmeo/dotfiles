-- TypeScript / JavaScript LSP, tuned for Next.js. All of TS's LSP config lives
-- here (kept out of lsp.lua and jdtls.lua):
--   ts_ls        TypeScript/JavaScript, incl. .tsx / .jsx (Next.js pages)
--   eslint       linting + fixes (Next projects ship an eslint config)
--   tailwindcss  Tailwind class completion/hover (attaches only when a Tailwind
--                config is present, so it is inert on non-Tailwind projects)
-- mason installs them and mason-lspconfig auto-enables them (see lsp.lua); the
-- shared blink capabilities and SPC c keymaps apply. `SPC c f` formats via the
-- LSP fallback (ts_ls / eslint). Treesitter web parsers come from treesitter.lua.
return {
  {
    -- opts function that inits then extends in place (lazy replaces list-valued
    -- table opts and runs fragments in filename order, so init defensively).
    "williamboman/mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "ts_ls", "eslint", "tailwindcss" })
    end,
  },
  {
    -- Auto-close and auto-rename JSX/TSX/HTML tags (treesitter-driven).
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    opts = {},
  },
}
