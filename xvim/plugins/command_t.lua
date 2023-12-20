
local commandt = require('wincent.commandt')

local find_ignore_dir = {".git", "node_modules"}
local find_ignore_file = {"*.o", "*.obj"}
-- find_ignore_dir = {}
-- find_ignore_file = {}

-- max_files = -1
local max_files = 100000

local function open_file_in_tab_or_switch(filename)
   local full_path = vim.fn.getcwd() .. '/' .. filename

   local buffers = vim.api.nvim_list_bufs()
   for _, buf in ipairs(buffers) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) == full_path then
         -- Check if the buffer is visible in any window
         for _, win in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win) == buf then
               -- Switch to the tabpage containing the window
               local tabpage = vim.api.nvim_win_get_tabpage(win)
               vim.api.nvim_set_current_tabpage(tabpage)
               -- Switch to the window displaying the buffer
               vim.api.nvim_set_current_win(win)
               return
            end
         end
         -- If the buffer is loaded but not displayed in any window, open it in a new tab
         vim.cmd('tabnew ' .. filename)
         return
      end
   end

   -- If the file is not open in any buffer, open it in a new tab
   vim.cmd('tabnew ' .. filename)
end

local open = function(buffer, command)
   if command == "edit" then
      open_file_in_tab_or_switch(buffer)
   else
      if command == "split" then command = "edit" end
      vim.cmd(command .. ' ' .. buffer)
   end
   layout_windows()
end

commandt.setup({
   -- height = 10000,
   -- position = 'top',
   margin = 35,
   position = 'center',
   -- position = 'bottom',
   -- order = "reverse"
   ignore_case = true,
   -- always_show_dot_files = true,
   open = open,
   scanners = {
      file = { max_files = max_files, },
      find = { max_files = max_files, },
      git = { max_files = max_files, },
      rg = { max_files = max_files, },
   },
   mappings = {
      i = {
         ['<C-r>'] = 'open_split',
      },
      n = {
         ['<C-r>'] = 'open_split',
      },
   },
   finders = {
      buffer = {
         open = open
      },
      find = {
         open = open,
         -- max_depth = 100,
         command = function(directory)
            if vim.startswith(directory, './') then
               directory = directory:sub(3, -1)
            end
            if directory ~= '' and directory ~= '.' then
               directory = vim.fn.shellescape(directory)
            end
            local drop = 0
            if directory == '' or directory == '.' then
               -- Drop 2 characters because `find` will prefix every result with "./",
               -- making it look like a dotfile.
               directory = '.'
               drop = 2
               -- TODO: decide what to do if somebody passes '..' or similar, because that
               -- will also make the results get filtered out as though they were dotfiles.
               -- I may end up needing to do some fancy, separate micromanagement of
               -- prefixes and let the matcher operate on paths without prefixes.
            end
            -- TODO: support max depth, dot directory filter etc

            -- local command = 'find -L ' .. directory .. ' -type f -print0 2> /dev/null'
            -- local command = find -L . -not \( -path "*/node_modules/*" -prune \) -not \( -path "*/.git/*" -prune \) -type f

            local command = 'find -L ' .. directory

            for _, dir_name in ipairs(find_ignore_dir) do
               command = command .. ' -not \\( -path "*/' .. dir_name .. '/*" -prune \\)'
            end

            for _, file_name in ipairs(find_ignore_file) do
               command = command .. ' -not \\( -path "*/' .. file_name .. '" -prune \\)'
            end

            command = command .. ' -type f -print0 2> /dev/null'
            -- command = command .. ' -type f -print0' 

            -- local head = "head"

            -- if jit.os == "OSX" then
            --    head = "ghead"
            -- end

            -- if find_max_files > 0 then
            --    command = command .. " | " .. head .. " -z -n " .. find_max_files
            --    command = command .. ' 2> /dev/null'
            -- end

            -- print("command: " .. command)

            return command, drop
         end,
         fallback = true,
      },
      rg = {
         open = open,
         command = function(directory)
            if vim.startswith(directory, './') then
               directory = directory:sub(3, -1)
            end
            if directory ~= '' and directory ~= '.' then
               directory = vim.fn.shellescape(directory)
            end
            local drop = 0
            if directory == '.' then
               drop = 2
            end
            local command = 'rg --files --hidden --null'
            if #directory > 0 then
               command = command .. ' ' .. directory
            end
            command = command .. ' 2> /dev/null'
            return command, drop
         end,
         fallback = false,
      }
   }
})

