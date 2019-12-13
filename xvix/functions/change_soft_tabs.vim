
function! ChangeSoftTabs(from, to)
   execute "set ts=" . a:from . " noexpandtab"
   execute "retab!"
   execute "set expandtab ts=" . a:to
   execute "retab!"
endfunction

