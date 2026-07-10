local function get_jdtls()
	-- Get the path to the jar that runs the language server
	local launcher = vim.fn.expand("$MASON/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
	-- Get the config path for the OS
	local config = vim.fn.expand("$MASON/packages/jdtls/config_linux")
	-- Get the lombok jar path
	local lombok = vim.fn.expand("$MASON/packages/jdtls/lombok.jar")

	return launcher, config, lombok
end

local function get_bundles()
	local bundles = {
		vim.fn.glob(
			vim.fn.expand("$MASON/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
		),
	}

	-- Add all jars for running tests in debug mode to the bundles list
	vim.list_extend(
		bundles,
		vim.split(vim.fn.glob(vim.fn.expand("$MASON/packages/java-test/extension/server/*.jar"), 1), "\n")
	)

	return bundles
end

local function get_workspace()
	-- Get the home directory
	local home = os.getenv("HOME")
	-- Declare a directory to store project information
	local workspace_path = home .. "/dev/javaWorkspaces/"
	-- Determine the project name
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	-- Create the workspace directory for a project
	local workspace_dir = workspace_path .. project_name

	return workspace_dir
end

local function java_keymaps()
	-- Allow to run JdtCompile (compile project) as Vim command
	vim.cmd(
		"command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
	)
	-- Allow to run JdtUpdateConfig as Vim command
	vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
	-- Allow to run JdtBytecode as Vim command
	vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
	-- Allow to run JdtShell as Vim command
	vim.cmd("command! -buffer JdtShell lua require('jdtls').jshell()")

	-- Set a vim motion to organize imports in normal mode
	vim.keymap.set("n", ",jo", "<Cmd> lua require('jdtls').organize_imports()<CR>", { desc = "Organize Imports" })
	-- Extract variable
	-- vim.keymap.set(
	-- 	"n",
	-- 	"<choose keys>",
	-- 	"<Cmd> lua require('jdtls').extract_variable()<CR>",
	-- 	{ desc = "Extract variable" }
	-- ) We can also use extract_constant!!

	-- Set a vim motion to test the method under the cursor
	vim.keymap.set("n", ",tt", "<Cmd> lua require('jdtls').test_nearest_method()<CR>", { desc = "Test method" })
	-- Set a vim motion to test the entire class
	vim.keymap.set("n", ",ta", "<Cmd> lua require('jdtls').test_class()<CR>", { desc = "Test the entire class" })
	-- Set a vim motion to update project config (Maven, Gradle...)
	vim.keymap.set("n", ",ju", "<Cmd> lua JdtUpdateConfig", { desc = "Update Config" })
end

local function setup_jdtls()
	-- Get access to the jdtls plugin
	local jdtls = require("jdtls")

	-- Get paths to the jdtls jar, os config and lombok jar
	local launcher, os_config, lombok = get_jdtls()

	-- Get project workspace dir
	local workspace_dir = get_workspace()

	-- Get bundles
	local bundles = get_bundles()

	-- Determine the root directory of the project
	local root_dir = jdtls.setup.find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })

	-- Tell jdtls which features it is capable of
	local capabilities = {
		workspace = {
			configuration = true,
		},
		textDocument = {
			completion = {
				snippetSupport = false,
			},
		},
	}

	-- Get the default extended client capabilities
	local extendedClientCapabilities = jdtls.extendedClientCapabilities
	-- Modify the resolveAdditionalTextEditsSupport
	extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

	-- Set the command that starts JDTLS
	local cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLeve=4",
		"-Declipse.product=org.eclipse.jfdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. lombok,
		"-jar",
		launcher,
		"-configuration",
		os_config,
		"-data",
		workspace_dir,
	}

	local settings = {
		java = {
			-- Enable code format
			format = {
				enabled = true,
				-- Use Google style guide for code formatting
				settings = {
					url = vim.fn.stdpath("config") .. "lang_servers/intellij-java-google-style.xml",
					profile = "GoogleStyle",
				},
			},
			-- Download sources automatically from eclipse
			eclipse = {
				downloadSources = true,
			},
			-- Download sources automatically from maven
			maven = {
				downloadSources = true,
			},
			-- Enable method signature help
			signatureHelp = { enabled = true },
			-- Use the fernflower decompiler when using javap command
			contentProvider = {
				preferred = "fernflower",
			},
			-- Organize imports when saving
			saveOptions = {
				organizeImports = true,
			},
			-- Customize completion options
			completion = {
				-- When using an unimported static method, how should the lsp rank possible places to import from
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAsser.assertThat",
					"org.hamcrest.Mathers.*",
					"org.hamcrest.CoreMathers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				-- Try not suggest imports from these packages in the code action window
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
				-- Set the order in which the language server should organize imports
				importOrder = {
					"java",
					"jakarta",
					"javax",
					"com",
					"org",
				},
			},
			sources = {
				-- How many classes from a specific package should be imported before automatic imports combine them all into a single import
				organizeImports = {
					starThreshold = 9999,
					staticThreshold = 9999,
				},
			},
			-- How should different pieces of code be generated?
			codeGeneration = {
				-- When generating toString use a json format
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
				-- When generating equals and hashCode use the java 7 objects method
				hashCodeEquals = {
					useJava7Objects = true,
				},
				-- When generating code use code blocks
				useBlocks = true,
			},
			-- If changes to the project require update the configuration advise before accepting the changes
			configuration = {
				updateBuildConfiguration = "interactive",
			},
			-- Enable code lens
			referencesCodeLens = {
				enabled = true,
			},
			-- Enable inlay hints (Hover hints)
			inlayHints = {
				parameterNames = {
					enabled = "all",
				},
			},
		},
	}

	-- Create a table to pass the bundles with debug and testing jar, along with extendedClientCapabilities to the attach function of JDTLS
	local init_options = {
		bundles = bundles,
		extendedClientCapabilities = extendedClientCapabilities,
	}

	-- Function that will be ran once the language server is attached
	local on_attach = function(_, bufnr)
		-- Map the key bindings
		java_keymaps()

		-- Setup the java debug adapter of the JDTLS
		require("jdtls.dap").setup_dap()
		require("jdtls.dap").setup_dap_main_class_configs()

		-- Enable jdtls commands
		require("jdtls_setup").add_commands()

		--Refresh the codelens
		vim.lsp.codelens.refresh()

		-- Create a function that automatically runs every time a java file is saved to refresh codelens
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.java" },
			callback = function()
				local _, _ = pcall(vim.lsp.codelens.refresh)
			end,
		})
	end

	-- Create the configuration table for the start and on_attach
	local config = {
		cmd = cmd,
		root_dir = root_dir,
		settings = settings,
		init_options = init_options,
		capabilities = capabilities,
		on_attach = on_attach,
	}

	--Start JDTLS server
	require("jdtls").start_or_attach(config)
end

return {
	setup_jdtls = setup_jdtls,
}
