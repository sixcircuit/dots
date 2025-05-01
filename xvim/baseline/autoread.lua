
vim.opt.autoread = true

local timer = nil
local interval_ms = 2500

local function start_checktime_timer()
   if timer then
      timer:stop()
      timer:close()
   end

   local buf = vim.api.nvim_get_current_buf()
   timer = vim.loop.new_timer()
   timer:start(0, interval_ms, vim.schedule_wrap(function()
      if vim.api.nvim_buf_is_valid(buf)
         and vim.api.nvim_buf_is_loaded(buf)
         and vim.bo[buf].buftype == "" then
         vim.api.nvim_buf_call(buf, function()
            vim.cmd("silent! checktime")
         end)
      end
   end))
end

local function stop_checktime_timer()
   if timer then
      timer:stop()
      timer:close()
      timer = nil
   end
end

vim.api.nvim_create_autocmd("BufEnter", { callback = start_checktime_timer, })
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "VimLeavePre" }, { callback = stop_checktime_timer, })


