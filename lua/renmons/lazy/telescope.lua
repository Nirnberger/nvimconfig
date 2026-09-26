return {
  'nvim-telescope/telescope.nvim',
  tag = 'v0.2.0',
  cmd = "Telescope",
  event = "VeryLazy",
  dependencies = {
    'nvim-lua/plenary.nvim',
    "nvim-telescope/telescope-ui-select.nvim"
  },
  opts = function()
    local themes = require("telescope.themes")

    return {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = {
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },

      extensions = {
        ["ui-select"] = {
          themes.get_dropdown({
            previewer = false,
            layout_config = {
              width = 0.45,
              height = 0.35,
            },
          }),
        },
      },
    }
  end,

  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("ui-select")
  end,
}
