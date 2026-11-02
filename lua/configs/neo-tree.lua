local neo_tree_width = 28
local default_width = 28

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

-- Reset neo-tree width when DAP UI closes
vim.api.nvim_create_autocmd("BufWinLeave", {
  pattern = "*",
  callback = function()
    -- Check if any dap buffers are still open
    local has_dap = false
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      local buf_name = vim.api.nvim_buf_get_name(buf)
      if buf_name:match("dap%-") then
        has_dap = true
        break
      end
    end

    -- If no dap buffers open, reset neo-tree width
    if not has_dap then
      neo_tree_width = default_width
      vim.schedule(function()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_is_valid(win) then
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "neo-tree" then
              vim.api.nvim_win_set_width(win, default_width)
              break
            end
          end
        end
      end)
    end
  end,
})