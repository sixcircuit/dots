
local function echon_colored(hl_group, msg)
  vim.api.nvim_command('echohl ' .. hl_group)
  vim.api.nvim_command('echon "' .. msg .. '"')
  vim.api.nvim_command('echohl None')
end

local function syn_stack()
   local tbl = vim.inspect_pos()

   local result = {}

   for _, item in pairs(tbl.syntax) do
      table.insert(result, {
         hl_source = "syntax",
         hl_group = item.hl_group,
         hl_link = item.hl_group_link,
      })
   end

   for _, item in pairs(tbl.treesitter) do
      table.insert(result, {
         hl_source = "treesitter",
         hl_group = item.hl_group,
         hl_link = item.hl_group_link,
      })
   end

   for _, item in pairs(tbl.semantic_tokens) do
      table.insert(result, {
         hl_source = "lsp",
         hl_group = item.opts.hl_group,
         hl_link = item.opts.hl_group_link
      })
   end

   for _, item in pairs(result) do
      item.hl = vim.api.nvim_get_hl_by_name(item.hl_group, false)
   end

   local code = {}

   local function make_hl_code(item)

      local c = {
         -- 'vim.api.nvim_set_hl(0, "', item.hl_group, '", { ',
         'hl("', item.hl_group, '", { ',
      }
      if(item.hl_link ~= item.hl_group) then
         table.insert(c, 'link = "' .. item.hl_link .. '", ')
      end
      if(item.hl.foreground ~= nil) then
         table.insert(c, 'ctermfg = ' .. item.hl.foreground .. ', ')
      end
      if(item.hl.background ~= nil) then
         table.insert(c, 'ctermbg = ' .. item.hl.background .. ', ')
      end

      -- table.insert(c, 'default = true ')
      table.insert(c, '})')

      return table.concat(c, "")
   end

   for _, item in pairs(result) do
      echon_colored('None', item.hl_group .. " -> " .. item.hl_link .. " (" .. item.hl_source .. "): ")
      echon_colored(item.hl_group, vim.inspect(item.hl))
      echon_colored('None', "\n")
      table.insert(code, make_hl_code(item))
   end

   -- local code_str = table.concat(code, "\n")
   -- echon_colored('None', code_str .. "\n")
   vim.fn.setreg('+', table.concat(code, "\n"))

   -- vim.api.nvim_exec([[
   -- source /path/to/file.vim
   -- ]], false)
   -- vim.print("stack: ", result)
   -- vim.api.nvim_echo({{ "result: " .. vim.inspect(result) }}, false, {})

   -- vim.api.nvim_command('echomsg "' .. msg .. '"')
   -- echo_colored('This is a red message', 'MyHighlight')
end

vim.keymap.set("n", "H", syn_stack)
-- vim.keymap.set("n", "<c-i>", syn_stack)

-- local function syn_stack()
--    echo "SynStack"
--    for i1 in synstack(line("."), col("."))
--       echo "HERE"
--       echo i1
--    endfor
--    for i1 in synstack(line("."), col("."))
--       let i2 = synIDtrans(i1)
--       let n1 = synIDattr(i1, "name")
--       let n2 = synIDattr(i2, "name")
--       let n1Hi = trim(execute("highlight " . n1))
--       let n2Hi = trim(execute("highlight " . n2))
--       echo n1 . "->" . n2
--       " echo n1 . "(" . n1Hi . ")" "->" n2 . "(" . n2Hi . ")"
--       " echo "(" . n1Hi . ") -> (" . n2Hi . ")"
--    endfor
--
--    for i1 in synstack(line("."), col("."))
--       let i2 = synIDtrans(i1)
--       let n1 = synIDattr(i1, "name")
--       let n2 = synIDattr(i2, "name")
--       let n1Hi = trim(execute("highlight " . n1))
--       let n2Hi = trim(execute("highlight " . n2))
--       execute("highlight " . n1)
--       " if(n1Hi != n2Hi)
--          execute("highlight " . n2)
--       " endif
--       " echo n1 . "(" . n1Hi . ")" "->" n2 . "(" . n2Hi . ")"
--       " echo "(" . n1Hi . ") -> (" . n2Hi . ")"
--    endfor
--    execute("Inspect")
-- endfunction
--
--    print("hello!")
-- end


-- " unnecessary, just use :Inspect
-- " function! SynStack()
-- "   if !exists("*synstack")
-- "     return
-- "   endif
-- "   echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
-- " endfunc
-- "
-- " function! SynGroup()
-- "     let l:s = synID(line('.'), col('.'), 1)
-- "     echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
-- " endfun
--
-- function! SynStack()
--    echo "SynStack"
--    for i1 in synstack(line("."), col("."))
--       echo "HERE"
--       echo i1
--    endfor
--    for i1 in synstack(line("."), col("."))
--       let i2 = synIDtrans(i1)
--       let n1 = synIDattr(i1, "name")
--       let n2 = synIDattr(i2, "name")
--       let n1Hi = trim(execute("highlight " . n1))
--       let n2Hi = trim(execute("highlight " . n2))
--       echo n1 . "->" . n2
--       " echo n1 . "(" . n1Hi . ")" "->" n2 . "(" . n2Hi . ")"
--       " echo "(" . n1Hi . ") -> (" . n2Hi . ")"
--    endfor
--
--    for i1 in synstack(line("."), col("."))
--       let i2 = synIDtrans(i1)
--       let n1 = synIDattr(i1, "name")
--       let n2 = synIDattr(i2, "name")
--       let n1Hi = trim(execute("highlight " . n1))
--       let n2Hi = trim(execute("highlight " . n2))
--       execute("highlight " . n1)
--       " if(n1Hi != n2Hi)
--          execute("highlight " . n2)
--       " endif
--       " echo n1 . "(" . n1Hi . ")" "->" n2 . "(" . n2Hi . ")"
--       " echo "(" . n1Hi . ") -> (" . n2Hi . ")"
--    endfor
--    execute("Inspect")
-- endfunction
--
