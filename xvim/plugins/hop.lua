local hop = require('hop')

hop.setup {
   -- keys = 'etovxqpdygfblzhckisuran',
   -- keys = 'asdfghjkl;qwertyuiopvbcnxmz,',
   keys = 'abcdefghijklmnopqrstuvwxyz;',
   jump_on_sole_occurrence = true,
   create_hl_autocmd = false,
}

-- vim.keymap.set('', '<leader>w', ":HopWord<cr>")
vim.keymap.set('', 'ff', ":HopAnywhere<cr>")
vim.keymap.set('', 'fl', ":HopWordAC<cr>")
vim.keymap.set('', 'fh', ":HopWordBC<cr>")
vim.keymap.set('', 'fw', ":HopWordAC<cr>")
vim.keymap.set('', 'fb', ":HopWordBC<cr>")
vim.keymap.set('', 'fk', ":HopLineStartBC<cr>")
vim.keymap.set('', 'fj', ":HopLineStartAC<cr>")
vim.keymap.set('', 'fc', ":HopChar1<cr>")
vim.keymap.set('', 'fs', ":HopCamelCase<cr>")
vim.keymap.set('', 'fp', ":HopPasteChar1<cr>")
-- vim.keymap.set('', 'f/', ":Pounce<cr>")
-- vim.keymap.set('', '<leader>f', "<Plug>(incsearch-fuzzy-?)")
-- vim.keymap.set('', '/', "<Plug>(incsearch-fuzzy-/)")
-- vim.keymap.set('', '?', "/")

-- " use standard regexes, not vim regexes
-- nnoremap / /\v
-- vnoremap / /\v

-- " clear search highlighting
vim.keymap.set('', '<leader>/', ":noh<cr>")


-- map ? <Plug>(incsearch-fuzzy-/)
-- " map ? <Plug>(incsearch-fuzzy-?)
-- " map zg/ <Plug>(incsearch-fuzzy-stay)
--
-- nmap s <cmd>Pounce<CR>
-- nmap S <cmd>PounceRepeat<CR>
-- xmap s <cmd>Pounce<CR>
-- omap gs <cmd>Pounce<CR>  " 's' is used by vim-surround
-- nmap S :Pounce <C-r>/<cr> " note: if you want to use <C-r> you cannot use <cmd>

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
