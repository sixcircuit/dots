
local show_all = false

local s_dot = "·"
local m_dot = "∙"
local r_arrow = "▸"
local trail = m_dot
local tab = r_arrow .. s_dot
-- local tab = r_arrow .. r_arrow

local toggle_chars = "nbsp:∙,trail:" .. trail .. ",tab:" .. tab .. ",eol:¬,extends:›,precedes:‹"
local always_chars = "nbsp:∙,trail:" .. trail .. ",tab:" .. tab

vim.opt.list = true
vim.opt.listchars = always_chars

local toggle_listchars = function()
   show_all = not show_all
   if show_all then
      print("whitespace: on")
      vim.opt.listchars = toggle_chars
   else
      print("whitespace: off")
      vim.opt.listchars = always_chars
   end
end

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
   callback = function()
      if not show_all then
         vim.opt.list = false
      end
   end,
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
   callback = function()
      if not show_all then
         vim.opt.list = true
      end
   end,
})

-- vim.keymap.set('n', 's ', toggle_listchars, { desc = "toggle whitespace" })

