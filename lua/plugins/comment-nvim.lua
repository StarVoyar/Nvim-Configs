return {
  "numToStr/Comment.nvim",
  config = function()
    require("Comment").setup()
    local api = require("Comment.api")

    vim.keymap.set("n", "<C-_>", function()
      api.toggle.linewise.current()
    end, { noremap = true, silent = true })

    vim.keymap.set("v", "<C-_>", function()
      local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
      vim.api.nvim_feedkeys(esc, "nx", false)
      api.toggle.linewise(vim.fn.visualmode())
    end, { noremap = true, silent = true })

    vim.keymap.set("i", "<C-_>", function()
      vim.cmd("stopinsert")
      api.toggle.linewise.current()
      vim.cmd("startinsert")
    end, { noremap = true, silent = true })
  end,
}
