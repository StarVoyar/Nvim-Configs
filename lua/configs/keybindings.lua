-- Grug-far keybinding
vim.keymap.set("n", "<C-r>", function()
  require("grug-far").open({
    prefills = {
      search = vim.fn.expand("<cword>"),
    },
  })
end, { noremap = true, silent = true })

-- Terminal keybinding
vim.keymap.set({ "n", "t" }, "<C-t>", function()
  local term_buf = nil
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      term_buf = buf
      break
    end
  end

  local term_win = nil
  if term_buf then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) == term_buf then
        term_win = win
        break
      end
    end
  end

  if term_win then
    vim.api.nvim_win_close(term_win, true)
  elseif term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.cmd("botright 7split")
    vim.api.nvim_set_current_buf(term_buf)
    vim.cmd("startinsert")
  else
    vim.cmd("botright 7split | terminal")
    vim.cmd("startinsert")
  end
end, { noremap = true, silent = true })

-- Neo-tree keybinding
vim.keymap.set("n", "<C-e>", ":Neotree toggle<CR>")

-- Window navigation
vim.keymap.set("n", "<C-Left>", "<C-w>h")
vim.keymap.set("n", "<C-Right>", "<C-w>l")

-- Shift-arrow selection
vim.keymap.set("n", "<S-Left>", "v<Left>")
vim.keymap.set("n", "<S-Right>", "v<Right>")
vim.keymap.set("n", "<S-Up>", "v<Up>")
vim.keymap.set("n", "<S-Down>", "v<Down>")

vim.keymap.set("i", "<S-Left>", "<C-o>v<Left>")
vim.keymap.set("i", "<S-Right>", "<C-o>v<Right>")
vim.keymap.set("i", "<S-Up>", "<C-o>v<Up>")
vim.keymap.set("i", "<S-Down>", "<C-o>v<Down>")

vim.keymap.set("v", "<S-Left>", "<Left>")
vim.keymap.set("v", "<S-Right>", "<Right>")
vim.keymap.set("v", "<S-Up>", "<Up>")
vim.keymap.set("v", "<S-Down>", "<Down>")

-- Copy/Paste/Cut
vim.keymap.set("n", "<C-c>", '"+yy')
vim.keymap.set("n", "<C-x>", '"+dd')
vim.keymap.set("n", "<C-v>", '"+p')

vim.keymap.set("v", "<C-c>", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd('normal! "+y')
  vim.api.nvim_win_set_cursor(0, pos)
end)
vim.keymap.set("v", "<C-x>", '"+d')
vim.keymap.set("v", "<C-v>", '"+p')

vim.keymap.set("i", "<C-c>", '<C-o>"+yy')
vim.keymap.set("i", "<C-x>", '<C-o>"+dd')
vim.keymap.set("i", "<C-v>", '<C-r>+')

-- Undo/Redo
vim.keymap.set("n", "<C-z>", "u")
vim.keymap.set("n", "<C-y>", "<C-r>")

vim.keymap.set("v", "<C-z>", "u")
vim.keymap.set("v", "<C-y>", "<C-r>")

vim.keymap.set("i", "<C-z>", "<C-o>u")
vim.keymap.set("i", "<C-y>", "<C-o><C-r>")

-- Save
vim.keymap.set("n", "<C-s>", "<Cmd>write<CR>")
vim.keymap.set("i", "<C-s>", "<C-o><Cmd>write<CR>")
vim.keymap.set("v", "<C-s>", "<Cmd>write<CR>")

-- Window resize
vim.keymap.set("n", "<C-S-Left>", ":vertical resize -5<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-S-Right>", ":vertical resize +5<CR>", { noremap = true, silent = true })

-- Quit
vim.keymap.set("n", "<A-s>", function()
  vim.cmd("wqa")
end)

vim.keymap.set("v", "<A-s>", function()
  vim.cmd("wqa")
end)

vim.keymap.set("i", "<A-s>", function()
  vim.cmd("wqa")
end)

vim.keymap.set("n", "<A-q>", ":qa!<CR>", { noremap = true, silent = true })

-- Select all
local pre_select_view = nil

local function select_all()
  pre_select_view = vim.fn.winsaveview()
  vim.cmd("normal! gg0")
  vim.cmd("normal! vG$")
  vim.cmd("normal! o")
end

vim.keymap.set("n", "<C-a>", select_all)
vim.keymap.set("v", "<C-a>", select_all)
vim.keymap.set("i", "<C-a>", function()
  vim.cmd("stopinsert")
  select_all()
end)

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "[vV\x16]*->n",
  callback = function()
    if pre_select_view then
      vim.schedule(function()
        pcall(vim.fn.winrestview, pre_select_view)
        pre_select_view = nil
      end)
    end
  end,
})

-- Backspace delete without yank
vim.keymap.set("n", "<BS>", '"_dd')
vim.keymap.set("v", "<BS>", '"_d')
vim.keymap.set("i", "<BS>", "<C-o>\"_dd")

-- Quit with confirmation
vim.keymap.set("n", "<C-q>", "<Cmd>confirm quit<CR>")
vim.keymap.set("v", "<C-q>", "<Esc><Cmd>confirm quit<CR>")
vim.keymap.set("i", "<C-q>", "<C-o><Cmd>confirm quit<CR>")

-- Tab indent
vim.keymap.set("v", "<Tab>", ">gv", { noremap = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { noremap = true })

-- Select word/line with Ctrl-D
local last_ctrl_d = 0

local function select_word()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  if line == "" then
    return
  end

  local start_col = col + 1

  while start_col > 1 and line:sub(start_col - 1, start_col - 1):match("[%w_]") do
    start_col = start_col - 1
  end

  local end_col = col + 1

  while end_col <= #line and line:sub(end_col, end_col):match("[%w_]") do
    end_col = end_col + 1
  end

  vim.cmd("normal! v")
  vim.api.nvim_win_set_cursor(0, { row, start_col - 1 })
  vim.cmd("normal! o")
  vim.api.nvim_win_set_cursor(0, { row, end_col - 2 })
end

local function select_line()
  vim.cmd("normal! V")
end

local function ctrl_d_action()
  local now = vim.uv.hrtime() / 1e6

  if now - last_ctrl_d < 500 then
    select_line()
  else
    select_word()
  end

  last_ctrl_d = now
end

vim.keymap.set("n", "<C-d>", ctrl_d_action)
vim.keymap.set("v", "<C-d>", ctrl_d_action, { noremap = true, silent = true })
vim.keymap.set("i", "<C-d>", function()
  vim.cmd("stopinsert")
  ctrl_d_action()
end)

-- Move lines with Alt arrows
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==")
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==")

vim.keymap.set("i", "<A-Up>", "<C-o>:m .-2<CR><C-o>==")
vim.keymap.set("i", "<A-Down>", "<C-o>:m .+1<CR><C-o>==")

-- Duplicate/remove lines with Ctrl arrows
vim.keymap.set("n", "<C-Up>", function()
  local current = vim.fn.getline(".")
  local above_line = vim.fn.line(".") - 1

  if above_line < 1 then
    return
  end

  local above = vim.fn.getline(above_line)

  if above == current then
    vim.cmd("normal! kdd")
  end
end)

vim.keymap.set("n", "<C-Down>", function()
  local current = vim.fn.getline(".")

  if current ~= "" then
    vim.cmd("normal! yyp")
  end
end)

vim.keymap.set("i", "<C-Up>", function()
  -- exit insert mode safely
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
    "n",
    false
  )

  -- run the same logic as normal mode
  local current = vim.fn.getline(".")
  local above_line = vim.fn.line(".") - 1

  if above_line >= 1 then
    local above = vim.fn.getline(above_line)
    if above == current then
      vim.cmd("normal! kdd")
    end
  end

  -- return to insert mode AFTER the movement finishes
  vim.schedule(function()
    vim.cmd("startinsert")
  end)
end)

vim.keymap.set("i", "<C-Down>", function()
  -- exit insert mode safely
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
    "n",
    false
  )

  -- run the same logic as normal mode
  local current = vim.fn.getline(".")
  if current ~= "" then
    vim.cmd("normal! yyp")
  end

  -- return to insert mode AFTER the movement finishes
  vim.schedule(function()
    vim.cmd("startinsert")
  end)
end)

-- Terminal tab navigation (terminal mode only)
vim.keymap.set("t", "<C-Up>", function()
  vim.cmd("tabprevious")
end, { noremap = true, silent = true })

vim.keymap.set("t", "<C-Down>", function()
  vim.cmd("tabnext")
end, { noremap = true, silent = true })

-- Terminal exit (terminal mode only - note: <C-q> in normal mode is for quit)
vim.keymap.set("t", "<C-q>", "<C-\\><C-n>i exit<CR>", { noremap = true, silent = true })

-- Alt‑Arrow navigation
vim.keymap.set("n", "<A-Left>",  "^", { noremap = true, silent = true })   -- move to start of line
vim.keymap.set("n", "<A-Right>", "$", { noremap = true, silent = true })   -- move to end of line

vim.keymap.set("i", "<A-Left>",  "<C-o>^", { noremap = true, silent = true })
vim.keymap.set("i", "<A-Right>", "<C-o>$", { noremap = true, silent = true })

vim.keymap.set("v", "<A-Left>",  "^", { noremap = true, silent = true })
vim.keymap.set("v", "<A-Right>", "$", { noremap = true, silent = true })

-- Ctrl-Arrow word navigation

vim.keymap.set("n", "<C-A-Left>", "b", { noremap = true, silent = true }) -- Move to start of previous word
vim.keymap.set("n", "<C-A-Right>", "e", { noremap = true, silent = true }) -- Move to end of current word

vim.keymap.set("i", "<C-A-Left>", "<C-o>b", { noremap = true, silent = true }) -- Move to start of previous word
vim.keymap.set("i", "<C-A-Right>", "<C-o>e", { noremap = true, silent = true }) -- Move to end of current word

vim.keymap.set("v", "<C-A-Left>", "b", { noremap = true, silent = true }) -- Move to start of previous word
vim.keymap.set("v", "<C-A-Right>", "e", { noremap = true, silent = true }) -- Move to end of current word

local comment = require("Comment.api")

vim.keymap.set("n", "<C-_>", function()
  comment.toggle.linewise.current()
end, { noremap = true, silent = true })

vim.keymap.set("v", "<C-_>", function()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  comment.toggle.linewise(vim.fn.visualmode())
end, { noremap = true, silent = true })

vim.keymap.set("i", "<C-_>", function()
  vim.cmd("stopinsert")
  comment.toggle.linewise.current()
  vim.cmd("startinsert")
end, { noremap = true, silent = true })