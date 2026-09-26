return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  opts = {
    options = {
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and "" or ""
        return " " .. icon .. count
      end,
      separator_style = "slant",
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      numbers = "ordinal",
      persist_buffer_sort = true,
    },
  },
}

