
require('nvim-treesitter.configs').setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
    -- enable = false,
    -- additional_vim_regex_highlighting = false,
    -- additional_vim_regex_highlighting = true,

    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,
  },
})

-- https://github.com/williamboman/mason-lspconfig.nvim

-- tsserver does javascript

local lsp_servers = { "lua_ls", "tsserver" }

-- this needs to come before the lsp server setup below
require("mason").setup()

require("mason-lspconfig").setup({
   ensure_installed = lsp_servers,
})

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require("cmp")

local luasnip = require("luasnip")

require("luasnip.loaders.from_snipmate").lazy_load({paths = "~/term/xvim/snippets"})

local mapping = {
   -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
   ['<CR>'] = cmp.mapping.confirm({ select = true }),
   ['<C-e>'] = cmp.mapping.abort(),
   ['<C-Space>'] = cmp.mapping.complete(),
   ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
         if #cmp.get_entries() == 1 then
            cmp.confirm({ select = true })
         else
            cmp.select_next_item()
         end
         -- cmp.select_next_item()
         -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable() 
         -- that way you will only jump inside the snippet region
      elseif luasnip.expand_or_locally_jumpable() then
         luasnip.expand_or_jump()
      elseif has_words_before() then
         cmp.complete()
      else
         fallback()
      end
   end, { "i", "s" }),

   ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
         cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
         luasnip.jump(-1)
      else
         fallback()
      end
   end, { "i", "s" }),
}


-- mapping = {
--    ['<S-Tab>'] = cmp.mapping.prev(),
--    ['<Tab>'] = cmp.mapping.next()
-- },

-- mapping = cmp.mapping.preset.insert({
--    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--    ['<C-f>'] = cmp.mapping.scroll_docs(4),
--    ['<C-e>'] = cmp.mapping.abort(),
--    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
-- }),

cmp.setup({
   snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
         -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
         require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
         -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
         -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
   },
   window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered()
   },
   mapping = mapping,
   sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' }, -- For vsnip users.
      { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
      { name = 'path', option = { }, }
   }, {
      { name = 'buffer' },
   })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
   sources = cmp.config.sources({
      { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
   }, {
      { name = 'buffer' },
   })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
   mapping = cmp.mapping.preset.cmdline(),
   sources = {
      { name = 'buffer' }
   }
})

-- turn off completion for : cmd line
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
   sources = cmp.config.sources({
      { name = 'path' }
   }, {
      { name = 'cmdline' }
   }),
   mapping = cmp.mapping.preset.cmdline(),
})

-- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
 -- capabilities = capabilities
-- }

local lspconfig = require 'lspconfig'

local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.lua_ls.setup({
   capabilities = capabilities,
   -- on_attach = on_attach,
   settings = {
      Lua = {
         runtime = {
            -- Tell the language server which version of Lua you're using
            -- (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
         },
         diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {
               'vim',
               'require'
            },
         },
         workspace = {
            -- Make the server aware of Neovim runtime files
            -- library = vim.api.nvim_get_runtime_file("", true),
         },
         -- Do not send telemetry data containing a randomized but unique identifier
         telemetry = { enable = false, },
      },
   }
})

lspconfig.tsserver.setup({
   capabilities = capabilities,
   -- on_attach = on_attach,
   init_options = {
      hostInfo = "neovim",
      preferences = {
         disableSuggestions = true,
         --    -- documentFormatting = true
      }
   }
})

vim.diagnostic.config({
   virtual_text = false,  -- Disables the floating text
   signs = true,          -- Keeps the signs in the sign column
   underline = true,      -- Optional, to underline the text with errors/warnings
   update_in_insert = false, -- Prevents diagnostics from updating in insert mode
   severity_sort = true,  -- Sorts diagnostics by severity
})

