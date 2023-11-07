
local blue = { ctermfg = 33 }
local orange = { ctermfg = 166 }

local links = {
  ['@lsp.type.namespace'] = '@namespace',
  ['@lsp.type.type'] = '@type',
  ['@lsp.type.class'] = '@type',
  ['@lsp.type.enum'] = '@type',
  ['@lsp.type.interface'] = '@type',
  ['@lsp.type.struct'] = '@structure',
  ['@lsp.type.parameter'] = '@parameter',
  ['@lsp.type.variable'] = '@variable',
  ['@lsp.type.property'] = '@property',
  ['@lsp.type.enumMember'] = '@constant',
  ['@lsp.type.function'] = '@function',
  ['@lsp.type.method'] = '@method',
  ['@lsp.type.macro'] = '@macro',
  ['@lsp.type.decorator'] = '@function',
}

for newgroup, oldgroup in pairs(links) do
  vim.api.nvim_set_hl(0, newgroup, { link = oldgroup, default = true })
end

-- vim.api.nvim_set_hl(0, '@lsp.type.parameter', { fg='Purple' })
-- vim.api.nvim_set_hl(0, '@variable.javascript', { ctermfg=61})
-- vim.api.nvim_set_hl(0, '@variable.javascript', blue)
-- vim.api.nvim_set_hl(0, '@variable.javascript', { ctermfg=125})

vim.api.nvim_set_hl(0, '@function', orange)
-- vim.api.nvim_set_hl(0, '@function', blue)

-- hop highlights

-- Highlight used for the mono-sequence keys (i.e. sequence of 1).
vim.api.nvim_set_hl(0, 'HopNextKey', { fg = '#ff007c', bold = true, ctermfg = 198, cterm = { bold = true } })

-- Highlight used for the first key in a sequence.
vim.api.nvim_set_hl(0, 'HopNextKey1', { fg = '#00dfff', bold = true, ctermfg = 45, cterm = { bold = true } })

-- Highlight used for the second and remaining keys in a sequence.
vim.api.nvim_set_hl(0, 'HopNextKey2', { fg = '#2b8db3', ctermfg = 33 })

-- Highlight used for the unmatched part of the buffer.
vim.api.nvim_set_hl(0, 'HopUnmatched', { fg = '#666666', sp = '#666666', ctermfg = 242 })

-- Highlight used for the fake cursor visible when hopping.
vim.api.nvim_set_hl(0, 'HopCursor', { link = 'Cursor' })

-- Highlight used for preview pattern
vim.api.nvim_set_hl(0, 'HopPreview', { link = 'IncSearch' })

