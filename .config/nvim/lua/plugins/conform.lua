return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua", "codespell" },
				typescript = { "biome", "codespell" },
				javascript = { "biome", "codespell" },
				typescriptreact = { "biome", "codespell" },
				javascriptreact = { "biome", "codespell" },
				json = { "biome", "codespell" },
			},
			format_on_save = {
				timeout_ms = 100,
				lsp_format = "fallback",
			},
		})
	end,
}
