return {
  name = "python run",
  builder = function()
    local parts = { vim.fn.getcwd(), "venv", "bin", "python" }
    local detect_venv = table.concat(parts, "/")
    return {
      cmd = { detect_venv },
      args = { vim.fn.expand("%:p") },
      cwd = vim.fn.expand("%:p:h"),
      components = { "open_output", "default" },
    }
  end,
  condition = {
    filetype = { "python" },
  },
}
