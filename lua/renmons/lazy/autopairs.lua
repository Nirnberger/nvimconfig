return {
	"windwp/nvim-autopairs",
	event = "VeryLazy", -- load before cmp, same reason as before
	opts = {
		check_ts = true, -- use treesitter to check where the cursor is
		-- no auto-pairing while the cursor is inside these node types
		ts_config = {
			lua = { "string", "string_content" },
			python = { "string", "string_content" },
			javascript = { "string", "string_fragment", "template_string" },
			typescript = { "string", "string_fragment", "template_string" },
			tsx = { "string", "string_fragment", "template_string" },
		},
		-- off entirely in prose files (replaces the old autocmd)
		disable_filetype = { "TelescopePrompt", "markdown", "text", "tex", "gitcommit" },
	},
}
