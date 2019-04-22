
" autocmd FileType javascript iabbrev <buffer> zun function(){<c-o>h
" autocmd FileType javascript iabbrev <buffer> aun function(){<c-o>h

" inoremap m<tab> function(){<c-o>h
" inoremap m<c-k> function(){<c-o>h
" nnoremap ;m ifunction(){<c-o>h
"
" inoremap ;f function(){ 
" nnoremap ;f ifunction(){ 
"
" inoremap ;p _.plumb(, callback)); }<c-o>14h
" nnoremap ;p i_.plumb(, callback)); }<c-o>14h
"
" inoremap ;d defer()<c-o>h
" nnoremap ;d idefer()<c-o>h
"
" inoremap ;; <esc>/{%[^%]*%}<cr>v/%}<cr><right>c
" noreabbr fnc func {% <funcName> %} ({% <params> %}){% <returnType> %}{{% <funcBody> %}}
