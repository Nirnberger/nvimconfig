return {
	{
		"mason-org/mason.nvim",
		build = ":MasonUpdate",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {}, -- mason itself has no ensure_installed
	},

	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				"stylua",
				"shfmt",
				"ruff",
				"prettierd",
				"lua_ls",
				"pyright",
				"ts_ls",
				"rust_analyzer",
				"clangd",
				"graphql",
			},
			automatic_enable = false, -- lsp.lua already calls vim.lsp.enable()
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = { "stylua", "shfmt" },
			run_on_start = true,
		},
	},
}
