local neo_tree_width = 28

require("neo-tree").setup({
  enable_git_status = false,

  window = {
    width = function()
      return neo_tree_width
    end,
  },
})

vim.api.nvim_create_autocmd("WinResized", {
  callback = function()
    for _, win in ipairs(vim.v.event.windows) do
      if not vim.api.nvim_win_is_valid(win) then
        goto continue
      end

      local buf = vim.api.nvim_win_get_buf(win)

      if vim.bo[buf].filetype == "neo-tree" then
        neo_tree_width = vim.api.nvim_win_get_width(win)
      end

      ::continue::
    end
  end,
})