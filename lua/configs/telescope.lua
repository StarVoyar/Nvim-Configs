local telescope = require("telescope.builtin")

-- Telescope keybindings
vim.keymap.set("n", "<C-f>", function()
  require("telescope").extensions.live_grep_args.live_grep_args()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<A-f>", telescope.find_files, {})

-- Telescope prompt backspace fix
vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopePrompt",
  callback = function()
    vim.keymap.set("i", "<BS>", "<C-h>", { buffer = true })
  end,
})
