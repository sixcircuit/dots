local hop = require('hop')
local jump_regex = require('hop.jump_regex')

hop.setup {
   x_bias = 100,
   -- keys = 'etovxqpdygfblzhckisuran',
   -- keys = 'asdfghjkl;qwertyuiopvbcnxmz,',
   keys = 'abcdefghijklmnopqrstuvwxyz;',
   -- keys = 'abcdefghijklmnopqrstuvwxyz;',
   jump_on_sole_occurrence = true,
   create_hl_autocmd = false,
}

local function hop_to_chars(chars)
   assert(chars ~= nil)
   local opts = hop.opts
   hop.hint_with_regex(jump_regex.regex_by_case_searching(chars, true, opts), opts)
end

local function run_keys(keys)
   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", false)
end

local function hop_paste_inside(chars)
   assert(chars ~= nil)
   local opts = hop.opts
   hop.hint_with_regex(jump_regex.regex_by_case_searching(chars, true, opts), opts)
   run_keys('vi' .. chars .. "p")
end

local function hop_yank_inside(chars)
   assert(chars ~= nil)
   local opts = hop.opts
   hop.hint_with_regex(jump_regex.regex_by_case_searching(chars, true, opts), opts)
   run_keys('vi' .. chars .. "y")
end


local function hop_to_chars_f(chars)
   return function() hop_to_chars(chars) end
end

local function hop_paste_inside_f(chars)
   return function() hop_paste_inside(chars) end
end

local function hop_yank_inside_f(chars)
   return function() hop_yank_inside(chars) end
end

vim.keymap.set('n', 'mm', 'm')

-- vim.keymap.set('', '<leader>w', "<cmd>HopWord<cr>")
vim.keymap.set('', 'ma', "<cmd>HopAnywhere<cr>")
vim.keymap.set('', 'mf', "<cmd>HopWordCurrentLineAC<cr>")
vim.keymap.set('', 'mf', "<cmd>HopAnywhereCurrentLineAC<cr>")

vim.keymap.set('', 'mw', "<cmd>HopWordAC<cr>")
vim.keymap.set('', '<leader>w', "<cmd>HopWordAC<cr>")

vim.keymap.set('', 'mb', "<cmd>HopWordBC<cr>")
vim.keymap.set('', '<leader>b', "<cmd>HopWordBC<cr>")

vim.keymap.set('', 'mj', "<cmd>HopLineAC<cr>")
vim.keymap.set('', '<leader>j', "<cmd>HopLineAC<cr>")

vim.keymap.set('', 'mk', "<cmd>HopLineBC<cr>")
vim.keymap.set('', '<leader>k', "<cmd>HopLineBC<cr>")

vim.keymap.set('', 'mc', "<cmd>HopChar1<cr>")
vim.keymap.set('', 'mlc', "<cmd>HopChar1CurrentLineAC<cr>")
vim.keymap.set('', 'mla', "<cmd>HopAnywhereCurrentLineAC<cr>")
vim.keymap.set('', 'ms', "<cmd>HopCamelCase<cr>")

vim.keymap.set('', 'mpp', "<cmd>HopPasteChar1<cr>")

vim.keymap.set('', 'm/', "<cmd>HopPatternAC<cr>")
vim.keymap.set('', 'm?', "<cmd>HopPatternBC<cr>")

vim.keymap.set('', 'mpi"', hop_paste_inside_f('"'))
vim.keymap.set('', 'mpi\'', hop_paste_inside_f("'"))
vim.keymap.set('', 'mpi(', hop_paste_inside_f("("))
vim.keymap.set('', 'myi"', hop_yank_inside_f('"'))
vim.keymap.set('', 'myi\'', hop_yank_inside_f("'"))
vim.keymap.set('', 'myi(', hop_yank_inside_f('('))


vim.keymap.set('', 'm<', hop_to_chars_f('<'))
vim.keymap.set('', 'm>', hop_to_chars_f('>'))
vim.keymap.set('', 'm{', hop_to_chars_f('{'))
vim.keymap.set('', 'm}', hop_to_chars_f('}'))
vim.keymap.set('', 'm[', hop_to_chars_f('['))
vim.keymap.set('', 'm]', hop_to_chars_f(']'))
vim.keymap.set('', 'm(', hop_to_chars_f('('))
vim.keymap.set('', 'm)', hop_to_chars_f(')'))
vim.keymap.set('', 'm-', hop_to_chars_f('-'))
vim.keymap.set('', 'm"', hop_to_chars_f('"'))
vim.keymap.set('', 'm\'', hop_to_chars_f("'"))
vim.keymap.set('', 'm,', hop_to_chars_f(","))
vim.keymap.set('', 'm;', hop_to_chars_f(";"))
vim.keymap.set('', 'm|', hop_to_chars_f("|"))
vim.keymap.set('', 'm&', hop_to_chars_f("&"))
vim.keymap.set('', 'm ', hop_to_chars_f(" "))



-- local hr = require('hop_repeat')
-- hr.setup()

-- vim.keymap.set('', 'mrc', hr.hint_char1)

-- vim.keymap.set('', '<leader>w', ":HopWordAC<cr>")
-- vim.keymap.set('', '<leader>b', ":HopWordBC<cr>")
-- vim.keymap.set('', '<leader>k', ":HopChar1<cr>")
-- vim.keymap.set('', '<leader>s', ":HopCamelCase<cr>")
-- vim.keymap.set('', '<leader>a', ":HopCamelCase<cr>")
-- vim.keymap.set('', '<leader>p', ":HopPasteChar1<cr>")

-- map <Leader>w <Plug>(easymotion-w)
-- map <Leader>b <Plug>(easymotion-b)
--
-- " JK motions: Line motions
-- map <Leader>j <Plug>(easymotion-j)
-- map <Leader>k <Plug>(easymotion-k)
--
-- map <Leader>s <Plug>(easymotion-jumptoanywhere) -- should be camelcase

-- " Jump to anywhere you want with minimal keystrokes, with just one key binding.
-- " `s{char}{label}`
-- " nmap s <Plug>(easymotion-s)
--
-- " `s{char}{char}{label}`
-- " Need one more keystroke, but on average, it may be more comfortable.
-- " nmap s <Plug>(easymotion-s2)
--
-- " map <Leader>l <Plug>(easymotion-special-l)
-- " map <Leader>p <Plug>(easymotion-special-p)
--
--
-- " map <Leader>w <Plug>(easymotion-jumptoanywhere)
-- " map <Leader>w <Plug>(easymotion-jumptoanywhere)
-- " map <Leader>cc <Plug>(easymotion-jumptoanywhere)
-- " i would need to change the next one, because it slows down regular /
-- " map // <Plug>(easymotion-sn)
--


-- local directions = require('hop.hint').HintDirection
-- vim.keymap.set('', 'f', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
-- end, {remap=true})
-- vim.keymap.set('', 'F', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
-- end, {remap=true})
-- vim.keymap.set('', 't', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
-- end, {remap=true})
-- vim.keymap.set('', 'T', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
-- end, {remap=true})
--
