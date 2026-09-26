return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      {
        "folke/neodev.nvim",
        opts = {}, -- neodev will auto-setup lua_ls workspace for Neovim
      },
    },
    config = function()
      require("neodev").setup({})

      -- Diagnostics config
      vim.diagnostic.config({
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      })

      -- Capabilities (for nvim-cmp)
      local capabilities = require("cmp_nvim_lsp").default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
      )

      -- on_attach: keymaps etc.
      local on_attach = function(_, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = "LSP: " .. desc
          end
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
        nmap("K", vim.lsp.buf.hover, "Hover")
        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        nmap("[d", vim.diagnostic.goto_prev, "Prev diagnostic")
        nmap("]d", vim.diagnostic.goto_next, "Next diagnostic")
      end

      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            completion = { callSnippet = "Replace" },
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
      vim.lsp.enable({
        "lua_ls",
        "pyright",
        "ts_ls",
        "rust_analyzer",
        "clangd",
        "graphql",
      })
    end,
  },

}
