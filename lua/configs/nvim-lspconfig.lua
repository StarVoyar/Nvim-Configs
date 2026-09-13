vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "pyright",
    "clangd",
    "rust_analyzer",
    "ts_ls",
    "jdtls",
    "html",
    "cssls",
    "gopls",
  },
  automatic_enable = true,
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = true,
      check = {
        command = "clippy",
      },
    },
  },
})

vim.lsp.enable({})

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})