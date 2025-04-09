return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")

      require("dapui").setup({})
      require("nvim-dap-virtual-text").setup({
        commented = true, -- Show virtual text alongside comment
      })

      -- dap for python
      local parts = { vim.fn.getcwd(), "venv", "bin", "python" }
      local detect_venv = table.concat(parts, "/")
      if vim.fn.filereadable(detect_venv) == 1 then
        dap_python.setup(detect_venv)
      else
        dap_python.setup("python3")
      end

      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapBreakpointRejected", {
        text = "", -- or "❌"
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapStopped", {
        text = "", -- or "→"
        texthl = "DiagnosticSignWarn",
        linehl = "Visual",
        numhl = "DiagnosticSignWarn",
      })

      -- Automatically open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      local keymap = vim.keymap -- for conciseness
      -- Toggle breakpoint
      keymap.set("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end, { desc = "dap toggle breakpoint" })

      -- Continue / Start
      keymap.set("n", "<leader>dc", function()
        dap.continue()
      end, { desc = "dap continue" })

      -- Step Over
      keymap.set("n", "<leader>do", function()
        dap.step_over()
      end, { desc = "dap step over" })

      -- Step Into
      keymap.set("n", "<leader>di", function()
        dap.step_into()
      end, { desc = "dap step into" })

      -- Step Out
      keymap.set("n", "<leader>dO", function()
        dap.step_out()
      end, { desc = "dap step out" })

      -- Keymap to terminate debugging
      keymap.set("n", "<leader>dq", function()
        require("dap").terminate()
      end, { desc = "dap terminate" })

      -- Toggle DAP UI
      keymap.set("n", "<leader>du", function()
        dapui.toggle()
      end, { desc = "dap toggle ui" })
    end,
  },
}
