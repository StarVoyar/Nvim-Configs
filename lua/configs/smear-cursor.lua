require("smear_cursor").setup({
  stiffness = 0.6,
  trailing_stiffness = 0.4,
  damping = 0.85,
  time_interval = 7,
  smear_insert_mode = true,
})

vim.api.nvim_set_hl(0, "SmearCursor", { fg = "#7aa2f7" })
vim.api.nvim_set_hl(0, "SmearCursorTrail", { fg = "#3d59a1" })
