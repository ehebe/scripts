return {
  "ojroques/nvim-osc52",
  opts = function()
    local function copy(lines, _)
      require("osc52").copy(table.concat(lines, "\n"))
    end

    local function paste()
      return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
    end

    vim.g.clipboard = {
      name = "osc52",
      copy = { ["+"] = copy, ["*"] = copy },
      paste = { ["+"] = paste, ["*"] = paste },
    }

    -- I don't even use these mappings, just the clipboard
    -- -- Key mappings for OSC52
    -- vim.keymap.set("n", "<leader>1", '"+y')
    -- vim.keymap.set("n", "<leader>2", '"+yy')
  end,
}
