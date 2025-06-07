
vim.opt.updatetime = 300

local autosave_timer = nil

local function try_save()
   local buf = vim.api.nvim_get_current_buf()
   local name = vim.api.nvim_buf_get_name(buf)

   -- Skip non-normal buffers, unnamed buffers, or ones not modifiable/modified
   if vim.bo.buftype ~= "" then return end
   if name == "" then return end
   if not vim.bo.modifiable or not vim.bo.modified then return end
   if vim.api.nvim_get_mode().mode ~= "n" then return end

   -- Check if file exists on disk
   local file_exists = vim.loop.fs_stat(name)
   if not file_exists then return end

   -- Trigger full write + pre/post autocmds
   vim.cmd("doautocmd BufWritePre")
   vim.cmd("write")
   vim.cmd("doautocmd BufWritePost")
end


local function schedule_autosave()
   local delay_ms = 300

   if autosave_timer then
      autosave_timer:stop()
      autosave_timer:close()
      autosave_timer = nil
   end

   autosave_timer = vim.loop.new_timer()
   autosave_timer:start(delay_ms, 0, vim.schedule_wrap(function()
      try_save()
      autosave_timer = nil
   end))
end

-- this one will also save on undo and redo,
-- but sometimes i do a ton of that and i don't want dropbox to freak out.
-- also it lags if you hold down the redo key. so we use cursor hold to add a delay to that sort of thing
-- vim.api.nvim_create_autocmd({ "InsertLeave", "BufModifiedSet" }, { callback = try_autosave })

vim.api.nvim_create_autocmd({ "InsertLeave", "CursorHold", "BufLeave", "FocusLost" }, { callback = schedule_autosave })

vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, {
   callback = function()
      if vim.api.nvim_get_mode().mode:match("^i") then
         vim.cmd("stopinsert")
      end
   end,
})

-- -- fix_trailing_whitespace
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*",
--   callback = function()
--     vim.cmd([[%s/\s\+$//e]])
--   end,
-- })

-- local function fix_trailing_whitespace(silent)
--    -- save cursor position
--    local save = vim.fn.winsaveview()
--    if silent then
--       vim.cmd([[silent %s/\s\+$//e]])
--    else
--       vim.cmd([[%s/\s\+$//e]])
--       print("removed trailing whitespace")
--    end
--    -- restore cursor position
--    vim.fn.winrestview(save)
-- end
--
-- vim.api.nvim_create_autocmd("InsertLeave", {
--    pattern = "*",
--    callback = function()
--       fix_trailing_whitespace(true)
--    end
-- })

