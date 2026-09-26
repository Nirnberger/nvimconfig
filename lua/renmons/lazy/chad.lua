return {
  {
    "ms-jpq/chadtree",
    branch = "chad",
    build = "python3 -m chadtree deps",  -- same as VimPlug's `do`
    config = function()
      -- optional: basic settings
      local settings = {
        view = {
          width = 30,
          sort_by = { "is_folder", "file_name_lower" },

        },
        options = {
          follow = true,         -- follow current file
          show_hidden = false,   -- toggle with "." inside CHADTree
          session = true,        -- remember expanded nodes between sessions
          version_control = {
            enable = true,
          },
          mimetypes = {
            warn = { "audio", "image", "video" }, -- warn before opening binaries
          },
        },
        ignore = {
          name_exact = { ".git", "node_modules", "dist", "target", ".DS_Store" },
          name_glob = { "*.log", "*.tmp", "*.swp" },
          path_glob = { "**/__pycache__/**", "**/.cache/**" },
        },

        -- Theme / icons
        theme = {
          icon_glyph_set = "devicons", -- "devicons", "emoji", "ascii", ...
          icon_colour_set = "github",  -- "github" or "none"
          -- If you use nord/solarized, you can sync CHADTree with it:
          -- text_colour_set = "nord",
          text_colour_set = "env",     -- respect your LS_COLORS/env
        },
      }
      vim.g.chadtree_settings = settings;
      -- Auto-quit Neovim if CHADTree is the only remaining window
      local grp = vim.api.nvim_create_augroup("ChadTreeCloseIfLast", { clear = true })

      vim.api.nvim_create_autocmd("BufEnter", {
        group = grp,
        callback = function()
          -- be robust to case: "chadtree", "CHADtree", etc.
          local ft = vim.bo.filetype:lower()
          if ft == "chadtree" and vim.fn.winnr("$") == 1 then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },
}

