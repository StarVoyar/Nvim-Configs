return {
  {
    "p-nerd/sr.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("sr").setup({
        keymap = "<C-r>",
        ignore_case = false,
        use_regex = false,
        preview_changes = true,
        live_preview = true,
      })
    end,
  },
}
