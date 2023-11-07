
local function syn_stack()
   local tbl = vim.inspect_pos()
   vim.print(tbl)

   local str = ""

   print("syntax")
   if(tbl.syntax[0] ~= nil) then
      for k,v in pairs(tbl.syntax[0]) do
         print(k, v)
      end
   end

   print("treesitter")
   if(tbl.treesitter[0] ~= nil) then
      for k,v in pairs(tbl.treesitter[0]) do
         print(k, v)
      end
   end

   print("lsp")
   if(tbl.semantic_tokens[0] ~= nil) then
      for k,v in pairs(tbl.semantic_tokens[0]) do
        print(k, v)
      end
   end
end

vim.keymap.set("n", "<C-i>", syn_stack, { noremap=true })

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
