return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    --local path = require("lspconfig.util").path

    --  You need to initialize eslint in your working directory
    --  npm init --yes && npm init @eslint/config@latest
    lint.linters_by_ft = {
      python = { "pylint" },
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>ll", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
    -- Set pylint to work in virtualenv
    -- Install pylint in virtualenv
    -- pip install pylint
    -- Need to run `python -m pylint --generate-rcfile > .pylintrc`
    lint.linters.pylint.cmd = "python"
    lint.linters.pylint.args = {
      "-m",
      "pylint",
      "-f",
      "json",
      "--from-stdin",
      function()
        return vim.api.nvim_buf_get_name(0)
      end,
    }
  end,
}
