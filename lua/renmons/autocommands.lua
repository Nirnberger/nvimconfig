local M = {}
local onSave = vim.api.nvim_create_augroup("AutoFormatOnSave", { clear = true })

local trim_group = vim.api.nvim_create_augroup("TrimTrailingWhitespace", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
  group = onSave,
  pattern = { "*.lua", "*.ts", "*.tsx", "*.py" },
  desc = "Format file before save.",
  callback = function(args)
    local clients = vim.lsp.get_clients({ bufnr = args.buf })

    if #clients == 0 then
      return
    end

    vim.lsp.buf.format({
      bufnr = args.buf,
      async = false,
      timeout_ms = 2000,
    })
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = trim_group,
  pattern = "*",
  desc = "Remove trailing whitespace on save",
  callback = function()
    local ft = vim.bo.filetype

    if ft == "markdown" or ft == "diff" then
      return
    end
    -- save cursor/window position
    local view = vim.fn.winsaveview()

    -- remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])

    -- restore cursor/window position
    vim.fn.winrestview(view)
  end,
})

-- Spell checking
local spell_group = vim.api.nvim_create_augroup("SpellSettings", { clear = true })

local function set_spell_highlights()
  vim.api.nvim_set_hl(0, "SpellBad", {
    --fg = "#ff0000",
    bg = "#330000",
    bold = true,
    underline = false,
    nocombine = true,
  })
end

set_spell_highlights()

-- Enable spell check only for text-heavy files
vim.api.nvim_create_autocmd("FileType", {
  group = spell_group,
  pattern = {
    "markdown",
    "tex",
    "latex",
    "text",
    "gitcommit",
  },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en_us", "de_de" }
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = spell_group,
  callback = set_spell_highlights,
})

local cursor_group = vim.api.nvim_create_augroup("CursorVisuals", {
  clear = true,
})

-- Make the current position easier to track
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Different cursor shapes and colors for each mode
vim.opt.guicursor = table.concat({
  "n-v-c:block-Cursor",
  "i-ci-ve:ver30-InsertCursor",
  "r-cr:hor25-ReplaceCursor",
  "o:hor50-Cursor",
  "a:blinkwait700-blinkoff300-blinkon250",
}, ",")

local function set_cursor_highlights()
  -- Normal mode: strong orange block
  vim.api.nvim_set_hl(0, "Cursor", {
    fg = "#1e1e2e",
    bg = "#ff9e64",
    bold = true,
  })

  -- Insert mode: green vertical cursor
  vim.api.nvim_set_hl(0, "InsertCursor", {
    fg = "#1e1e2e",
    bg = "#9ece6a",
  })

  -- Replace mode: red horizontal cursor
  vim.api.nvim_set_hl(0, "ReplaceCursor", {
    fg = "#1e1e2e",
    bg = "#f7768e",
  })

  -- Highlight the entire current line
  vim.api.nvim_set_hl(0, "CursorLine", {
    bg = "#292e42",
  })

  -- Make the current line number very noticeable
  vim.api.nvim_set_hl(0, "CursorLineNr", {
    fg = "#ff9e64",
    bold = true,
  })
end

set_cursor_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
  group = cursor_group,
  callback = set_cursor_highlights,
})
