return {
	"hrsh7th/nvim-cmp",
	version = false,
	event = { "InsertEnter", "CmdlineEnter" }, -- cmdline completion works immediately
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-vsnip", -- the missing bridge between vsnip and cmp
		"hrsh7th/vim-vsnip",
	},
	config = function()
		local cmp = require("cmp")

		local function feedkey(key)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), "", true)
		end

		cmp.setup({
			snippet = {
				expand = function(args)
					vim.fn["vsnip#anonymous"](args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-k>"] = cmp.mapping.select_prev_item(),

				-- Tab: next menu item, otherwise expand/jump snippet, otherwise normal Tab
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif vim.fn["vsnip#available"](1) == 1 then
						feedkey("<Plug>(vsnip-expand-or-jump)")
					else
						fallback()
					end
				end, { "i", "s" }),

				-- Shift-Tab: previous menu item, otherwise jump back in snippet
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif vim.fn["vsnip#jumpable"](-1) == 1 then
						feedkey("<Plug>(vsnip-jump-prev)")
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "lazydev", group_index = 0 },
				{ name = "nvim_lsp" },
				{ name = "vsnip" },
			}, {
				{ name = "buffer" },
				{ name = "path" },
			}),
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = { { name = "buffer" } },
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
			matching = { disallow_symbol_nonprefix_matching = false },
		})
	end,
}
