vim.opt.guicursor = table.concat({
  "n:underline",
  "v:hor20",
  "V:hor25",
  "c:block",
  "i:ver25",
  "r:hor20",
  "cr:block",
  "o:underline",
  "sm:ver20",
}, ",")

local hover_timer = nil

local function is_cursor_on_word()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]

  if line == "" or col >= #line then
    return false
  end

  local char = line:sub(col + 1, col + 1)

  return char:match("[%w_]") ~= nil
end

vim.api.nvim_create_autocmd("CursorMoved", {
  callback = function()
    if hover_timer then
      hover_timer:stop()
      hover_timer:close()
      hover_timer = nil
    end

    if not is_cursor_on_word() then
      return
    end

    hover_timer = vim.uv.new_timer()

    hover_timer:start(2500, 0, vim.schedule_wrap(function()
      if is_cursor_on_word()
          and vim.lsp.get_clients({ bufnr = 0 })[1] then
        vim.lsp.buf.hover()
      end

      if hover_timer then
        hover_timer:stop()
        hover_timer:close()
        hover_timer = nil
      end
    end))
  end,
})
