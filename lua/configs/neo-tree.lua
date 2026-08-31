local state_file = vim.fn.stdpath("data") .. "/neo_tree_width.txt"
local width = tonumber(vim.fn.readfile(state_file)[1]) or 28

require("neo-tree").setup({
  window = { width = width },
})

vim.api.nvim_create_autocmd("WinClosed", {
  pattern = "*",
  callback = function()
    local win = tonumber(vim.fn.expand("<amatch>"))
    if vim.api.nvim_win_is_valid(win) then
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.bo[buf].filetype == "neo-tree" then
        local w = vim.api.nvim_win_get_width(win)
        vim.fn.writefile({ tostring(w) }, state_file)
      end
    end
  end,
})
