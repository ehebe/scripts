return {
  "EthanJWright/vs-tasks.nvim",
  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },
  -- TODO: uncomment below keymaps when they no longer cause errors
  config = function()
    local vstask = require("telescope").extensions.vstask
    vim.keymap.set("n", "<leader>ta", vstask.tasks, { desc = "List tasks" })
    vim.keymap.set("n", "<leader>ti", vstask.inputs, { desc = "List inputs" })
    -- vim.keymap.set('n', '<leader>th', vstask.history)
    vim.keymap.set("n", "<leader>tl", vstask.launch, { desc = "Launch task" })
    vim.keymap.set("n", "<leader>tj", vstask.jobs, { desc = "List jobs" })
    -- vim.keymap.set('n', '<leader>t;', vstask.jobhistory)
  end,
}
