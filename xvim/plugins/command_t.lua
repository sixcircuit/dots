
commandt = require('wincent.commandt')

commandt.setup({
   -- height = 10000,
   -- position = top,
   -- order = "reverse"
   open = function(buffer, command)
      -- print("item: ", item)
      -- print("kind: ", kind)
      vim.cmd(command .. ' ' .. buffer)
      -- vim.cmd("call LayoutWindows()")

      -- this is the try to be smart function that fucks everything up.

      -- local open = function(buffer, command)
         --   buffer = vim.fn.fnameescape(buffer)
         --   local is_visible = require('wincent.commandt.private.buffer_visible')(buffer)
         --   if is_visible then
         --     -- In order to be useful, `:sbuffer` needs `vim.o.switchbuf = 'usetab'`.
         --     vim.cmd('sbuffer ' .. buffer)
         --   else
         --     vim.cmd(command .. ' ' .. buffer)
         --   end
         -- end
         --
         -- commandt.open(item, kind)
         -- vim.cmd.normal('call LayoutWindows()<CR>')
      -- end 
   end
})

