return {
  {
    "makyinmars/mdeye.nvim",
    ft = "markdown",
    config = function()
      require("mdeye").setup({
        open = "split", -- opens in a split view like VS Code
        max_width = 78,
        min_margin = 3,
        debounce_ms = 120,
      })
      -- Toggle preview with Alt+r in all modes
      vim.keymap.set({ "n", "v", "i", "c" }, "<A-r>", function()
        require("mdeye").toggle({ mode = "split" })
      end, { noremap = true, silent = true, desc = "Toggle markdown preview" })
    end,
  },
}
