require("config")

vim.lsp.enable({
	--Lua
	"lua_ls",
	--Javascript
	"ts_ls",
	--Protobuf
	"protols",
	--Dart
	"dartls",
})

-- Require autocmds
require("config.autocmds")

vim.lsp.enable("kotlin_lsp")
