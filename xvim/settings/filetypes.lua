
local function set_js_abbreviations()

   -- vim.api.nvim_set_keymap('i', 'myabbr', 'v:lua.is_in_comment_treesitter() and "myabbr" or "expanded_text"', { expr = true, noremap = true})
   -- vim.api.nvim_set_keymap('ia', 'neovimisfun', 'Neovim is Fun!')
   -- vim.keymap.set("ia", "hh", function() return "HELLO!" end, { expr = true })

   -- for the life of me, i tried a million different ways to make this work but it seems like the data is always stale somehow
   -- vim.api.nvim_set_keymap('ia', 'c', '', {
   --    callback = function()
   --       if(is_cursor_in_comment()) then return("COMMENT KENDRICK!")
   --       else return("KENDRICK!") end
   --    end, expr = true
   -- })
   --

   -- local wrong = {
   --    'function', 'if', 'else', 'for', 'return'
   -- }
   --
   -- for index, value in ipairs(wrong) do
   --    vim.keymap.set("ia", value, "WRONG", { buffer = true })
   -- end

   -- for lhs, rhs in pairs(abbreviations) do
   --    vim.keymap.set("ia", lhs, rhs)
   --    vim.api.nvim_command('iabbrev <buffer> ' .. lhs .. ' ' .. rhs)
   -- end

end

-- Create an autocmd to set the abbreviations when editing JavaScript files
vim.api.nvim_create_autocmd('FileType', {
   pattern = 'javascript',
   callback = set_js_abbreviations,
})

local delimitmate_disabled = false

vim.api.nvim_create_autocmd("InsertEnter", {
   callback = function()
      if vim.fn.reg_recording() ~= "" then
         delimitmate_disabled = true
         vim.cmd("DelimitMateOff")
      end
   end
})

vim.api.nvim_create_autocmd("InsertLeave", {
   callback = function()
      if delimitmate_disabled then
         delimitmate_disabled = false
         vim.cmd("DelimitMateOn")
      end
   end
})
