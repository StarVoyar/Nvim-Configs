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

-- Ensure files end with a newline, excluding binary files
vim.opt.fixeol = true

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local binary_extensions = {
      "exe", "dll", "o", "a", "so", "dylib", "lib", "bin", "obj",
      "png", "jpg", "jpeg", "gif", "bmp", "ico", "webp",
      "mp3", "mp4", "wav", "ogg", "flac", "avi", "mkv", "mov",
      "zip", "tar", "gz", "rar", "7z", "pdf", "doc", "docx", "xls", "xlsx"
    }

    local filename = vim.fn.expand("%:t")
    local ext = filename:match("%.([^%.]+)$")

    if ext then
      ext = ext:lower()
      for _, bin_ext in ipairs(binary_extensions) do
        if ext == bin_ext then
          return
        end
      end
    end

    -- Check if file is already marked as binary
    if vim.opt.binary:get() then
      return
    end

    -- Add newline at end of file if missing
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count > 0 then
      local last_line = vim.api.nvim_buf_get_lines(0, line_count - 1, line_count, false)[1]
      if last_line ~= "" then
        vim.api.nvim_buf_set_lines(0, line_count, line_count, false, {""})
      end
    end
  end,
})
