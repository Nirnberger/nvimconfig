return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "c", "lua", "vim", "vimdoc", "query",
      "python", "rust",
      "javascript", "typescript", "tsx", "html", "graphql",
      "bash", "json",
      "markdown", "markdown_inline",
      "elixir",
    })

    -- main no longer enables highlighting/indent for you
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
      callback = function(args)
        -- pcall: silently skip filetypes without a parser (tex, chadtree, ...)
        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
