
local function disable_all_highlight_groups()
   -- Retrieve list of all highlight groups
   local highlight_groups = vim.api.nvim_get_hl(0, { link = true })

   -- Iterate and disable each group
   for group, info in pairs(highlight_groups) do
      if not info.link then
         -- vim.print(group)
         -- vim.print(info)
      end
      if not info.link then
         vim.api.nvim_set_hl(0, group, {})
      end
      -- vim.api.nvim_set_hl(0, group, {})
   end
end

-- disable_all_highlight_groups()


local link = {}

link.norm = { link = "Normal" }

local color = {}

color.gray = {
   lll = { term = 233, gui = "#121212" },
   ll = { term = 235, gui = "#262626" },
   l  = { term = 237, gui = "#3a3a3a" },
   ml = { term = 241, gui = "#626262" },
   m  = { term = 245, gui = "#8a8a8a" },
   mh = { term = 247, gui = "#9e9e9e" },
   h  = { term = 249, gui = "#b2b2b2" },
   hh = { term = 251, gui = "#c6c6c6" },
}

color.bg = {
   term = 16,
   gui = "#000000"
}

color.fg = color.gray.mh

color.gold = {
   term = 136,
   gui = "#af8700",
   h = {
      term = 178,
      gui = "#d7af00"
   },
   l = {
      term = 94,
      -- gui = "#d7af00"
   }
}

color.blue = {
   term = 33,
   gui = "#0087ff"
}

color.purple = {
   term = 56,
   gui = "#5f00d7"
}

color.cyan = {
   term = 37,
   gui = "#00afaf"
}

color.green = {
   term = 64,
   gui = "#5f8700",
   h = {
      term = 28,
      gui = "#00af00"
   }
   -- hh = {
   --    term = 34,
   --    gui = "#00af00"
   -- }
   -- hh = {
   --    term = 35,
   --    gui = "#00af5f"
   -- }
}

color.orange = {
   term = 166,
   gui = "#d75f00",
   l = {
      term = 130,
      gui = "#af5f00"
   }
}

color.red = {
   term = 124,
   gui = "#af0000",
   h = {
      term = 160,
      gui = "#d70000"
   }
}

color.yellow = {
   term = 142,
   gui = "#afaf00"
}

color.magenta = {
   term = 125,
   gui = "#af005f"
}

color.violet = {
   term = 61,
   gui = "#5f5faf"
   -- term = 62,
   -- gui = "#5f5fd7"
}

local function _hl(opts, piece, key)
   if(key ~= nil) then
      if(piece.gui) then opts[key] = piece.gui end
      if(piece.term) then opts["cterm" .. key] = piece.term end
      if(piece.default) then opts.default = true end
   end
   opts.bold = opts.bold or piece.bold
   opts.italic = opts.italic or piece.italic
   opts.underline = opts.underline or piece.underline
   opts.undercurl = opts.undercurl or piece.undercurl
   opts.reverse = opts.reverse or piece.reverse
   opts.standout = opts.standout or piece.standout
   -- expect piece.sp to be a color with a gui attribute
   if(piece.sp ~= nil and piece.sp.gui ~= nil) then
      opts.sp = opts.sp or piece.sp.gui
   end
end

local function hl(group, fg, bg, extra)
   local opts = {}

   if(fg and fg.link) then
      opts.link = fg.link
   else
      if(fg ~= nil) then _hl(opts, fg, "fg") end
      if(bg ~= nil) then _hl(opts, bg, "bg") end
      if(extra ~= nil) then _hl(opts, extra) end
   end

   vim.api.nvim_set_hl(0, group, opts)
end


-- this doesn't seem to work.
-- vim.o.termguicolors = true


vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ higroup = "HighlightYank", timeout = 200 })
        -- vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
        -- vim.highlight.on_yank({ higroup = "Search", timeout = 200 })
    end,
})

-- set fill char to non-breaking space (it's there between the ' '', it's not a normal space)
-- since we set the statusbar colors the same below it'll add ^^^ to the status line because it doesn't know anything about lightline
vim.opt.fillchars = { stl = ' ' }

-- menu highlights

local ui = {}

ui.dark = {
   term = 234,
   gui = "#1c1c1c"
}

ui.light = color.fg

hl("FloatBorder", ui.light, ui.dark)
hl("FloatTitle", ui.light, ui.dark)
hl("Pmenu", ui.light, ui.dark)
hl("PmenuSel", ui.dark, ui.light)
hl("PmenuSbar", ui.dark, ui.light)
hl("PmenuThumb", ui.dark, ui.light)

hl("VertSplit", ui.dark, ui.dark)
hl("StatusLine", ui.dark, ui.dark)
hl("StatusLineNC", ui.dark, ui.dark)

-- line numbers and tab lines
hl("TabLine", ui.light, ui.dark)
hl("TabLineFill", ui.dark, { underline = true })
hl("TabLineSel", ui.yellow, ui.yellow)

-- hl("TabLine", color.gray.ml, { underline = true })
-- hl("TabLineFill", color.gray.m, { underline = true })
-- hl("TabLineSel", color.gray.m, color.gray.ll, { underline = true })
-- hl("TabLineSel", color.bg, color.gray.m)

hl("LineNr", color.gray.l)
hl("CursorLine", nil, color.gray.ll)
hl("CursorLineNR", color.gray.ml, color.gray.ll)

-- vim.wo.cursorcolumn = true
-- hl("CursorColumn", { ctermbg="darkred", ctermfg="white" })

hl("Cursor", color.bg, color.fg)
hl("lCursor", { link = "Cursor" })


hl("DiffAdd", color.green)
hl("DiffChange", color.gold)
hl("DiffDelete", color.red)
hl("DiffText", color.blue)


-- TODO: setup undercurl
hl("SpellBad", { undercurl = true, sp = color.red })
hl("SpellCap", { undercurl = true, sp = color.violet })
hl("SpellRare", { undercurl = true, sp = color.cyan })
hl("SpellLocal", { undercurl = true, sp = color.gold })

-- don't know about these

hl("VisualNOS", color.fg)
hl("WarningMsg", color.red, { bold = true })
hl("WildMenu", color.fg)
hl("Folded", color.fg, { underline = true, bold = true })
hl("FoldColumn", color.fg)

hl("Conceal", color.blue)

-- diagnostic signs

local sign_col_bg = color.bg
-- local sign_col_bg = color.gray.lll

vim.opt.signcolumn = "yes"
hl("SignColumn", {})

hl("SignColumn", nil, sign_col_bg)
hl("DiagnosticError", color.red, sign_col_bg)
hl("DiagnosticWarn", color.gold, sign_col_bg)
hl("DiagnosticInfo", color.gold, sign_col_bg)
hl("DiagnosticHint", color.gold, sign_col_bg)

vim.fn.sign_define("DiagnosticSignError", { text = "E", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",  { text = "W", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",  { text = "I", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",  { text = "H", texthl = "DiagnosticSignHint" })

-- hop highlights

hl("HopNextKey", color.gold.h, { bold = true })
hl("HopNextKey1", color.gold.h, { bold = true })
hl("HopNextKey2", color.red, { bold = true })
hl("HopUnmatched", color.gray.l) -- 242
hl("HopCursor", { link = "Cursor" })
hl("HopPreview", { link = "IncSearch" })


-- scope highlighting

hl("ScopeHighlight_Default", color.gray.l)
hl("ScopeHighlight_Selected", color.gray.ml)
hl("IblWhitespace", color.bg)

require("ibl").setup({
   debounce = -1,
   scope = {
      enabled = true,
      show_start = false,
      highlight = { "ScopeHighlight_Selected" },
   },
   indent = {
      highlight = { "ScopeHighlight_Default" },
      char = "┆",
      -- char = "▏",
      -- char = "▎",
      -- char = "▍",
   },
})

-- code highlighting

-- js:
-- null, return, await, args, this.
-- string single, double, ``
-- prototype, defer?
-- noise, null, undefined, typeof, true, false
-- numbers, brackets, parents, object key
-- comment TODO, HACK
-- add keywords: self.
-- single character
-- template string, template var
-- keywords should be in italics
-- strings should be italic

-- find markdown syntax setup

-- this is for trailing space and tabs. basically all listchars.
hl("NonText", color.red)
hl("SpecialKey", color.red)

hl("Normal", color.fg)
hl("Comment", color.gray.ml) -- is 241, maybe bump to 242 if it's too dark.
-- hl('Comment', { term = 242 })
hl("Identifier", { link = "Normal" })
hl("PreProc", color.orange)
hl("Type", color.gold, { bold = true })

hl("Constant", color.gold)
-- hl("Statement", color.blue)
hl("Special", color.red)

hl("Underlined", color.violet)
hl("Ignore", color.fg, color.bg)
hl("Error", color.red, { bold = true })

hl("MoreMsg", color.blue)
hl("ModeMsg", color.blue)
hl("Question", color.cyan, { bold = true })
hl("Title", color.orange, { bold = true })
hl("VisualNOS", color.orange, { bold = true })

local vis_color = color.gold
-- local vis_color = color.orange.l

-- hl("Visual", color.bg, vis_color)
-- hl("Visual", color.bg, color.violet)
hl("Visual", color.bg, color.gray.ml)
hl("HighlightYank", color.bg, vis_color)
hl("Search", color.bg, vis_color)
hl("IncSearch", color.bg, vis_color)

hl("MatchParen", color.gold, { bold = true })

hl("Todo", color.magenta, { bold = true })

hl("Directory", color.gold, { bold = true })
hl("ErrorMsg", color.bg, color.red)


hl("@property", color.fg, { default = true })
hl("@lsp.type.property", {})

-- hl("@operator", color.fg, { bold = true })


hl("@operator", { link = "Normal" })
hl("@variable.builtin", color.blue, { bold = true })
hl("@constant.builtin", color.cyan, { bold = true })

-- hl("@keyword", color.fg, { italic = true })
hl('@keyword', color.blue, { bold = true })

hl('@boolean', color.cyan, { bold = true })

-- hl("@object", color.gray.ll)
-- hl("@array", color.gray.ll)

hl("@object", color.orange)
hl("@array", color.orange)

-- hl("@keyword", color.cyan)

-- hl("@keyword.prototype.javascript", color.gray.ml, { italic = true })
-- hl("@keyword.function.javascript", color.green, { italic = true })

hl("@keyword.prototype.javascript", color.gray.ml, { bold = false })
-- hl("@keyword.function.javascript", color.green, {})

hl("@keyword.await.javascript", color.orange, { bold = true })
hl("@keyword.return", color.orange, { bold = true })
hl("@return_statement", color.orange)

hl("@punctuation.bracket", {})
-- hl("@punctuation.bracket", color.green)
-- hl("@punctuation.delimiter", color.gray.ml)
-- hl("@punctuation.delimiter", { term = 241 })
hl("@punctuation.delimiter", { term = 240 })

hl("@template_string", color.purple)

-- hl("@lsp.type.class", color.gray.mh)
-- hl("@lsp.type.class", { link = "Normal" })
hl("@lsp.type.class", { })
-- hl("@function", color.blue)

hl("@lsp.type.comment", { })
hl("@lsp.type.function", { })
hl("@function.builtin", { })

-- hl("@punctuation.bracket", color.green, { default = true })
-- hl("@punctuation.delimiter", color.gray.ml)

-- hl("@punctuation.bracket", { term = 240 }, { default = true })
-- hl("@punctuation.delimiter", { term = 240 })

hl("@keyword.function.javascript", { bold = true })
hl("@function.body.javascript", {})
-- hl("@function.body", color.purple)
hl("@function_block", color.green)


hl("@object_destructure", color.purple)
hl("@array_destructure", color.purple)

-- hl("@functionf", color.purple)
-- hl("@if_block", color.violet)
-- hl("@conditional", color.violet, { bold = true })

hl("@conditional", {})
hl("@repeat", {})

hl("@control_block", color.violet)

-- hl("@function.call", color.blue)
-- hl("@method.call", color.blue)

-- hl("@call.arguments", color.blue)

-- hl("@call.arguments", color.gray.m)
hl("@call.arguments", { term = 245 })

hl("@variable.underscore", { term = 28 }, { bold = true })

hl("@tag.html", link.norm)
hl("@tag.delimiter", color.gray.ml)

-- hl("@function", color.purple)
-- hl("@function.call", color.blue)


-- ((tag
--   (name) @text.todo @nospell
--   ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
--   ":" @punctuation.delimiter)
--   (#any-of? @text.todo "TODO" "WIP"))

-- ("text" @text.todo @nospell
--  (#any-of? @text.todo "TODO" "WIP"))

-- ((tag
--   (name) @text.note @nospell
--   ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
--   ":" @punctuation.delimiter)
--   (#any-of? @text.note "NOTE" "XXX" "INFO" "DOCS" "PERF" "TEST"))

-- ("text" @text.note @nospell
--  (#any-of? @text.note "NOTE" "XXX" "INFO" "DOCS" "PERF" "TEST"))

-- ((tag
--   (name) @text.warning @nospell
--   ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
--   ":" @punctuation.delimiter)
--   (#any-of? @text.warning "HACK" "WARNING" "WARN" "FIX"))

-- ("text" @text.warning @nospell
--  (#any-of? @text.warning "HACK" "WARNING" "WARN" "FIX"))

-- ((tag
--   (name) @text.danger @nospell
--   ("(" @punctuation.bracket (user) @constant ")" @punctuation.bracket)?
--   ":" @punctuation.delimiter)
--   (#any-of? @text.danger "FIXME" "BUG" "ERROR"))

-- ("text" @text.danger @nospell
--  (#any-of? @text.danger "FIXME" "BUG" "ERROR"))

-- ; Issue number (#123)
-- ("text" @number
--  (#lua-match? @number "^#[0-9]+$"))

-- ((uri) @text.uri @nospell)
