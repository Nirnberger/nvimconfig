local wk = require("which-key")

wk.add({
  -- CHADTree: always focus, never toggle closed
  {
    "<leader>e",
    function()
      vim.cmd("CHADopen --always-focus")
    end,
    desc = "Open CHADTree and focus",
    mode = "n",
  },
  {
    "<leader>nt",
    function()
      vim.cmd("CHADopen")
    end,
    desc = "Open CHADTree and focus",
    mode = "n",
  },

  -- your Today mapping
  {
    "<leader>tt",
    ":Today<CR>",
    desc = "Open today's note",
    mode = "n",
  },

  -- Telescope
  {
    "<leader>ff",
    function()
      require("telescope.builtin").find_files(
        require("telescope.themes").get_dropdown({ winblend = 10 })
      )
    end,
    desc = "Find files (dropdown)",
    mode = "n",
  },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", mode = "n",                             desc = "Live grep" },
  { "<leader>fb", "<cmd>Telescope buffers<cr>",   mode = "n",                             desc = "Buffers" },

  -- LSP code action
  { "<leader>ca", vim.lsp.buf.code_action,        desc = "Code Action",                   mode = "n" },
  { "<leader>bx", ":bdelete<CR>",                 desc = "Delete buffer",                 mode = "n" },
  { "<leader>bn", ":bnext<CR>",                   desc = "Next buffer",                   mode = "n" },
  { "<leader>bp", ":bprevious<CR>",               desc = "Previous buffer",               mode = "n" },
  { "<leader>nh", ":nohl<CR>",                    desc = "Clear highlight",               mode = "n" },


  { "<leader>sv", "<C-w>v",                       desc = "Split window vertically" },
  { "<leader>sh", "<C-w>s",                       desc = "Split window horizontally" },
  { "<leader>se", "<C-w>=",                       desc = "Make splits equal size" },
  { "<leader>sx", "<cmd>close<CR>",               desc = "Close current split" },
  { "<leader>to", "<cmd>tabnew<CR>",              desc = "Open new tab" },
  { "<leader>tx", "<cmd>tabclose<CR>",            desc = "Close current tab" },
  { "<leader>tn", "<cmd>tabn<CR>",                desc = "Go to next tab" },
  { "<leader>tp", "<cmd>tabp<CR>",                desc = "Go to previous tab" },
  { "<leader>tf", "<cmd>tabnew %<CR>",            desc = "Open current buffer in new tab" },

  -- VimTeX / quickfix
  {
    "<leader>vh",
    function()
      vim.cmd("VimtexToggleMain")
    end,
    desc = "Toggle VimTeX main/hints",
    mode = "n",
  },
  {
    "<leader>ve",
    function()
      vim.cmd("VimtexErrors")
    end,
    desc = "Toggle VimTeX errors",
    mode = "n",
  },
  {
    "<leader>v>",
    function()
      vim.cmd("cnext")
    end,
    desc = "Next VimTeX warning/error",
    mode = "n",
  },
  {
    "<leader>v<",
    function()
      vim.cmd("cprev")
    end,
    desc = "Previous VimTeX warning/error",
    mode = "n",
  },
})

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })

vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "format file" })
vim.keymap.set("n", "<leader>uh", function()
  if not vim.lsp.inlay_hint then
    vim.notify("Inlay hints are not supported by this Neovim version", vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })

  vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
end, { desc = "Toggle Inlay Hints" })

-- Toggle VimTeX / LaTeX conceal symbols
vim.keymap.set("n", "<leader>uc", function()
  if vim.o.conceallevel == 0 then
    vim.o.conceallevel = 2
    vim.notify("Conceal enabled")
  else
    vim.o.conceallevel = 0
    vim.notify("Conceal disabled")
  end
end, { desc = "Toggle Conceal Level" })

vim.keymap.set("n", "<leader>uw", function()
  vim.wo.wrap = not vim.wo.wrap
  vim.notify("Line wrap " .. (vim.wo.wrap and "enabled" or "disabled"))
end, { desc = "Toggle line wrap" })
