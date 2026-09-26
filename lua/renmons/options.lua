-- lua/renmons/options.lua
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo"

vim.opt.scrolloff = 4
vim.opt.termguicolors = true
vim.opt.spelllang = { "en_us" } --, "de_de" }
vim.opt.spell = false

vim.opt.mousescroll = 'ver:3,hor:6'
