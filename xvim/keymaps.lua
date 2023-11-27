
local function rg_and_open_first()
   local status, search_term = pcall(vim.fn.input, 'rg/')
   if not status then
      return
   end
   vim.cmd('Rg ' .. search_term)
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

local function toggle_quickfix()
    local windows = vim.fn.getwininfo()
    local quickfix_open = false

    for _, win in pairs(windows) do
        if win.quickfix == 1 then
            quickfix_open = true
            break
        end
    end

    if quickfix_open then
        vim.cmd('cclose')
    else
        vim.cmd('copen')
    end
end

vim.keymap.set('n', '[f', cprev_rollover)
vim.keymap.set('n', ']f', cnext_rollover)

vim.keymap.set('n', 's', "<nop>")
vim.keymap.set('n', 's;', ":w<CR>")
vim.keymap.set('n', 'sq', toggle_quickfix)
vim.keymap.set('n', 'sp', cprev_rollover)
vim.keymap.set('n', 'sn', cnext_rollover)

-- vim.api.nvim_set_keymap('n', '<CR>', ':w<CR>', { noremap = true, silent = false })

-- vim.api.nvim_set_keymap('n', '<leader>o', ':CommandTRipgrep<cr>', { noremap = true, silent = true })

-- easy macro
vim.keymap.set('', ',,', "@@")

vim.keymap.set({ "n", "i" }, '<C-q>', '<cmd>quitall<cr>')

-- CommandT excludes no files, CommandTFind excludes some files. see the code in command-t.lua
vim.keymap.set('n', '<leader>o', ':CommandTFind<cr>')
vim.keymap.set('n', '<leader>l', ':CommandT<cr>')
-- vim.keymap.set('n', '<leader>o', ':CommandTBuffer<cr>')

local function fuzzy_search()
   vim.g.fuzzysearch_prompt = 'fz/'
   local status, err = pcall(vim.fn['fuzzysearch#start_search'])
   if not status then
      vim.print("")
   end
end

vim.keymap.set("n", "-", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

vim.keymap.set('', '/', "<nop>")

-- this only works because i have <c-/> mapped to $ in carabiner
vim.keymap.set({ 'n', 'v' }, '$', "/")

vim.keymap.set('', '/', fuzzy_search)
vim.keymap.set('n', 'sf', rg_and_open_first)
vim.keymap.set('', 'sr', ':%s///g<left><left>')

-- " clear search highlighting
vim.keymap.set('', '<leader>/', ":noh<cr>")

vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
-- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
-- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

-- vim.keymap.set('n', 'sh', jump_into_hover_window, opts)
vim.keymap.set('n', 'crn', vim.lsp.buf.rename, opts)

local function toggle_virtual_text()
   local current_state = vim.diagnostic.config().virtual_text
   vim.g.diagnostics_visible = true
   vim.diagnostic.config({ virtual_text = not current_state })
end

local function toggle_diagnostics()
   if vim.g.diagnostics_visible == nil or vim.g.diagnostics_visible == false then
      vim.diagnostic.show()
      vim.g.diagnostics_visible = true
   else
      vim.diagnostic.hide()
      vim.g.diagnostics_visible = false
   end
end

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', 'sl', toggle_virtual_text)
-- vim.keymap.set('n', 'sd', toggle_diagnostics)
vim.keymap.set('n', 'si', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', 'sdd', vim.diagnostic.setloclist)

local function show_hover()
   local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })

   if #diagnostics > 0 then
      vim.diagnostic.open_float(nil, { focusable = false, scope = "line" })
   else
      vim.lsp.buf.hover()
   end
end

vim.keymap.set('n', 'sh', show_hover)

local function jump_into_hover_window()
   vim.lsp.buf.hover()
   vim.lsp.buf.hover()
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions

    local opts = { buffer = ev.buf }


    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)

    -- vim.keymap.set('n', 'sh', jump_into_hover_window, opts)
    vim.keymap.set('n', 'crn', vim.lsp.buf.rename, opts)

    -- can't use w slows down easymotions
    -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    -- vim.keymap.set('n', '<leader>wl', function()
      -- print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, opts)
    -- vim.keymap.set('n', 'gD', vim.lsp.buf.type_definition, opts)
    -- can't use "r" as first letter. slows swap
    -- can't use "c" as first letter. slows comment
    -- vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    -- vim.keymap.set('n', '<leader>f', function()
    --   vim.lsp.buf.format { async = true }
    -- end, opts)
  end,
})

