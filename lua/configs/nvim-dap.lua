require("mason-nvim-dap").setup({
  ensure_installed = {
    "python",
    "node2",
    "chrome",
    "firefox",
    "js",
    "go",
    "javadbg",
    "java-test",
  },
  automatic_installation = true,
})
