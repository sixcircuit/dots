local function is_cursor_in_comment()
   local syn_id = vim.fn.synID(vim.fn.line('.'), vim.fn.col('.'), 0)
   local syn_name = vim.fn.synIDattr(syn_id, 'name')
   print(syn_id)
   print(syn_name)

   if syn_name:match('Comment') then
      print('In comment')
   else
      print('Not in comment')
   end
end


local function set_js_abbreviations()

--    vim.api.nvim_set_keymap('i', 'myabbr', 'v:lua.is_in_comment_treesitter() and "myabbr" or "expanded_text"', { expr = true, noremap = true})
   -- vim.api.nvim_set_keymap('ia', 'neovimisfun', 'Neovim is Fun!')
   -- vim.keymap.set("ia", "hh", "HELLO!"

   vim.keymap.set("ia", "kt", function()
      if(is_cursor_in_comment()) then
         return("COMMENT KENDRICK!")
      else
         return("KENDRICK!")
      end
   end, { expr = true })


--    vim.api.nvim_set_keymap('i', 'myabbr', 'v:lua.is_in_comment_treesitter() and "myabbr" or "expanded_text"', { expr = true, noremap = true})
--    local wrong = {
--       'function', 'if', 'else', 'for', 'return'
--    }

--    local abbreviations = {
--       -- exp = 'export',
--    }

--    for index, value in ipairs(wrong) do

--       -- vim.api.nvim_command('iabbrev <buffer> ' .. value .. ' WRONG')
--    end

--    for lhs, rhs in pairs(abbreviations) do
--       vim.api.nvim_command('iabbrev <buffer> ' .. lhs .. ' ' .. rhs)
--    end
end

-- Create an autocmd to set the abbreviations when editing JavaScript files
vim.api.nvim_create_autocmd('FileType', {
   pattern = 'javascript',
   callback = set_js_abbreviations,
})
