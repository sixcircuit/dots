
local function rg_and_open_first()
   local search_term = vim.fn.input('rg/')
   vim.cmd('Rg ' .. search_term)
   -- vim.cmd('copen')
   vim.cmd('cc 1')
end

local function cnext_with_rollover()
   local quickfix_list = vim.fn.getqflist()
   local current_idx = vim.fn.getqflist({idx = 0}).idx
   if #quickfix_list == 0 then
      return
   end
   if current_idx >= #quickfix_list then
      vim.cmd('cfirst')
   else
      vim.cmd('cnext')
   end
end

-- vim.api.nvim_set_keymap('n', '<leader>m', '<cmd>lua rg_and_open_first()<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '?', rg_and_open_first, { noremap = true, silent = true })
-- vim.keymap.set('n', '<C-b>', rg_and_open_first, { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-b>', ':cnext<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<C-b>', ':cnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<c-]>', cnext_with_rollover, { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<CR>', ':w<CR>', { noremap = true, silent = false })

