
local function wrap_on()
   print("wrap: on")
   vim.opt_local.wrap = true
   vim.opt_local.linebreak = true
   vim.opt_local.list = false
   vim.opt_local.display:append("lastline")

   local opts = { buffer = true, silent = true }

   vim.keymap.set("n", "k", "gk", opts)
   vim.keymap.set("n", "j", "gj", opts)
   vim.keymap.set("n", "0", "g0", opts)

   vim.keymap.set("i", "<m-k>", "<C-o>gk", opts)
   vim.keymap.set("i", "<m-j>", "<C-o>gj", opts)
end

local function wrap_off()
   print("wrap: off")
   vim.opt_local.wrap = false

   for _, mode in ipairs({ "n", "i" }) do
      for _, key in ipairs({ "k", "j", "0", "<m-k>", "<m-j>" }) do
         pcall(vim.keymap.del, mode, key, { buffer = true })
      end
   end
end

_G.toggle_wrap = function()
   if vim.wo.wrap then wrap_off()
   else wrap_on() end
end

