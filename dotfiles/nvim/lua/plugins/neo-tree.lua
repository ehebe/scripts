return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false,
  event = "VeryLazy",
  opts = {},
  config = function()
    require("neo-tree").setup({
      window = {
        width = 35,
        mappings = {
          ["l"] = "open_with_window_picker",
          ["h"] = "close_node",
          ["s"] = "vsplit_with_window_picker",
          ["S"] = "split_with_window_picker",
          ["<cr>"] = "open",
        },
      },
      source_selector = {
        winbar = true,
        statusline = true,
        truncation_character = "...",
        sources = {
          { source = "filesystem", display_name = " 󰉓 Files " },
          { source = "buffers", display_name = " 󰈙 Buffers " },
          { source = "git_status", display_name = " 󰊢 Git " },
        },
      },
    })

    -- set keymaps
    local keymap = vim.keymap

    keymap.set("n", "<leader>ee", "<cmd>Neotree toggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>ef", "<cmd>Neotree toggle reveal<CR>", { desc = "Toggle file explorer on current file" })
    keymap.set(
      "n",
      "<leader>ec",
      "<cmd>Neotree focus<CR><cmd>execute 'normal! W'<CR>",
      { desc = "Collapse file explorer" }
    )
  end,
}
