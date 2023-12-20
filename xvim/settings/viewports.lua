
vim.o.splitbelow = true
vim.o.splitright = true

-- TODO: refactor this.

-- vim.api.nvim_create_autocmd({"BufLeave", "BufDelete"}, {
--    callback = function()
--       vim.cmd(":layout_windows")
--    end
-- })

local function switch_to_window(win_index)
    vim.api.nvim_exec(win_index .. "wincmd w", false)
end

local function switch_to_next_window()
    vim.api.nvim_exec("wincmd w", false)
end

local function rotate_panes()
    vim.api.nvim_exec("wincmd r", false)
end

local function split_window()
    vim.api.nvim_exec('vs', false)
end

local function resize_current_window(size)
    vim.api.nvim_exec('vertical resize ' .. size, false)
end

local function resize_window(win_index, size)
    local cur_win = vim.api.nvim_get_current_win()
    switch_to_window(win_index)
    resize_current_window(size)
    vim.api.nvim_set_current_win(cur_win)
end

-- first split is math.ceil(columns * 0.29)
local function layout_windows()
    local cur_win = vim.api.nvim_get_current_win()
    local cur_win_width = vim.api.nvim_win_get_width(cur_win)
    local all_cols = vim.o.columns
    local panes = vim.fn.winnr('$')

    local first_split_small = 50
    local second_split_small = 85

    local first_split_big = 83  -- same as = on big screen (for 17 font size)

   -- local first_split_big = 93 " same as = on big screen (for 15 font size)
   -- local second_split_big = 100

   -- terminal windows - 10

    if all_cols <= 250 then
        if panes == 1 then
            split_window()
            switch_to_window(2)
            resize_window(1, first_split_small)

        elseif panes == 2 then
            resize_window(1, first_split_small)

        elseif panes == 3 then
            resize_window(1, first_split_small)
            resize_window(2, second_split_small)

        else
            vim.api.nvim_exec("wincmd =", false)
        end
    else  -- big screen
        if panes == 1 then
            split_window()
            switch_to_window(2)
            resize_window(1, first_split_big)

        elseif panes == 2 then
            resize_window(1, first_split_big)

        elseif panes == 3 then
            vim.api.nvim_exec("wincmd =", false)
         -- resize_window(1, first_split_big)
         -- resize_window(2, second_split_big)

        else
            vim.api.nvim_exec("wincmd =", false)
        end
    end
end

-- TODO: i'd like this to be smart and rotate till i'm at a new file.
-- i keep a, b, b open for the 3 column layout. and i'd like to switch between
-- a or b and stay in the center
local function rotate_windows_keep_cursor()
    local cur_win = vim.fn.winnr()
    local panes = vim.fn.winnr('$')

    -- if panes == 2
       rotate_panes()
       switch_to_window(cur_win)
    -- elseif panes == 3
    --    rotate_panes()
    --    rotate_panes()
    --    switch_to_window(cur_win)
    -- elseif panes == 4
    --    rotate_panes()
    --    rotate_panes()
    --    rotate_panes()
    --    switch_to_window(cur_win)
    -- end

    layout_windows()
end

_G.layout_windows = layout_windows
_G.rotate_windows_keep_cursor = rotate_windows_keep_cursor

-- Rotate Windows and Keep Cursor
vim.keymap.set('n', '<leader>r', rotate_windows_keep_cursor, { silent = true })

-- Resize windows with arrow keys
vim.keymap.set('n', '<down>', ':vertical resize -3<CR>', { silent = true })
vim.keymap.set('n', '<up>', ':vertical resize +3<CR>', { silent = true })
-- vim.keymap.set('n', '<left>', ':vertical resize 80<CR>', { silent = true })
vim.keymap.set('n', '\\', layout_windows, { silent = true })
-- vim.keymap.set('n', '\\', '<C-w>=', { silent = true })

-- Cycle between tabs: Ctrl-t forward, Ctrl-p backward
-- vim.keymap.set('n', '<C-t>', ':tabn<CR>', { silent = true })
-- vim.keymap.set('n', '<C-p>', ':tabp<CR>', { silent = true })

-- Tab navigation
vim.keymap.set('n', '<C-h>', ':tabp<CR>')
vim.keymap.set('n', '<C-l>', ':tabn<CR>')
vim.keymap.set('n', '<C-p>', ':tabm -1<CR>')
vim.keymap.set('n', '<C-t>', ':tabm +1<CR>')

-- scroll the viewport faster with ctrl-j and ctrl-k
vim.keymap.set('n', '<C-j>', '5<C-e>')
vim.keymap.set('n', '<C-k>', '5<C-y>')

-- navigate windows easily
vim.keymap.set('', '<C-n>', '<C-w>w')

