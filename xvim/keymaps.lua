
local function rg_and_open_first()
   -- local search_term = vim.fn.input('rg/')
   local status, search_term = pcall(vim.fn.input, 'rg/')
   if not status then
      return
   end
   vim.cmd('Rg ' .. search_term)
   -- vim.cmd('copen')
   vim.cmd('cc 1')
end

local function cmove_with_rollover(direction)
   local quickfix_list = vim.fn.getqflist()
   local current_idx = vim.fn.getqflist({idx = 0}).idx

   if #quickfix_list == 0 then
      return
   end

   if direction == "next" then
      if current_idx >= #quickfix_list then
         vim.cmd('cfirst')
      else
         vim.cmd('cnext')
      end
   elseif direction == "prev" then
      if current_idx <= 1 then
         vim.cmd('clast')
      else
         vim.cmd('cprev')
      end
   else
      error("Invalid direction. Use 'next' or 'prev'.")
   end
end

local function cnext_rollover() cmove_with_rollover("next") end

local function cprev_rollover() cmove_with_rollover("prev") end

-- vim.api.nvim_set_keymap('n', '<leader>m', '<cmd>lua rg_and_open_first()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '?', rg_and_open_first)
-- vim.keymap.set('n', '<C-b>', rg_and_open_first, { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-b>', ':cnext<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-b>', ':cnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-[>', cprev_rollover)
vim.keymap.set('n', '<c-]>', cnext_rollover)

-- vim.api.nvim_set_keymap('n', '<CR>', ':w<CR>', { noremap = true, silent = false })

-- vim.api.nvim_set_keymap('n', '<leader>o', ':CommandTRipgrep<cr>', { noremap = true, silent = true })

vim.keymap.set('n', '<C-q>', ':quitall<cr>')

-- CommandT excludes no files, CommandTFind excludes some files. see the code in command-t.lua
vim.keymap.set('n', '<leader>o', ':CommandTFind<cr>')
vim.keymap.set('n', '<leader>l', ':CommandT<cr>')
-- vim.keymap.set('n', '<leader>o', ':CommandTBuffer<cr>')

local function fuzzy_search()
   -- vim.g.fuzzysearch_hlsearch = 0
   -- vim.g.fuzzysearch_ignorecase = 1
   -- vim.g.fuzzysearch_max_history = 30
   -- vim.g.fuzzysearch_match_spaces = 1
   vim.g.fuzzysearch_prompt = 'fz/'
   vim.fn['fuzzysearch#start_search']()
end

vim.keymap.set('', '/', "<nop>")
vim.keymap.set('', '/f', fuzzy_search)
-- vim.keymap.set('', '/f', ":call DoFuzzySearch()<cr>")
vim.keymap.set('', '//', "/")
vim.keymap.set('', '/r', ':%s///g<left><left>')
-- vim.keymap.set('', '/f', ':%s///g<left><left>')

-- " clear search highlighting
vim.keymap.set('', '<leader>/', ":noh<cr>")

