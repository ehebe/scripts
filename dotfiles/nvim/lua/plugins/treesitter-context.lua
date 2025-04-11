return {
  "nvim-treesitter/nvim-treesitter-context",
  envent = { "VeryLazy" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    require("treesitter-context").setup()
  end,
}
