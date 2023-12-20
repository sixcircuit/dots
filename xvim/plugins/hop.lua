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

local function hop_to_chars(chars, hint_offset, is_regex)
   assert(chars ~= nil)
   local opts = hop.opts
   opts.hint_offset = hint_offset
   hop.hint_with_regex(jump_regex.regex_by_case_searching(chars, (not is_regex), opts), opts)
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


local function f_to_chars_f(chars, is_regex)
   return function() hop_to_chars(chars, 0, is_regex) end
end

local function t_to_chars_f(chars, is_regex)
   return function() hop_to_chars(chars, -1, is_regex) end
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

vim.keymap.set('', 'mw', "<cmd>HopWordAC<cr>")
vim.keymap.set('', '<leader>w', "<cmd>HopWordAC<cr>")

vim.keymap.set('', 'mb', "<cmd>HopWordBC<cr>")
vim.keymap.set('', '<leader>b', "<cmd>HopWordBC<cr>")

vim.keymap.set('', 'mj', "<cmd>HopLineAC<cr>")
vim.keymap.set('', '<leader>j', "<cmd>HopLineAC<cr>")

vim.keymap.set('', 'mk', "<cmd>HopLineBC<cr>")
vim.keymap.set('', '<leader>k', "<cmd>HopLineBC<cr>")

vim.keymap.set('', 'mc', "<cmd>HopChar1<cr>")

vim.keymap.set('', 'mlw', "<cmd>HopWordCurrentLineAC<cr>")
vim.keymap.set('', 'mlc', "<cmd>HopChar1CurrentLineAC<cr>")
vim.keymap.set('', 'mla', "<cmd>HopAnywhereCurrentLineAC<cr>")
vim.keymap.set('', 'mll', "<cmd>HopAnywhereCurrentLineAC<cr>")
vim.keymap.set('', 'mls', "<cmd>HopCamelCaseCurrentLineAC<cr>")
vim.keymap.set('', 'ms', "<cmd>HopCamelCase<cr>")

vim.keymap.set('', 'mpp', "<cmd>HopPasteChar1<cr>")

vim.keymap.set('', 'm/', "<cmd>HopPatternAC<cr>")
vim.keymap.set('', 'm?', "<cmd>HopPatternBC<cr>")

vim.keymap.set('', 'mpi"', hop_paste_inside_f('"'))
vim.keymap.set('', 'mpi`', hop_paste_inside_f('`'))
vim.keymap.set('', 'mpi\'', hop_paste_inside_f("'"))
vim.keymap.set('', 'mpi(', hop_paste_inside_f("("))
vim.keymap.set('', 'myi"', hop_yank_inside_f('"'))
vim.keymap.set('', 'myi\'', hop_yank_inside_f("'"))
vim.keymap.set('', 'myi`', hop_yank_inside_f("`"))
vim.keymap.set('', 'myi(', hop_yank_inside_f('('))


vim.keymap.set('', 'm<', f_to_chars_f('<'))
vim.keymap.set('', 'm>', f_to_chars_f('>'))
vim.keymap.set('', 'm{', f_to_chars_f('{'))
vim.keymap.set('', 'm}', f_to_chars_f('}'))
vim.keymap.set('', 'm[', f_to_chars_f('['))
vim.keymap.set('', 'm]', f_to_chars_f(']'))
vim.keymap.set('', 'm(', f_to_chars_f('('))
vim.keymap.set('', 'm)', f_to_chars_f(')'))
vim.keymap.set('', 'm-', f_to_chars_f('-'))
vim.keymap.set('', 'm"', f_to_chars_f('"'))
vim.keymap.set('', 'm\'', f_to_chars_f("'"))
vim.keymap.set('', 'm`', f_to_chars_f("`"))
vim.keymap.set('', 'm,', f_to_chars_f(","))
vim.keymap.set('', 'm;', f_to_chars_f(";"))
vim.keymap.set('', 'm|', f_to_chars_f("|"))
vim.keymap.set('', 'm&', f_to_chars_f("&"))
vim.keymap.set('', 'm:', f_to_chars_f(":"))
-- vim.keymap.set('', 'm ', f_to_chars_f(" "))
-- match all spaces that aren't at the start of a line
vim.keymap.set('', 'm ', f_to_chars_f("\\S\\zs \\+", true))

vim.keymap.set('', 'mf<', f_to_chars_f('<'))
vim.keymap.set('', 'mf>', f_to_chars_f('>'))
vim.keymap.set('', 'mf{', f_to_chars_f('{'))
vim.keymap.set('', 'mf}', f_to_chars_f('}'))
vim.keymap.set('', 'mf[', f_to_chars_f('['))
vim.keymap.set('', 'mf]', f_to_chars_f(']'))
vim.keymap.set('', 'mf(', f_to_chars_f('('))
vim.keymap.set('', 'mf)', f_to_chars_f(')'))
vim.keymap.set('', 'mf-', f_to_chars_f('-'))
vim.keymap.set('', 'mf"', f_to_chars_f('"'))
vim.keymap.set('', 'mf`', f_to_chars_f('`'))
vim.keymap.set('', 'mf\'', f_to_chars_f("'"))
vim.keymap.set('', 'mf,', f_to_chars_f(","))
vim.keymap.set('', 'mf;', f_to_chars_f(";"))
vim.keymap.set('', 'mf|', f_to_chars_f("|"))
vim.keymap.set('', 'mf&', f_to_chars_f("&"))
vim.keymap.set('', 'mf:', f_to_chars_f(":"))
-- vim.keymap.set('', 'mf ', f_to_chars_f(" "))
-- match all spaces that aren't at the start of a line
vim.keymap.set('', 'mf ', f_to_chars_f("\\S\\zs \\+", true))

vim.keymap.set('', 'mt<', t_to_chars_f('<'))
vim.keymap.set('', 'mt>', t_to_chars_f('>'))
vim.keymap.set('', 'mt{', t_to_chars_f('{'))
vim.keymap.set('', 'mt}', t_to_chars_f('}'))
vim.keymap.set('', 'mt[', t_to_chars_f('['))
vim.keymap.set('', 'mt]', t_to_chars_f(']'))
vim.keymap.set('', 'mt(', t_to_chars_f('('))
vim.keymap.set('', 'mt)', t_to_chars_f(')'))
vim.keymap.set('', 'mt-', t_to_chars_f('-'))
vim.keymap.set('', 'mt"', t_to_chars_f('"'))
vim.keymap.set('', 'mt`', t_to_chars_f('`'))
vim.keymap.set('', 'mt\'', t_to_chars_f("'"))
vim.keymap.set('', 'mt,', t_to_chars_f(","))
vim.keymap.set('', 'mt;', t_to_chars_f(";"))
vim.keymap.set('', 'mt|', t_to_chars_f("|"))
vim.keymap.set('', 'mt&', t_to_chars_f("&"))
-- vim.keymap.set('', 'mt ', t_to_chars_f(" "))
-- match all spaces that aren't at the start of a line
vim.keymap.set('', 'mt ', t_to_chars_f("\\S\\zs \\+", true))
vim.keymap.set('', 'mt:', t_to_chars_f(":"))

-- local hr = require('hop_repeat')
-- hr.setup()

-- vim.keymap.set('', 'mrc', hr.hint_char1)

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
