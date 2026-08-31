vim.api.nvim_create_autocmd("FileType", {
  pattern = "grug-far",
  callback = function()
    vim.opt_local.winfixwidth = true
    vim.cmd("vertical resize 30")
  end,
})
