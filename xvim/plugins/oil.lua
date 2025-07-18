
local function get_win_col()
    local win = vim.api.nvim_get_current_win()  -- Get the current window
    local pos = vim.api.nvim_win_get_position(win)  -- Get window position
    return pos[2]
end

local function get_win_width()
    local win = vim.api.nvim_get_current_win()  -- Get the current window
    local pos = vim.api.nvim_win_get_width(win)  -- Get window position
    return pos
end

require("oil").setup({
  -- -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
  -- -- Set to false if you still want to use netrw.
  -- default_file_explorer = true,
  -- -- Id is automatically added at the beginning, and name at the end
  -- -- See :help oil-columns
  -- columns = {
  --   "icon",
  --   -- "permissions",
  --   -- "size",
  --   -- "mtime",
  -- },
  -- -- Buffer-local options to use for oil buffers
  -- buf_options = {
  --   buflisted = false,
  --   bufhidden = "hide",
  -- },
  -- -- Window-local options to use for oil buffers
  -- win_options = {
  --   wrap = false,
  --   signcolumn = "no",
  --   cursorcolumn = false,
  --   foldcolumn = "0",
  --   spell = false,
  --   list = false,
  --   conceallevel = 3,
  --   concealcursor = "nvic",
  -- },
  -- -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
  -- delete_to_trash = false,
  -- -- Skip the confirmation popup for simple operations
  -- skip_confirm_for_simple_edits = false,
  -- -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
  -- prompt_save_on_select_new_entry = true,
  -- -- Oil will automatically delete hidden buffers after this delay
  -- -- You can set the delay to false to disable cleanup entirely
  -- -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
  -- cleanup_delay_ms = 2000,
  -- -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
  -- -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
  -- -- Additionally, if it is a string that matches "actions.<name>",
  -- -- it will use the mapping at require("oil.actions").<name>
  -- -- Set to `false` to remove a keymap
  -- -- See :help oil-actions for a list of all available actions
  use_default_keymaps = true,
  keymaps = {
    -- ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    -- ["<C-s>"] = "actions.select_vsplit",
    -- ["<C-h>"] = "actions.select_split",
    -- ["<C-t>"] = "actions.select_tab",
    -- ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    -- ["<C-l>"] = "actions.refresh",
    ["<m-k>"] = "actions.parent",
    ["<m-h>"] = "actions.open_cwd",
    -- ["`"] = "actions.cd",
    -- ["~"] = "actions.tcd",
    -- ["gs"] = "actions.change_sort",
    -- ["gx"] = "actions.open_external",
    ["s."] = "actions.toggle_hidden",
    -- ["g\\"] = "actions.toggle_trash",
  },
  -- view_options = {
  --   -- Show files and directories that start with "."
  --   show_hidden = false,
  --   -- This function defines what is considered a "hidden" file
  --   is_hidden_file = function(name, bufnr)
  --     return vim.startswith(name, ".")
  --   end,
  --   -- This function defines what will never be shown, even when `show_hidden` is set
  --   is_always_hidden = function(name, bufnr)
  --     return false
  --   end,
  --   sort = {
  --     -- sort order can be "asc" or "desc"
  --     -- see :help oil-columns to see which columns are sortable
  --     { "type", "asc" },
  --     { "name", "asc" },
  --   },
  -- },
  -- -- Configuration for the floating window in oil.open_float
  float = {
     -- Padding around the floating window
     padding = 2,
     max_width = 0,
     max_height = 0,
     border = "rounded",
     win_options = {
        winblend = 0,
     },
     -- This is the config that will be passed to nvim_open_win.
     -- Change values here to customize the layout
     override = function(conf)
        conf.width = math.max(get_win_width(), 60)
        local col = get_win_col()
        if col > 80 then col = 0 end
        conf.col = col
        return conf
     end,
  },
  -- -- Configuration for the actions floating preview window
  -- preview = {
  --   -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
  --   -- min_width and max_width can be a single value or a list of mixed integer/float types.
  --   -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
  --   max_width = 0.9,
  --   -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
  --   min_width = { 40, 0.4 },
  --   -- optionally define an integer/float for the exact width of the preview window
  --   width = nil,
  --   -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
  --   -- min_height and max_height can be a single value or a list of mixed integer/float types.
  --   -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
  --   max_height = 0.9,
  --   -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
  --   min_height = { 5, 0.1 },
  --   -- optionally define an integer/float for the exact height of the preview window
  --   height = nil,
  --   border = "rounded",
  --   win_options = {
  --     winblend = 0,
  --   },
  -- },
  -- -- Configuration for the floating progress window
  -- progress = {
  --   max_width = 0.9,
  --   min_width = { 40, 0.4 },
  --   width = nil,
  --   max_height = { 10, 0.9 },
  --   min_height = { 5, 0.1 },
  --   height = nil,
  --   border = "rounded",
  --   minimized_border = "none",
  --   win_options = {
  --     winblend = 0,
  --   },
  -- },
})
