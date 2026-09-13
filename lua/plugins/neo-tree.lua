return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,

    config = function()
      local width = 28

      require("neo-tree").setup({
        enable_git_status = false,

        window = {
          width = width,
        },
      })

      vim.api.nvim_create_autocmd("WinResized", {
        callback = function()
          for _, win in ipairs(vim.v.event.windows) do
            if vim.api.nvim_win_is_valid(win) then
              local buf = vim.api.nvim_win_get_buf(win)

              if vim.bo[buf].filetype == "neo-tree" then
                width = vim.api.nvim_win_get_width(win)
              end
            end
          end
        end,
      })

      vim.api.nvim_create_autocmd("BufWinEnter", {
        callback = function(args)
          if vim.bo[args.buf].filetype ~= "neo-tree" then
            return
          end

          vim.schedule(function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_is_valid(win) then
                local buf = vim.api.nvim_win_get_buf(win)

                if vim.bo[buf].filetype == "neo-tree" then
                  vim.api.nvim_win_set_width(win, width)
                  break
                end
              end
            end
          end)
        end,
      })
    end,
  },
}
