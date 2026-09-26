return {
  'VVoruganti/today.nvim',
  config = function()
    require('today').setup({
      local_root = vim.fn.expand("~/Documents/jornal"),

    })
  end
}
