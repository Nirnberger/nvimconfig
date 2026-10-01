-- lua/renmons/keymaps.lua

local map = vim.keymap.set

-- Better defaults
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Blank-line dd goes to void register
map("n", "dd", function()
	if vim.api.nvim_get_current_line():match("^%s*$") then
		return '"_dd'
	end
	return "dd"
end, { expr = true, desc = "Delete line smartly" })

-- Keep selection while indenting
map("v", "<", "<gv", { desc = "Indent left and reselect" })
map("v", ">", ">gv", { desc = "Indent right and reselect" })

-- Move selected lines
map("v", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })

-- Better scrolling
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up centered" })

-- Window movement
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Window splits
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Tabs
map("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
map("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Next tab" })
map("n", "<leader>tp", "<cmd>tabprevious<CR>", { desc = "Previous tab" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Buffers
map("n", "<leader>bn", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Safer buffer delete: deletes buffer but tries not to destroy window layout
-- Safer buffer delete: keeps window layout, skips special buffers, asks about unsaved changes
map("n", "<leader>bd", function()
	local buf = vim.api.nvim_get_current_buf()

	-- nvim-tree, help, quickfix, ... are not file buffers
	if not vim.bo[buf].buflisted or vim.bo[buf].buftype ~= "" then
		vim.notify("Not a file buffer, nothing to delete", vim.log.levels.WARN)
		return
	end

	if vim.bo[buf].modified then
		local choice = vim.fn.confirm(
			"Save changes to " .. vim.fn.fnamemodify(vim.fn.bufname(buf), ":t") .. "?",
			"&Yes\n&No\n&Cancel"
		)
		if choice == 1 then
			vim.cmd.write()
		elseif choice ~= 2 then
			return -- Cancel or <Esc>
		end
	end

	-- In every window showing this buffer, switch to another buffer first
	for _, win in ipairs(vim.fn.win_findbuf(buf)) do
		vim.api.nvim_win_call(win, function()
			local alt = vim.fn.bufnr("#")
			if alt ~= -1 and alt ~= buf and vim.fn.buflisted(alt) == 1 then
				vim.cmd.buffer(alt)
			else
				vim.cmd("bprevious")
				if vim.api.nvim_get_current_buf() == buf then
					vim.cmd.enew() -- it was the last buffer
				end
			end
		end)
	end

	pcall(vim.cmd, "bdelete! " .. buf)
end, { desc = "Delete buffer" })

-- Search highlight
map("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files theme=dropdown<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Buffers" })

-- Today
map("n", "<leader>tt", "<cmd>Today<CR>", { desc = "Open today's note" })

-- UI toggles
map("n", "<leader>uw", function()
	vim.wo.wrap = not vim.wo.wrap
	vim.notify("Line wrap " .. (vim.wo.wrap and "enabled" or "disabled"))
end, { desc = "Toggle line wrap" })

map("n", "<leader>uc", function()
	if vim.o.conceallevel == 0 then
		vim.o.conceallevel = 2
		vim.notify("Conceal enabled")
	else
		vim.o.conceallevel = 0
		vim.notify("Conceal disabled")
	end
end, { desc = "Toggle conceal" })

map("n", "<leader>uh", function()
	if not vim.lsp.inlay_hint then
		vim.notify("Inlay hints are not supported by this Neovim version", vim.log.levels.WARN)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })

	vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end, { desc = "Toggle inlay hints" })

-- VimTeX / quickfix
map("n", "<leader>v>", "<cmd>cnext<CR>", { desc = "Next VimTeX warning/error" })
map("n", "<leader>v<", "<cmd>cprev<CR>", { desc = "Previous VimTeX warning/error" })

map("n", "<leader>us", function()
	vim.opt_local.spell = not vim.opt_local.spell:get()
	vim.notify("Spell check " .. (vim.opt_local.spell:get() and "enabled" or "disabled"))
end, { desc = "Toggle spell check" })

-- Spell checking
map("n", "<leader>zn", "]szz", { desc = "Next spelling mistake" })
map("n", "<leader>zp", "[szz", { desc = "Previous spelling mistake" })
map("n", "<leader>zs", "z=", { desc = "Show spelling suggestions" })
map("n", "<leader>zg", "zg", { desc = "Add word to dictionary" })
map("n", "<leader>zw", "zw", { desc = "Mark word as wrong" })

local function replace_current_word(new_word)
	local word = vim.fn.expand("<cword>")
	if word == "" then
		return
	end

	local row, col = unpack(vim.api.nvim_win_get_cursor(0))
	local line = vim.api.nvim_get_current_line()
	local cursor = col + 1 -- string positions are 1-based

	-- find the occurrence of <cword> that contains (or follows) the cursor
	local start = 1
	while true do
		local s, e = line:find(word, start, true) -- plain find, no patterns
		if not s then
			return
		end
		if e >= cursor then
			vim.api.nvim_buf_set_text(0, row - 1, s - 1, row - 1, e, { new_word })
			return
		end
		start = e + 1
	end
end

local function get_spelling_context(radius)
	radius = radius or 50

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]
	local col = cursor[2]

	local line = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1] or ""

	-- col ist 0-basiert, string.sub dagegen 1-basiert
	local cursor_col = col + 1

	local start_col = math.max(1, cursor_col - radius)
	local end_col = math.min(#line, cursor_col + radius)

	local context = line:sub(start_col, end_col)

	if start_col > 1 then
		context = "…" .. context
	end

	if end_col < #line then
		context = context .. "…"
	end

	return context
end

local function fix_next_spelling_mistake()
	local before = vim.api.nvim_win_get_cursor(0)

	vim.cmd("silent! normal! ]s")

	local after = vim.api.nvim_win_get_cursor(0)

	if before[1] == after[1] and before[2] == after[2] then
		vim.notify("No more spelling mistakes")
		return
	end

	local word = vim.fn.expand("<cword>")
	local bad = vim.fn.spellbadword(word)

	if bad[1] == "" then
		vim.notify("No spelling mistake under cursor")
		return
	end

	local suggestions = vim.fn.spellsuggest(word, 10)

	table.insert(suggestions, "✍ Custom correction...")
	table.insert(suggestions, "✓ Add word as correct")
	table.insert(suggestions, "⏭ Skip word")

	local context = get_spelling_context(20)

	vim.ui.select(suggestions, {
		prompt = string.format("Context: %s\n", context),
	}, function(choice)
		if not choice then
			return
		end

		if choice == "✍ Custom correction..." then
			vim.ui.input({
				prompt = "Correction for '" .. word .. "': ",
				default = word,
			}, function(input)
				if not input or input == "" then
					return
				end

				replace_current_word(input)
				vim.schedule(fix_next_spelling_mistake)
			end)

			return
		end

		if choice == "✓ Add word as correct" then
			vim.cmd("normal! zg")
			vim.schedule(fix_next_spelling_mistake)
			return
		end

		if choice == "⏭ Skip word" then
			vim.schedule(fix_next_spelling_mistake)
			return
		end

		replace_current_word(choice)
		vim.schedule(fix_next_spelling_mistake)
	end)
end

map("n", "<leader>zz", fix_next_spelling_mistake, {
	desc = "Fix next spelling mistake",
})

local function move_down()
	if vim.v.count == 0 and vim.wo.wrap then
		return "gj"
	end
	return "j"
end

local function move_up()
	if vim.v.count == 0 and vim.wo.wrap then
		return "gk"
	end
	return "k"
end

vim.keymap.set({ "n", "x" }, "j", move_down, {
	expr = true,
	silent = true,
	desc = "Move down visual line if wrap is on",
})

vim.keymap.set({ "n", "x" }, "k", move_up, {
	expr = true,
	silent = true,
	desc = "Move up visual line if wrap is on",
})

map("n", "<leader>ud", function()
	if vim.diagnostic.config().virtual_lines then
		-- back to short messages at the end of the line
		vim.diagnostic.config({
			virtual_lines = false,
			virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
		})
		vim.notify("Diagnostics: inline")
	else
		vim.diagnostic.config({
			virtual_lines = { current_line = true },
			virtual_text = false,
		})
		vim.notify("Diagnostics: lines below")
	end
end, { desc = "Toggle diagnostic display" })
