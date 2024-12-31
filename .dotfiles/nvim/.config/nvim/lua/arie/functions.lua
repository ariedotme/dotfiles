function _G.paste_and_edit()
  -- Get clipboard content
  local clipboard_text = vim.fn.getreg("+") -- Access the system clipboard

  -- Find "XXX" in the text
  local placeholder = "XXX"
  local start_index, end_index = string.find(clipboard_text, placeholder)

  if not start_index then
    print("No 'XXX' placeholder found in the clipboard text.")
    return
  end

  -- Calculate the position of "XXX" and remove it from the text
  local before_placeholder = clipboard_text:sub(1, start_index - 1)
  local after_placeholder = clipboard_text:sub(end_index + 1)
  local final_text = before_placeholder .. after_placeholder

  -- Get the current cursor position (row)
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  -- Paste the text into the current line, replacing the line
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { final_text })

  -- Calculate the target column where "XXX" was
  local target_col = #before_placeholder

  -- Move the cursor to the correct position
  vim.api.nvim_win_set_cursor(0, { row, target_col })

  -- Enter insert mode
  vim.cmd("startinsert")
end

-- Bind the function to a key combination
vim.api.nvim_set_keymap('n', '<leader>p', ':lua paste_and_edit()<CR>', { noremap = true, silent = true })


