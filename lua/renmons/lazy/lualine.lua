return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = "VeryLazy",
	opts = function()
		-- Tokyonight's lualine theme, with normal mode orange to match your cursor
		local theme = require("lualine.themes.tokyonight")
		theme.normal.a.bg = "#ff9e64"
		theme.normal.b.fg = "#ff9e64"

		-- Names of the LSP servers attached to the current buffer
		local function lsp_clients()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then
				return ""
			end
			local names = {}
			for _, client in ipairs(clients) do
				table.insert(names, client.name)
			end
			return " " .. table.concat(names, ", ")
		end

		return {
			options = {
				theme = theme,
				globalstatus = true, -- one statusline for all splits
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } }, -- path relative to project
				lualine_x = { lsp_clients, "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			extensions = { "nvim-tree", "lazy", "quickfix" },
		}
	end,
}
