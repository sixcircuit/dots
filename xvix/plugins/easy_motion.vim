" Easy Motion

let g:EasyMotion_do_mapping = 0 " Disable default mappings

let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyz;'
" let g:EasyMotion_keys = 'asdghklqwertyuiopzxcvbnmfj;'
" let g:EasyMotion_keys = 'asdklghqwertyuiopzxcvbnmfj'

" let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;'

" set easy motion to just leader, instead of leader, leader
map <Leader> <Plug>(easymotion-prefix)

" Bi-directional find motion
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" nmap s <Plug>(easymotion-s)

" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
" nmap s <Plug>(easymotion-s2)

" Turn on case sensitive feature
let g:EasyMotion_smartcase = 1

" map <Leader>l <Plug>(easymotion-special-l)
" map <Leader>p <Plug>(easymotion-special-p)


" map <Leader>w <Plug>(easymotion-jumptoanywhere)
map <Leader>w <Plug>(easymotion-w)
map <Leader>b <Plug>(easymotion-b)

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

map <Leader>s <Plug>(easymotion-jumptoanywhere)
" map <Leader>w <Plug>(easymotion-jumptoanywhere)
" map <Leader>cc <Plug>(easymotion-jumptoanywhere)
" i would need to change the next one, because it slows down regular /
" map // <Plug>(easymotion-sn)


