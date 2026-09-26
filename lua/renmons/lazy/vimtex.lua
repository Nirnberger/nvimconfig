return {
  "lervag/vimtex",
  init = function()
    vim.g.vimtex_quickfix_open_on_warning = 0

    -- enable folding
    vim.g.vimtex_fold_enabled = 1

    -- big files folging
    vim.g.vimtex_fold_manual = 1

    -- set default viewer
    vim.g.vimtex_view_method = "skim"

    -- ueep unfolded when starting
    vim.opt.foldlevelstart = 99
  end,
}
