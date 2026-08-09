-- Completion menu. blink.cmp renders the popup; the LSP (jdtls for Java, etc.)
-- supplies the items. In insert mode Ctrl+Space opens the menu, C-n/C-p move,
-- Enter accepts. Capabilities are registered with the LSP in lsp.lua.
return {
  "saghen/blink.cmp",
  version = "1.*", -- released tag ships the prebuilt fuzzy-matcher binary
  event = "InsertEnter",
  opts = {
    keymap = {
      preset = "default", -- <C-space> shows menu/docs; <C-n>/<C-p> navigate
      ["<Tab>"] = { "accept", "fallback" }, -- Tab applies the selection
      ["<CR>"] = { "fallback" }, -- Enter never accepts: closes menu + new line
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    completion = {
      menu = { auto_show_delay_ms = 500 }, -- wait 500ms before auto-opening menu
      documentation = { auto_show = true },
    },
  },
}
