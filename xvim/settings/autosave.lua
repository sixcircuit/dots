
vim.opt.updatetime = 1000

local function try_autosave()
   local buf = vim.api.nvim_get_current_buf()
   local name = vim.api.nvim_buf_get_name(buf)

   -- Skip non-file, non-normal buffers
   if vim.bo.buftype ~= "" then return end           -- no terminal, help, quickfix, etc.
   if name == "" then return end                     -- unsaved or scratch buffers
   if not vim.bo.modifiable or not vim.bo.modified then return end
   if vim.api.nvim_get_mode().mode ~= "n" then return end -- only in normal mode

   vim.cmd("doautocmd BufWritePre")
   vim.cmd("write")
   vim.cmd("doautocmd BufWritePost")
   -- i want BufWritePre to fire, it doesn't if i just do this.
   -- vim.cmd("silent! write")
end

-- this one will also save on undo and redo,
-- but sometimes i do a ton of that and i don't want dropbox to freak out.
-- also it lags if you hold down the redo key. so we use cursor hold to add a delay to that sort of thing
-- vim.api.nvim_create_autocmd({ "InsertLeave", "BufModifiedSet" }, { callback = try_autosave })

vim.api.nvim_create_autocmd({ "InsertLeave", "CursorHold" }, { callback = try_autosave })


