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
    "codelldb",
  },
  automatic_installation = true,
})
