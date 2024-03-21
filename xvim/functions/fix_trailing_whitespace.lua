

local function fix_trailing_whitespace(silent)
   -- save cursor position
   local save = vim.fn.winsaveview()
   if silent then
      vim.cmd([[silent %s/\s\+$//e]])
   else
      vim.cmd([[%s/\s\+$//e]])
      print("removed trailing whitespace")
   end
   -- restore cursor position
   vim.fn.winrestview(save)
end

vim.api.nvim_create_autocmd("BufWritePre", {
   pattern = "*",
   callback = function()
      fix_trailing_whitespace(true)
   end
})
