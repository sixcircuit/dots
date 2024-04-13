
local function make_temp_path(prefix)
   math.randomseed(os.time())
   return "/tmp/" .. prefix .. "_" .. tostring(os.time()) .. "_" .. tostring(math.random(1000000000, 9999999999))
end

local function start_term_and_insert_file_on_close(cmd, temp_path, term_info)

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
   vim.cmd("autocmd TermClose * ++once lua exec_term_close_and_insert(".. prev_win .. ", '" .. temp_path .. "', " .. split_win .. ")")
end

function _G.do_llm(extra_cmd)

   local temp_path = make_temp_path("llm_output")

   local cmd = "llm --wait --output " .. temp_path .. " " .. extra_cmd

   start_term_and_insert_file_on_close(cmd, temp_path, { vertical = true, size = 90 })

end

function _G.exec_term_close_and_insert(prev_win, temp_path, split_win)
   local prev_buf = vim.api.nvim_win_get_buf(prev_win)

   -- insert output at cursor position in previous buffer
   local lines = vim.fn.readfile(temp_path)
   local cursor_pos = vim.api.nvim_win_get_cursor(prev_win)

   vim.api.nvim_buf_set_text(prev_buf, cursor_pos[1]-1, cursor_pos[2], cursor_pos[1]-1, cursor_pos[2], lines)

   -- restore view and close terminal buffer
   vim.api.nvim_set_current_win(prev_win)
   vim.api.nvim_win_close(split_win, true)

end

local function llm_map(keys, command)
   vim.api.nvim_set_keymap('n', '<leader>' .. keys, ':lua do_llm("' .. command .. '")<CR>', {noremap = true, silent = true})
   vim.api.nvim_set_keymap('v', '<leader>' .. keys, 'c<C-O>:lua do_llm("' .. command .. '")<CR>', {noremap = true, silent = true})
end

llm_map("lt", "3 ham .")
llm_map("ll", "")
llm_map("ld", "3 verbose")
llm_map("ls", "4 verbose")


-- whisper.cpp stuff.

vim.api.nvim_set_keymap('i', '<C-f>', [[<C-\><C-o>:lua ExecuteAndInsert()<CR>]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-f>', [[i<C-o>:lua ExecuteAndInsert()<CR>]], {noremap = true, silent = true})

function ExecuteAndInsert()

   local temp_path = make_temp_path("whisper_cpp_stream")

   local hostname = vim.fn.system('hostname -s'):gsub('%s+', '')

   local stream_cmd_name = 'speech_to_text.stream.' .. hostname

   local stream_exists = vim.fn.system('command -v ' .. stream_cmd_name)

   if stream_exists == "" then
      vim.notify("Missing hostname specific text to speech streaming command: " .. stream_cmd_name, vim.log.levels.ERROR)
      return
   end

   local stream_cmd = stream_cmd_name .. ' ' .. temp_path

   vim.api.nvim_command('10split | terminal ' .. stream_cmd)

   -- Once the terminal job is done, open the file, read the contents and put it in the current buffer
   local term_bufnr = vim.api.nvim_get_current_buf()
   vim.api.nvim_buf_attach(term_bufnr, false, {
      on_detach = function()
         local content = vim.fn.readfile(temp_path)
         if #content > 0 then
            vim.api.nvim_put(content, 'l', -1, true)
         end
      end
   })
end
