local M = {}

function M.setup()
  M.smart_dd()
  M.move_selected_upndown()
  M.scroll_from_center()
  M.visually_codeblock_shift()
end

-- yank blank line will go to void register
function M.smart_dd()
  local dd = function()
    if vim.api.nvim_get_current_line():match("^%s*$") then
      return '"_dd'
    else
      return "dd"
    end
  end
  vim.keymap.set("n", "dd", dd, { noremap = true, expr = true })
end

function M.visually_codeblock_shift()
  vim.api.nvim_set_keymap("v", "<", "<gv", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", ">", ">gv", { noremap = true, silent = true })
end

function M.move_selected_upndown()
  vim.api.nvim_set_keymap("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
end

function M.scroll_from_center()
  vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })
end

return M
