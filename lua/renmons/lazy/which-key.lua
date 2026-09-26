return {
  "folke/which-key.nvim",
  event = "VeryLazy",

  opts = {
    preset = "modern",

    keys = {
      scroll_down = "<c-j>",
      scroll_up = "<c-k>",
    },

    spec = {
      { "<leader>b", group = "buffers" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find" },
      { "<leader>n", group = "notes / tree / search" },
      { "<leader>s", group = "splits" },
      { "<leader>t", group = "tabs / today" },
      { "<leader>u", group = "ui toggles" },
      { "<leader>v", group = "vimtex" },
      { "<leader>z", group = "spelling" },
    },
  },

  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Show buffer-local keymaps",
    },
  },
}
