
if vim.g.no_fancy_highlighting ~= 1 then

require('colorizer').setup()

require('nvim-treesitter.configs').setup({
  ensure_installed = "all",
  highlight = {
     enable = true,
     disable = { "perl" },
     -- enable = false,
     additional_vim_regex_highlighting = false,
     -- additional_vim_regex_highlighting = true,

     -- or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
     -- disable = function(lang, buf)
        --     local max_filesize = 100 * 1024 -- 100 kb
        --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        --     if ok and stats and stats.size > max_filesize then
        --         return true
        --     end
        -- end,
  },
  incremental_selection = {
     enable = true,
     keymaps = {
        init_selection = '<CR>',
        scope_incremental = '<CR>',
        node_incremental = '<TAB>',
        node_decremental = '<S-TAB>',
     },
  }
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

luasnip.setup({ enable_autosnippets = true })

require("luasnip.loaders.from_lua").load({ paths = "~/term/xvim/snippets" })

vim.keymap.set('i', '<c-space>', function()
   luasnip.expand_or_jump()
end, { noremap = true, silent = true })

local function jump_back()
   if luasnip.jumpable(-1) then
      luasnip.jump(-1)
   end
end
-- i have <s-space> mapped to page up in my terminal, <s-space> may work in some guis
vim.keymap.set('i', '<s-space>', jump_back, { noremap = true, silent = true })
vim.keymap.set('i', '<pageup>', jump_back, { noremap = true, silent = true })

local mapping = {
   -- accept currently selected item. set `select` to `false` to only confirm explicitly selected items.
   ['<cr>'] = cmp.mapping.confirm({ select = true }),
   ['<c-e>'] = cmp.mapping.abort(),
   -- ['<c-space>'] = cmp.mapping.complete(),
   ["<tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
         if #cmp.get_entries() == 1 then
            cmp.confirm({ select = true })
         else
            cmp.select_next_item()
         end
         -- cmp.select_next_item()
         -- you could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
         -- that way you will only jump inside the snippet region
      -- elseif luasnip.expand_or_locally_jumpable() then
         -- luasnip.expand_or_jump()
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
      -- disabled for softer non-bordered windows
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered()
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

cmp.setup.filetype('text', { completion = { autocomplete = false } })
-- cmp.setup.filetype('javascript', { completion = { autocomplete = false } })

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
   formatting = {
      format = function(entry, vim_item)
         -- This function controls how completion items are displayed.
         -- By not setting vim_item.kind (or setting it to nil), the itemkind won't be displayed.
         vim_item.kind = nil

         -- Return the modified item.
         return vim_item
      end
   }
})

-- Set up lspconfig.
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
-- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
 -- capabilities = capabilities
-- }

local lspconfig = require('lspconfig')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.tsserver.setup({
   capabilities = capabilities,
   -- on_attach = on_attach,
   init_options = {
      hostInfo = "neovim",
      preferences = {
         disableSuggestions = true
      },
   },
   settings = {
      typescript = {
         suggest = {
            autoImports = false
         },
         preferences = { disableSuggestions = true }
      },
      javascript = {
         suggest = {
            autoImports = false
         },
         preferences = { disableSuggestions = true }
      }
   }
})

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

vim.diagnostic.config({
   virtual_text = false,  -- Disables the floating text
   signs = true,          -- Keeps the signs in the sign column
   underline = true,      -- Optional, to underline the text with errors/warnings
   update_in_insert = false, -- Prevents diagnostics from updating in insert mode
   severity_sort = true,  -- Sorts diagnostics by severity
})


local null_ls = require("null-ls")

local no_really = {
    method = null_ls.methods.DIAGNOSTICS,
    filetypes = {  },
    generator = {
        fn = function(params)
            local diagnostics = {}
            -- sources have access to a params object
            -- containing info about the current file and editor state
            for i, line in ipairs(params.content) do
                local col, end_col = line:find("really")
                if col and end_col then
                    -- null-ls fills in undefined positions
                    -- and converts source diagnostics into the required format
                    table.insert(diagnostics, {
                        row = i,
                        col = col,
                        end_col = end_col + 1,
                        source = "no-really",
                        message = "Don't use 'really!'",
                        severity = vim.diagnostic.severity.WARN,
                    })
                end
            end
            return diagnostics
        end,
    },
}

local gts = {
   method = null_ls.methods.DIAGNOSTICS,
   filetypes = {  },
   generator = {
      fn = function(params)
         local diagnostics = {}

         local hour = vim.fn.strftime('%H')
         hour = tonumber(hour)

         if hour > 8 and hour < 21 then
            return diagnostics
         end

         for i, line in ipairs(params.content) do
            table.insert(diagnostics, {
               row = i,
               col = 0,
               end_col = #line,
               source = "GO TO SLEEP",
               message = "GO TO SLEEP!",
               severity = vim.diagnostic.severity.ERROR,
            })
         end

         return diagnostics
      end,
   },
}

-- null_ls.register(gts)
-- null_ls.register(no_really)

null_ls.setup({
--    sources = {
--       -- cspell.diagnostics.with({ config = cspell_config }),
--       -- cspell.code_actions.with({ config = cspell_config }),
--       -- null_ls.builtins.formatting.stylua,
--       -- null_ls.builtins.diagnostics.eslint,
--       -- null_ls.builtins.completion.spell,
--       -- null_ls.diagnostics.completion.spell,
--    }
})

end
