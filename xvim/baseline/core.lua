
-- don't need to be compatible with old vim
vim.opt.compatible = false

-- background buffers don't have to be saved
vim.opt.hidden = true

-- use persistent undos
-- vim.opt.undofile = true

-- no automatic eol
vim.opt.eol = false

-- enable yank to system clipboard
vim.opt.clipboard = "unnamed"
-- vim.opt.clipboard = "unnamedplus"

-- it's 2012 (well, it's 2025 now -- still a good choice)
vim.opt.encoding = "utf-8"

-- you know, set the history
vim.opt.history = 1000

-- intuitive backspacing in insert mode
vim.opt.backspace = { "indent", "eol", "start" }

-- don't use modelines
vim.opt.modeline = false

