local lib = require("mini.surround")

local lead = ";"

local surrounds = {
   -- Use balanced pair for brackets. Use opening ones to possibly
   -- replace/delete innder edge whitespace.
   ['('] = { input = { '%b()', '^.%s*().-()%s*.$' }, output = { left = '( ', right = ' )' } },
   [')'] = { input = { '%b()', '^.().*().$' },       output = { left = '(',  right = ')' } },
   ['['] = { input = { '%b[]', '^.%s*().-()%s*.$' }, output = { left = '[ ', right = ' ]' } },
   [']'] = { input = { '%b[]', '^.().*().$' },       output = { left = '[',  right = ']' } },
   ['{'] = { input = { '%b{}', '^.%s*().-()%s*.$' }, output = { left = '{ ', right = ' }' } },
   ['}'] = { input = { '%b{}', '^.().*().$' },       output = { left = '{',  right = '}' } },
   ['<'] = { input = { '%b<>', '^.%s*().-()%s*.$' }, output = { left = '< ', right = ' >' } },
   ['>'] = { input = { '%b<>', '^.().*().$' },       output = { left = '<',  right = '>' } },
   -- Derived from user prompt
   ['?'] = {
      input = function()
         local left = MiniSurround.user_input('Left surrounding')
         if left == nil or left == '' then return end
         local right = MiniSurround.user_input('Right surrounding')
         if right == nil or right == '' then return end

         return { vim.pesc(left) .. '().-()' .. vim.pesc(right) }
      end,
      output = function()
         local left = MiniSurround.user_input('Left surrounding')
         if left == nil then return end
         local right = MiniSurround.user_input('Right surrounding')
         if right == nil then return end
         return { left = left, right = right }
      end,
   },
   -- Brackets
   ['b'] = { input = { { '%b()', '%b[]', '%b{}' }, '^.().*().$' }, output = { left = '(', right = ')' } },
   -- Function call
   ['f'] = {
      input = { '%f[%w_%.][%w_%.]+%b()', '^.-%(().*()%)$' },
      output = function()
         local fun_name = MiniSurround.user_input('Function name')
         if fun_name == nil then return nil end
         return { left = ('%s('):format(fun_name), right = ')' }
      end,
   },
   -- Tag
   ['t'] = {
      input = { '<(%w-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
      output = function()
         local tag_full = MiniSurround.user_input('Tag')
         if tag_full == nil then return nil end
         local tag_name = tag_full:match('^%S*')
         return { left = '<' .. tag_full .. '>', right = '</' .. tag_name .. '>' }
      end,
   },
   -- Quotes
   ['q'] = { input = { { "'.-'", '".-"', '`.-`' }, '^.().*().$' }, output = { left = '"', right = '"' } },
}

lib.setup({
   -- Add custom surroundings to be used on top of builtin ones. For more
   -- information with examples, see `:h MiniSurround.config`.
   custom_surroundings = {
      ['p'] = surrounds[")"],
      ['x'] = surrounds["]"],
      ['b'] = surrounds["}"],
      ['m'] = surrounds["b"],
      ['q'] = { output = { left = '`', right = '`' } }
   },
   -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
   highlight_duration = 500,

   -- Module mappings. Use `''` (empty string) to disable one.
   mappings = {
      add = lead .. 's', -- Add surrounding in Normal and Visual modes
      delete = lead .. 'ds', -- Delete surrounding
      replace = lead .. 'cs', -- Replace surrounding
      find = '', -- Find surrounding (to the right)
      find_left = '', -- Find surrounding (to the left)
      highlight = '', -- Highlight surrounding
      update_n_lines = '', -- Update `n_lines`

      suffix_last = 'l', -- Suffix to search with "prev" method
      suffix_next = 'n', -- Suffix to search with "next" method
   },

   -- Number of lines within which surrounding is searched
   n_lines = 0,

   -- Whether to respect selection type:
   -- - Place surroundings on separate lines in linewise mode.
   -- - Place surroundings on each line in blockwise mode.
   respect_selection_type = false,

   -- How to search for surrounding (first inside current line, then inside
   -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
   -- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
   -- see `:h MiniSurround.config`.
   search_method = 'cover',

   -- Whether to disable showing non-error feedback
   -- This also affects (purely informational) helper messages shown after
   -- idle time if user input is required.
   silent = true,
})

vim.keymap.set('n', lead .. 'dsb', ";ds{", { remap = true })
vim.keymap.set('n', lead .. 'dsp', ";ds(", { remap = true })
vim.keymap.set('n', lead .. 'dsx', ";ds[", { remap = true })

