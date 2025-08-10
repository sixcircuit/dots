
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local d = ls.dynamic_node
local f = ls.function_node
local t = ls.text_node
local sn = ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt

local snipppets = {}
local autosnippets = {}

local function insert(dest, src)
   for _,v in ipairs(src) do
      table.insert(dest, v)
   end
end

local function render(str, replacements)
   return string.gsub(str, "<(.-)>", replacements)
end

-- Fix snippets. Setup "function" abbrev to WRONG, same with prototype. if( "else " and else{. ;f and ;af and ;if ;elif ;else use ; to tab into the pieces. Start with that. comment out all the others.

local function has_text_after_cursor()
   local col = vim.api.nvim_win_get_cursor(0)[2]
   local line = vim.api.nvim_get_current_line()

   -- get everything after the cursor
   local after = line:sub(col + 1)

   -- remove spaces semicolons and closing parens
   local stripped = after:gsub("[ ;%)]+", "")

   return #stripped > 0
end

local function create_function_mappings(snips, is_async)
   local fsnips = {
      { trigger = ";<base_trigger>",
        description = "<type>",
        fmt = "<async>function({}){{{}}}{}",
        args = { i(1), i(2), i(0) },
        literal = {
           fmt = "<async>function{}",
           args = { i(0) }
        },
      },

      { trigger = ";<trigger>n",
        description = "named <type>",
        fmt = "<async>function {}({}){{{}}}{}",
        args = { i(1, "name"), i(2), i(3), i(0) }
      },

      { trigger = ";<trigger>w",
        description = "arrow <type>",
        fmt = "<async>({})=>{{{}}}{}",
        args = { i(1), i(2), i(0) }
      },
   }

   local values;

   if(is_async) then
      values = { base_trigger = "aff", trigger = "af", async = "async ", type = "async function" }
   else
      values = { base_trigger = "ff", trigger= "f", async = "", type = "function" }
   end

   for _, snip in ipairs(fsnips) do

      local ns = s(
         render(snip.trigger, values), {
            d(1, function(args, snp)

              if snip.literal and has_text_after_cursor() then
                return sn(nil, fmt(render(snip.literal.fmt, values), snip.literal.args))
              else
                return sn(nil, fmt(render(snip.fmt, values), snip.args))
              end

            end, { description = render(snip.description, values) })
         }
      )
      table.insert(snips, ns)
   end
end

create_function_mappings(autosnippets, true)
create_function_mappings(autosnippets, false)


local function create_declaration_mappings(snips, is_let)

   local base_trigger = ";cn"
   if is_let then base_trigger = ";le" end

   local dsnips = {
      {
         trigger = base_trigger,
         fmt = "<storage> {} = {};",
         args = { i(1, "x"), i(0, "v") }
      },
      {
         trigger = ";<trigger>i",
         fmt = "<storage> {} = ",
         args = { i(0, "x") }
      },
      {
         trigger = ";<trigger>`",
         fmt = "<storage> {} = `{}`",
         args = { i(1, "x"), i(0, "str") }
      },
      {
         trigger = ";<trigger>\"",
         fmt = "<storage> {} = \"{}\"",
         args = { i(1, "x"), i(0, "str") }
      },
      {
         trigger = ";<trigger>ff",
         fmt = "<storage> {} = function({}){{{}}};",
         args = { i(1, "x"), i(2), i(0) }
      },
      {
         trigger = ";<trigger>fa",
         fmt = "<storage> {} = async function({}){{{}}};",
         args = { i(1, "x"), i(2), i(0) }
      },
      {
         trigger = ";<trigger>o",
         fmt = "<storage> {} = {{{}}};",
         args = { i(1, "x"), i(0) }
      },
      {
         trigger = ";<trigger>o",
         fmt = "<storage> {} = {{{}}};",
         args = { i(1, "x"), i(0) }
      },
      {
         trigger = ";<trigger>a",
         fmt = "<storage> {} = [{}];",
         args = { i(1, "x"), i(0) }
      },
      {
         trigger = ";<trigger>ods",
         fmt = "<storage> {{{}}} = {};",
         args = { i(1), i(0, "obj") }
      },
      {
         trigger = ";<trigger>ads",
         fmt = "<storage> [{}] = {};",
         args = { i(1), i(0, "ary") }
      },
      {
         trigger = ";<trigger>se",
         fmt = "<storage> self = this;",
         args = {}
      },
      {
         trigger = ";<trigger>ops",
         fmt = "<storage> {{{}}} = opts;";
         args = { i(0) }
      },
      {
         trigger = ";<trigger>sy",
         fmt = "<storage> {} = Symbol(\"{}\");",
         args = { i(1, "x"), i(0) }
      },
   }

   local values;

   if(is_let) then
      values = { trigger= "l", storage = "let" }
   else
      values = { trigger= "c", storage = "const" }
   end

   for _, snip in ipairs(dsnips) do
      local ns = s(
         render(snip.trigger, values),
         fmt(render(snip.fmt, values), snip.args)
      )
      table.insert(snips, ns)
   end
end

local function create_random(snips, prefix)

   local defsnips = {
      { trigger = ";opt", fmt = "opts = opts || {{}};{}", args = { i(0) } },
   }

   local values = { prefix = prefix }

   for _, snip in ipairs(defsnips) do
      local ns = s(
         render(snip.trigger, values),
         fmt(render(snip.fmt, values), snip.args)
      )
      table.insert(snips, ns)
   end
end

create_random(autosnippets, "")

create_declaration_mappings(autosnippets, true)
create_declaration_mappings(autosnippets, false)

local function create_type_checks(snips, test)

   local defsnips = {
      { trigger = ";<test>s", fmt = "_.<test>_str({})", args = { i(0) } },
      { trigger = ";<test>n", fmt = "_.<test>_num({})", args = { i(0) } },
      { trigger = ";<test>o", fmt = "_.<test>_obj({})", args = { i(0) } },
      { trigger = ";<test>a", fmt = "_.<test>_ary({})", args = { i(0) } },
      { trigger = ";<test>f", fmt = "_.<test>_fun({})", args = { i(0) } },
      { trigger = ";<test>d", fmt = "_.<test>_def({})", args = { i(0) } },
      { trigger = ";<test>u", fmt = "_.<test>_und({})", args = { i(0) } },
      { trigger = ";<test>y", fmt = "_.<test>_sym({})", args = { i(0) } },
   }

   local values = { test = test }

   for _, snip in ipairs(defsnips) do
      local ns = s(
         render(snip.trigger, values),
         fmt(render(snip.fmt, values), snip.args)
      )
      table.insert(snips, ns)
   end
end

create_type_checks(autosnippets, "is")
create_type_checks(autosnippets, "ok")

local function create_type_check_ifs(snips, test)

   local defsnips = {
      { trigger = ";i<trigger>s", fmt = "if(_.<test>_str({})){{{}}}", args = { i(1, "val"), i(0) } },
      { trigger = ";i<trigger>n", fmt = "if(_.<test>_num({})){{{}}}", args = { i(1, "val"), i(0) } },
      { trigger = ";i<trigger>o", fmt = "if(_.<test>_obj({})){{{}}}", args = { i(1, "val"), i(0) } },
      { trigger = ";i<trigger>a", fmt = "if(_.<test>_ary({})){{{}}}", args = { i(1, "val"), i(0) } },
      { trigger = ";i<trigger>f", fmt = "if(_.<test>_fun({})){{{}}}", args = { i(1, "val"), i(0) } },
      { trigger = ";i<trigger>d", fmt = "if(_.<test>_def({})){{{}}}", args = { i(1, "val"), i(0) } },
      { trigger = ";i<trigger>u", fmt = "if(_.<test>_und({})){{{}}}", args = { i(1, "val"), i(0) } },
      { trigger = ";i<trigger>y", fmt = "if(_.<test>_sym({})){{{}}}", args = { i(1, "val"), i(0) } },
   }

   local values = { trigger = "i", test = "is" }

   for _, snip in ipairs(defsnips) do
      local ns = s(
         render(snip.trigger, values),
         fmt(render(snip.fmt, values), snip.args)
      )
      table.insert(snips, ns)
   end
end

create_type_check_ifs(autosnippets)

insert(autosnippets, {
   s(";rr", fmt( "return{}", { i(0) })),
   s(";rf", fmt( "return(function({}){{{}}});", { i(1), i(0) })),
   s(";raf", fmt( "return(async function({}){{{}}});", { i(1), i(0) })),
   s(";re", fmt( "return({});", { i(0, "value") })),
   s(";rbt", fmt( "return(true);", {})),
   s(";rbf", fmt( "return(false);", {})),
   s(";rt", fmt( "return(this);", {})),
   s(";rn", fmt( "return(null);", {})),
   s(";rp", fmt( "return(new Promise(function(resolve, reject){{\n   {}\n}}));", { i(0) })),
});

insert(autosnippets, {
   s(";fori", fmt(
      "for(let i = 0; i < {}; i++){{\n   {}\n}}{}",
      { i(1, "value"), i(2), i(0) }
   )),
   s(";forj", fmt(
      "for(let j = 0; j < {}; j++){{\n   {}\n}}{}",
      { i(1, "value"), i(2), i(0) }
   )),
   s(";fork", fmt(
      "for(let k = 0; k < {}; k++){{\n   {}\n}}{}",
      { i(1, "value"), i(2), i(0) }
   ))
})

insert(autosnippets, {
   s(";trn", fmt(
      "({} ? {} : {}){}",
      { i(1, "cond"), i(2, "if_true"), i(3, "if_false"), i(0) }
   )),
   s(";if", fmt(
      "if({}){{{}}}{}",
      { i(1, "true"), i(2), i(0) }
   )),
   s(";ei", fmt(
      "else if({}){{{}}}{}",
      { i(1, "true"), i(2), i(0) }
   )),
   s(";el", fmt(
      "else{{{}}}{}",
      { i(1), i(0) }
   )),
});


insert(autosnippets, {
   s(";tc", fmt(
      "try{{\n   {}\n}}catch({}){{\n   {}\n}}{}",
      { i(1), i(2, "e"), i(3), i(0) }
   )),
   s(";tf", fmt(
      "try{{\n   {}\n}}catch({}){{\n   {}\n}}finally{{\n   {}\n}}{}",
      { i(1), i(2, "e"), i(3), i(4), i(0) }
   ))
});

insert(autosnippets, {
   s(";fl", fmt("_.fatal(\"{}\"){}", { i(1), i(0) })),
   s(";er", fmt("_.error(\"{}\", \"{}\"){}", { i(1, "code"), i(2), i(0) })),
   s(";te", fmt("_.error.throw(\"{}\", \"{}\"){}", { i(1, "code"), i(2), i(0) })),
})

insert(autosnippets, {
   s(";ss", fmt(
      "${{ {} }}{}",
      { i(1, "value"), i(0) }
   )),
})

insert(autosnippets, {
   s(";pr", fmt(
      "{}.prototype.{} = {};",
      { i(1, "class_name"), i(2, "method_name"), i(0) }
   )),
})

insert(autosnippets, {
   s(";aw", fmt(
      "await {};",
      { i(0) }
   )),
})

insert(autosnippets, {
   s(";cp", fmt(
      "code.push(`{}`);",
      { i(0) }
   )),
})

insert(autosnippets, {
   s(";req", fmt(
      "const {} = require(\"{}\");",
      { i(1, "name"), i(2, "path") }
   )),
   s(";me", fmt(
      "module.exports = {}",
      { i(0) }
   )),
   s(";eb", fmt(
      "exports.bundle = function(_, _opts){{\n   const lib = {{}};\n   {}\n\n}};",
      { i(0) }
   )),
})

-- maybe some other ideas here.
 -- # JSON.parse
 -- snippet jsonp
 -- 	JSON.parse(${0:jstr});

 -- # JSON.stringify
 -- snippet jsons
 -- 	JSON.stringify(${0:object});

 -- # DOM selectors

 -- # Get elements
 -- snippet get
 -- 	getElementsBy${1:TagName}('${0}')

 -- # Get element
 -- snippet gett
 -- 	getElementBy${1:Id}('${0}')

 -- # Elements by class
 -- snippet by.
 -- 	${1:document}.getElementsByClassName('${0:class}')

 -- # Element by ID
 -- snippet by#
 -- 	${1:document}.getElementById('${0:element ID}')

 -- # Query selector
 -- snippet qs
 -- 	${1:document}.querySelector('${0:CSS selector}')

 -- # Query selector all
 -- snippet qsa
 -- 	${1:document}.querySelectorAll('${0:CSS selector}')


return snipppets, autosnippets
