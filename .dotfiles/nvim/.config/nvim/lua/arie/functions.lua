function _G.paste_and_edit()
  local clipboard_text = vim.fn.getreg("+")

  local placeholder = "XXX"
  local start_index, end_index = string.find(clipboard_text, placeholder)

  if not start_index then
    print("No 'XXX' placeholder found in the clipboard text.")
    return
  end

  local before_placeholder = clipboard_text:sub(1, start_index - 1)
  local after_placeholder = clipboard_text:sub(end_index + 1)
  local final_text = before_placeholder .. after_placeholder

  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))

  vim.api.nvim_buf_set_lines(0, row - 1, row, false, { final_text })

  local target_col = #before_placeholder

  vim.api.nvim_win_set_cursor(0, { row, target_col })

  vim.cmd("startinsert")
end
