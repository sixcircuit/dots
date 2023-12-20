
const add_plugin = function({ ai }){

   const plugin = {
      name: "say_hello",
   };

   plugin.run = function(args, callback){
      const console = ai.console();
      console.label("user: ");
      console.stream({ chunk: "hello " });
      setTimeout(function(){
         console.stream({ chunk: (args[0] || "world") + "!", flush: true });
         callback(null);
      }, 2_000);
   }

   ai.register(plugin);
};

const llm_helpers = function({ ai }){

   const helpers = ai.plugins("llm").helpers();

   helpers.vim = function(prompt){
      return lib.system({
         messages: [
            { role: "system", content: "If I ask about vim always assume i mean neovim. If I'm asking for neovim answers, always produce code in lua. answer the following question about neovim: " },
            { role: "user", content: prompt }
         ],
      });
   };

   helpers.lua = function(prompt){
      return lib.system({ 
         short: true, 
         messages: [
            { role: "system", content: "If I ask about vim always assume i mean neovim. If I'm asking for neovim answers, always produce code in lua. answer the following question about neovim: " },
            { role: "user", content: "convert these vim statement to lua:"},
            { role: "user", content: prompt }
         ]
      });
   };

}

module.exports = function({ ai }){
   add_plugin({ ai });
   llm_helpers({ ai });
};

