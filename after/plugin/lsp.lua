local lsp_zero = require('lsp-zero')
local lspconfig = require"lspconfig"
local util = require("lspconfig/util")


lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)

lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})


lsp_zero.setup_servers({
	"eslint"
	,"tsserver"
	,"lua_ls"
	,"pyright"
	,"rust_analyzer"
	, "jdtls"
	, "gdscript"
	, "gopls"
	, "emmet"
	, "clangd"
	, "zls"
})


require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
	"lua_ls",
	"pyright",
	"rust_analyzer",
	"gopls",
  },
  handlers = {
    lsp_zero.default_setup,
  },
})

--Java Script
lspconfig.eslint.setup({
	root_dir = util.root_pattern("main.js"),
})

lspconfig.tsserver.setup({
	init_options = {
		preferences = {
			disableSuggestions = true,
		}
	}

})



-- Rust
lspconfig.rust_analyzer.setup({
	filetypes={"rust"},
	root_dir = util.root_pattern("Cargo.toml"),
	settings = {
		["rust-analyzer"]={
			allFeatures = true,
		},
	},
})

lspconfig.omnisharp.setup {
	cmd = {"dotnet", "/home/krzysztof/.local/share/omnisharp/omnisharp.dll"},
	enable_editorconfig_support = true,

    enable_ms_build_load_projects_on_demand = false,
    enable_roslyn_analyzers = false,
    organize_imports_on_format = false,
    enable_import_completion = true,
    analyze_open_documents_only = false,

}
lspconfig.jdtls.setup({

})



lspconfig.pyright.setup({
	filetypes={"python"}
})


lspconfig.gdscript.setup({
	filetypes={".gd"},
	root_dir = util.root_pattern(".godot"),
})

lspconfig.gopls.setup({
	filetypes={".go"},
	cmd={"/home/krzysztof/go/bin/gopls"},
	root_dir= util.root_pattern("main.go"),
	settings={
		gopls = {
			env={
				GOOS="js",
				GOARCH="wasm"
			}
		}
	}
})


lspconfig.clangd.setup({
	on_attatch = function (client, bufnr)
		client.server_capabilities.signatureHelpProvider = false
	end,
	cmd = { "clangd", "--compile-commands-dir=build" },
	root_dir = util.root_pattern("Makefile")
})


lspconfig.zls.setup({
	root_dir = util.root_pattern("build.zig")
})



