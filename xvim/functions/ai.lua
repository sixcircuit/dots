
local function make_temp_path(prefix)
   math.randomseed(os.time())
   return "/tmp/" .. prefix .. "_" .. tostring(os.time()) .. "_" .. tostring(math.random(1000000000, 9999999999))
end

local function start_term_and_insert_file_on_close(cmd, temp_path, term_info, last_line)

   local prev_win = vim.api.nvim_get_current_win()

   if (term_info.vertical) then
      vim.cmd(term_info.size .. "vsplit")
   else
      vim.cmd(term_info.size .. "split")
   end

   local split_win = vim.api.nvim_get_current_win()

   vim.cmd("terminal " .. cmd)
   vim.cmd("startinsert")

   -- handle process termination
   vim.cmd("autocmd TermClose * ++once lua exec_term_close_and_insert(".. prev_win .. ", '" .. temp_path .. "', " .. split_win .. ", " .. tostring(last_line) .. ")")
end

function _G.do_llm(extra_cmd)

   local temp_path = make_temp_path("llm_output")

   local llm_cmd = "llm --wait --output " .. temp_path .. " " .. extra_cmd

   start_term_and_insert_file_on_close(llm_cmd, temp_path, { vertical = true, size = 90 }, false)

end

local function trim_lines(array)
    local trimmed_array = {}
    for _, line in ipairs(array) do
        trimmed_array[#trimmed_array + 1] = line:gsub("^%s+", ""):gsub("%s+$", "")
    end
    return trimmed_array
end


function _G.exec_term_close_and_insert(prev_win, temp_path, split_win, last_line)
   local prev_buf = vim.api.nvim_win_get_buf(prev_win)

   if vim.fn.filereadable(temp_path) == 0 then
      vim.notify("you either canceled the command or the temp_file wasn't created because something went wrong.", vim.log.levels.INFO)
      return
   end

   -- insert output at cursor position in previous buffer
   local lines = vim.fn.readfile(temp_path)

   lines = trim_lines(lines)

   if #lines > 0 then
      if (last_line) then
         lines = { lines[#lines] }
      end

      -- this is a hack for whisper, but i don't care to refactor everything so this is in the do_whisper function.
      if (lines[1] == "[BLANK_AUDIO]") then
         lines[1] = ""
      end

      local cursor_pos = vim.api.nvim_win_get_cursor(prev_win)

      vim.api.nvim_buf_set_text(prev_buf, cursor_pos[1]-1, cursor_pos[2], cursor_pos[1]-1, cursor_pos[2], lines)

      vim.api.nvim_win_set_cursor(prev_win, cursor_pos)

   end

   -- restore view and close terminal buffer
   vim.api.nvim_set_current_win(prev_win)
   vim.api.nvim_win_close(split_win, true)

   os.remove(temp_path)

end

local function llm_map(keys, command)
   vim.api.nvim_set_keymap('n', keys, ':lua do_llm("' .. command .. '")<CR>', { desc = "insert llm output: " .. command, noremap = true, silent = true})
   vim.api.nvim_set_keymap('v', keys, 'c<C-O>:lua do_llm("' .. command .. '")<CR>', { desc = "insert llm output: " .. command, noremap = true, silent = true})
end

-- llm_map("ai", "")
llm_map("ic", "continue")
llm_map("is", "llama-3.1-8b")
llm_map("ib", "llama-3.3-70b")
-- llm_map("lsv", "llama-3.1-8b verbose")
-- llm_map("lbv", "llama-3.3-70b verbose")
llm_map("ijs", "llama-3.1-8b jsfun")
llm_map("ijb", "llama-3.3-70b jsfun")

-- whisper.cpp stuff.

vim.api.nvim_set_keymap('i', '<C-f>', [[<C-\><C-o>:lua do_whisper()<CR>]], { desc = "insert text to speech", noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>', [[i<C-o>:lua do_whisper()<CR>]], { desc = "insert text to speech", noremap = true, silent = true })

-- vim.api.nvim_set_keymap('i', '<C-i>', [[<C-\><C-o>:lua do_llm("")<CR>]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('n', '<C-i>', [[i<C-o>:lua do_llm("")<CR>]], {noremap = true, silent = true})

function _G.do_whisper()

   local temp_path = make_temp_path("whisper_cpp_stream")

   local hostname = vim.fn.system('hostname -s'):gsub('%s+', '')

   local stream_cmd_name = 'speech_to_text.stream.' .. hostname

   local stream_exists = vim.fn.system('command -v ' .. stream_cmd_name)

   if stream_exists == "" then
      vim.notify("Missing hostname specific text to speech streaming command: " .. stream_cmd_name, vim.log.levels.ERROR)
      return
   end

   local stream_cmd = stream_cmd_name .. ' ' .. temp_path

   start_term_and_insert_file_on_close(stream_cmd, temp_path, { vertical = false, size = 10 }, true)

end
