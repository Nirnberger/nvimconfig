return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = { "NvimTreeToggle", "NvimTreeFocus", "NvimTreeFindFile" },
	keys = {
		-- like CHADopen --always-focus: open, focus, reveal current file
		{ "<leader>e", "<cmd>NvimTreeFindFile<CR>", desc = "Focus file in tree" },
		-- like CHADopen: toggle the tree
		{ "<leader>nt", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file tree" },
	},
	opts = {
		view = { width = 30 },
		sort = { sorter = "name", folders_first = true },
		update_focused_file = { enable = true }, -- was chadtree `follow`
		git = { enable = true },
		filters = {
			dotfiles = true, -- toggle with H inside the tree
			-- vim regex, not globs
			custom = {
				"^\\.git$",
				"^node_modules$",
				"^dist$",
				"^target$",
				"^\\.DS_Store$",
				"\\.log$",
				"\\.tmp$",
				"\\.swp$",
				"^__pycache__$",
				"^\\.cache$",
			},
		},
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")
			api.config.mappings.default_on_attach(bufnr)
			-- nvim-tree maps <C-k> to "file info"; give it back to window navigation
			vim.keymap.del("n", "<C-k>", { buffer = bufnr })
		end,
	},
	config = function(_, opts)
		require("nvim-tree").setup(opts)

		-- Auto-quit Neovim if the tree is the only remaining window
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("NvimTreeCloseIfLast", { clear = true }),
			nested = true,
			callback = function()
				if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == "NvimTree" then
					vim.cmd("quit")
				end
			end,
		})
	end,
}
