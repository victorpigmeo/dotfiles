return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-mini/mini.icons",
	},
	config = function()
		require("mini.icons").setup()

		require("mini.icons").mock_nvim_web_devicons()

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "ayu_dark",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff" },
				lualine_c = { "filename" },
				lualine_x = {
					{
						"diagnostics",
						always_visible = true,
					},
					-- "encoding",
					"fileformat",
					"filetype",
				},
				lualine_y = { "lsp_status" },
			},
		})
	end,
}
