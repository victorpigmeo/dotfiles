-- nvim-treesitter (main branch): required for Neovim 0.12 (the master branch is
-- archived and unsupported on 0.11+). The main branch only manages parsers;
-- highlighting is native via vim.treesitter.start(), wired per-buffer on
-- FileType. Indentation uses the plugin's indentexpr.
local ensure = {
  "java",
  "kotlin", -- .kt / .kts (also build.gradle.kts)
  "lua",
  "markdown",
  "markdown_inline",
  "vim",
  "vimdoc",
  -- build tooling
  "groovy", -- build.gradle
  "toml", -- libs.versions.toml, *.toml
  -- web / Next.js
  "typescript",
  "tsx",
  "javascript",
  "json",
  "css",
  "html",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- install/update the parsers we use (async, no-op once present)
    require("nvim-treesitter").install(ensure)

    vim.api.nvim_create_autocmd("FileType", {
      desc = "Enable treesitter highlight + indent when a parser is available",
      callback = function(ev)
        local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
        if not lang or not pcall(vim.treesitter.language.add, lang) then
          return -- no parser for this filetype: leave built-in syntax alone
        end
        pcall(vim.treesitter.start, ev.buf, lang)
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
