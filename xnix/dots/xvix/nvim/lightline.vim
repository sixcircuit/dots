
let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ ['darkestgreen', 'brightgreen', 'bold'], ['white', 'gray4'] ]
let s:p.normal.right = [ ['gray5', 'gray10'], ['gray9', 'gray4'], ['gray8', 'gray2'] ]
let s:p.inactive.right = [ ['gray1', 'gray5'], ['gray4', 'gray1'], ['gray4', 'gray0'] ]
let s:p.inactive.left = [ ['gray7', 'gray2'], ['gray4', 'gray1'], ['gray4', 'gray0'] ]
let s:p.inactive.middle = [ [ 'white', 'gray0' ] ]
" let s:p.inactive.left = [ ['gray1', 'gray5'], ['gray4', 'gray1'], ['gray4', 'gray0'] ]
" let s:p.inactive.left = s:p.inactive.right[1:]
let s:p.insert.left = [ ['darkestcyan', 'white', 'bold'], ['white', 'darkblue'] ]
let s:p.insert.right = [ [ 'darkestcyan', 'mediumcyan' ], [ 'mediumcyan', 'darkblue' ], [ 'mediumcyan', 'darkestblue' ] ]
let s:p.replace.left = [ ['white', 'brightred', 'bold'], ['white', 'gray4'] ]
let s:p.visual.left = [ ['darkred', 'brightorange', 'bold'], ['white', 'gray4'] ]
let s:p.normal.middle = [ [ 'gray7', 'gray2' ] ]
" let s:p.normal.middle = [ [ 'white', 'gray0' ] ]
let s:p.insert.middle = [ [ 'mediumcyan', 'darkestblue' ] ]
let s:p.replace.middle = s:p.normal.middle
let s:p.replace.right = s:p.normal.right
let s:p.tabline.left = [ [ 'gray9', 'gray4' ] ]
let s:p.tabline.tabsel = [ [ 'gray9', 'gray1' ] ]
let s:p.tabline.middle = [ [ 'gray2', 'gray8' ] ]
let s:p.tabline.right = [ [ 'gray9', 'gray3' ] ]
let s:p.normal.error = [ [ 'gray9', 'brightestred' ] ]
let s:p.normal.warning = [ [ 'gray1', 'yellow' ] ]

let g:lightline#colorscheme#mine#palette = lightline#colorscheme#fill(s:p)
"
" \ 'colorscheme': 'wombat',
" \ 'colorscheme': 'powerline',
" \ 'colorscheme': 'powerlineish',
" \ 'colorscheme': 'solarized',
" \ 'colorscheme': 'apowerlineish',

let g:lightline = {
   \ 'colorscheme': 'mine',
   \ 'enable': { 'tabline': 0 },
   \ 'active': {
   \   'left': [ [ 'mode', 'paste' ],
   \             [ 'filename', 'modified', 'readonly' ] ]
   \ },
   \ 'component': {
   \   'modified': '%#ModifiedColor#%{LightLineModified()}',
   \   'readonly': '%#ReadOnlyColor#%{LightLineReadOnly()}',
   \ },
   \ 'component_type': {
   \   'modified': 'raw',
   \   'readonly': 'raw'
   \ },
   \ 'component_function': {
   \   'mode': 'LightLineMode',
   \   'filename': 'LightLineFileName',
   \   'fileformat': 'LightLineFileFormat',
   \   'filetype': 'LightLineFileType',
   \   'fileencoding': 'LightLineFileEncoding',
   \   'ctrlpmark': 'CtrlPMark',
   \   'fugitive': 'LightLineFugitive',
   \ },
\ }


let g:lightline.separator = { 'left': '', 'right': '' }
let g:lightline.subseparator = { 'left': '', 'right': '' }


function! LightLineReadOnly()
  let map = { 'V': 'n', "\<C-v>": 'n', 's': 'n', 'v': 'n', "\<C-s>": 'n', 'c': 'n', 'R': 'n'}
  let mode = get(map, mode()[0], mode()[0])
  let bgcolor = {'n': [240, '#585858'], 'i': [31, '#0087af']}
  exe printf('hi ReadOnlyColor ctermfg=196 ctermbg=%d guifg=#ff0000 guibg=%s term=bold cterm=bold',
        \ bgcolor[mode][0], bgcolor[mode][1])
  return &readonly ? "RO " : ""
endfunction

function! LightLineModified()
  let map = { 'V': 'n', "\<C-v>": 'n', 's': 'n', 'v': 'n', "\<C-s>": 'n', 'c': 'n', 'R': 'n'}
  let mode = get(map, mode()[0], mode()[0])
  let bgcolor = {'n': [240, '#585858'], 'i': [31, '#0087af']}
  exe printf('hi ModifiedColor ctermfg=196 ctermbg=%d guifg=#ff0000 guibg=%s term=bold cterm=bold',
        \ bgcolor[mode][0], bgcolor[mode][1])
  return &modified ? "• " : ""
  " return &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineFileName()
   let fname = expand('%:t')
   if fname == 'ControlP' && has_key(g:lightline, 'ctrlp_item')
      return g:lightline.ctrlp_item 
   elseif fname == 'Command-T [Files]' 
      return commandt#Path()
   elseif fname == '__Tagbar__' 
      return g:lightline.fname 
   elseif fname =~ '__Gundo\|NERD_tree' 
      return ''
   elseif &ft == 'vimfiler' 
      return vimfiler#get_status_string()
   elseif &ft == 'unite' 
      return unite#get_status_string() :
   elseif &ft == 'vimshell' 
      return vimshell#get_status_string() 
   else
      return ('' != fname ? expand('%') : '[No Name]')
   endif
endfunction

function! LightLineFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let branch = fugitive#head()
      return branch !=# '' ? mark.branch : ''
    endif
  catch
  endtry
  return ''
endfunction

function! LightLineFileFormat()
  return winwidth(0) > 90 ? &fileformat : ''
endfunction

function! LightLineFileType()
  return winwidth(0) > 90 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileEncoding()
  return winwidth(0) > 90 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == 'Command-T [Files]' ? 'Command-T [Files]' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ lightline#mode()
        " \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP' && has_key(g:lightline, 'ctrlp_item')
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

" let g:ctrlp_status_func = {
"   \ 'main': 'CtrlPStatusFunc_1',
"   \ 'prog': 'CtrlPStatusFunc_2',
"   \ }
"
" function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
"   let g:lightline.ctrlp_regex = a:regex
"   let g:lightline.ctrlp_prev = a:prev
"   let g:lightline.ctrlp_item = a:item
"   let g:lightline.ctrlp_next = a:next
"   return lightline#statusline(0)
" endfunction
"
" function! CtrlPStatusFunc_2(str)
"   return lightline#statusline(0)
" endfunction
"
" let g:tagbar_status_func = 'TagbarStatusFunc'
"
" function! TagbarStatusFunc(current, sort, fname, ...) abort
"     let g:lightline.fname = a:fname
"   return lightline#statusline(0)
" endfunction
"
" " Syntastic can call a post-check hook, let's update lightline there
" " For more information: :help syntastic-loclist-callback
" function! SyntasticCheckHook(errors)
"   call lightline#update()
" endfunction

" 	let g:unite_force_overwrite_statusline = 0
" 	let g:vimfiler_force_overwrite_statusline = 0
" 	let g:vimshell_force_overwrite_statusline = 0
" " - `commandt#ActiveFinder()`: Returns the class name of the currently
" "   active finder.
" " - `commandt#Path()`: Returns the path that Command-T is currently
" "   searching.
" " - `commandt#CheckBuffer()`: Takes a buffer number and returns true if
" "   it is the Command-T match listing buffer.
"
" function! MyLightLineFilename()
" 	let name = ""
" 	let subs = split(expand('%'), "/") 
" 	let i = 1
" 	for s in subs
" 		let parent = name
" 		if  i == len(subs)
" 			let name = parent . '/' . s
" 		elseif i == 1
" 			let name = s
" 		else
" 			let name = parent . '/' . strpart(s, 0, 2)
" 		endif
" 		let i += 1
" 	endfor
"   return name
" endfunction

" function! MyLightLineFilename()
"    call Unique_tail_improved_format()
" endfunction
"
" let s:skip_symbol = '…'
"
" function! Unique_tail_improved_format(bufnr, buffers)
"   if len(a:buffers) <= 1 " don't need to compare bufnames if has less than one buffer opened
"     return airline#extensions#tabline#formatters#default#format(a:bufnr, a:buffers)
"   endif
"
"   let curbuf_tail = fnamemodify(bufname(a:bufnr), ':t')
"   let do_deduplicate = 0
"   let path_tokens = {}
"
"   for nr in a:buffers
"     let name = bufname(nr)
"     if !empty(name) && nr != a:bufnr && fnamemodify(name, ':t') == curbuf_tail " only perform actions if curbuf_tail isn't unique
"       let do_deduplicate = 1
"       let tokens = reverse(split(substitute(fnamemodify(name, ':p:h'), '\\', '/', 'g'), '/'))
"       let token_index = 0
"       for token in tokens
"         if token == '' | continue | endif
"         if token == '.' | break | endif
"         if !has_key(path_tokens, token_index)
"           let path_tokens[token_index] = {}
"         endif
"         let path_tokens[token_index][token] = 1
"         let token_index += 1
"       endfor
"     endif
"   endfor
"
"   if do_deduplicate == 1
"     let path = []
"     let token_index = 0
"     for token in reverse(split(substitute(fnamemodify(bufname(a:bufnr), ':p:h'), '\\', '/', 'g'), '/'))
"       if token == '.' | break | endif
"       let duplicated = 0
"       let uniq = 1
"       let single = 1
"       if has_key(path_tokens, token_index)
"         let duplicated = 1
"         if len(keys(path_tokens[token_index])) > 1 | let single = 0 | endif
"         if has_key(path_tokens[token_index], token) | let uniq = 0 | endif
"       endif
"       call insert(path, {'token': token, 'duplicated': duplicated, 'uniq': uniq, 'single': single})
"       let token_index += 1
"     endfor
"
"     let buf_name = [curbuf_tail]
"     let has_uniq = 0
"     let has_skipped = 0
"     for token1 in reverse(path)
"       if !token1['duplicated'] && len(buf_name) > 1
"         call insert(buf_name, s:skip_symbol)
"         let has_skipped = 0
"         break
"       endif
"
"       if has_uniq == 1
"         call insert(buf_name, s:skip_symbol)
"         let has_skipped = 0
"         break
"       endif
"
"       if token1['uniq'] == 0 && token1['single'] == 1
"         let has_skipped = 1
"       else
"         if has_skipped == 1
"           call insert(buf_name, s:skip_symbol)
"           let has_skipped = 0
"         endif
"         call insert(buf_name, token1['token'])
"       endif
"
"       if token1['uniq'] == 1
"         let has_uniq = 1
"       endif
"     endfor
"
"     if has_skipped == 1
"       call insert(buf_name, s:skip_symbol)
"     endif
"
"     return join(buf_name, '/'))
"   endif
" endfunction
"
"
"
" let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
" let s:p.normal.left = [ ['darkestgreen', 'brightgreen', 'bold'], ['white', 'gray0'] ]
" let s:p.normal.right = [ ['gray10', 'gray2'], ['white', 'gray1'], ['white', 'gray0'] ]
" let s:p.inactive.right = [ ['gray1', 'gray5'], ['gray4', 'gray1'], ['gray4', 'gray0'] ]
" let s:p.inactive.left = s:p.inactive.right[1:]
" let s:p.insert.left = [ ['darkestcyan', 'white', 'bold'], ['mediumcyan', 'darkestblue'] ]
" let s:p.insert.right = [ [ 'darkestblue', 'mediumcyan' ], [ 'mediumcyan', 'darkblue' ], [ 'mediumcyan', 'darkestblue' ] ]
" let s:p.replace.left = [ ['white', 'brightred', 'bold'], ['white', 'gray0'] ]
" let s:p.visual.left = [ ['black', 'brightestorange', 'bold'], ['white', 'gray0'] ]
" let s:p.normal.middle = [ [ 'white', 'gray0' ] ]
" let s:p.insert.middle = [ [ 'mediumcyan', 'darkestblue' ] ]
" let s:p.replace.middle = s:p.normal.middle
" let s:p.replace.right = s:p.normal.right
" let s:p.tabline.left = [ [ 'gray9', 'gray0' ] ]
" let s:p.tabline.tabsel = [ [ 'gray9', 'gray2' ] ]
" let s:p.tabline.middle = [ [ 'gray2', 'gray0' ] ]
" let s:p.tabline.right = [ [ 'gray9', 'gray1' ] ]
" let s:p.normal.error = [ [ 'gray9', 'brightestred' ] ]
" let s:p.normal.warning = [ [ 'gray1', 'yellow' ] ]
"
" let g:lightline#colorscheme#apowerlineish#palette = lightline#colorscheme#fill(s:p)
"

