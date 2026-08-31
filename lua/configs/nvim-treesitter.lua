local treesitter = require("nvim-treesitter")

treesitter.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

treesitter.install({
  "lua",
  "luau",
  "python",
  "c",
  "cpp",
  "rust",
  "javascript",
  "java",
  "html",
  "css",
  "go",
}, {
  max_jobs = 4,
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local language = vim.treesitter.language.get_lang(vim.bo.filetype)

    if not language then
      return
    end

    if not pcall(vim.treesitter.start, 0, language) then
      return
    end

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
