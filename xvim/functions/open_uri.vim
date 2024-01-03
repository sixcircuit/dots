

function! ExtractURI(line)
   let line = a:line . " "
   " let regex = 'https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*'
   " let regex = '\b((?:[a-z][\w-]+:(?:/{1,3}|[a-z0-9%])|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:\'".,<>?«»“”‘’]))'
   " let regex = "(https?://|www\d{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/)(?:[^\s()<>]+|\(([^\s()<>]+|(\([^\s()<>]+\)))*\))+(?:\(([^\s()<>]+|(\([^\s()<>]+\)))*\)|[^\s`!()\[\]{};:'\".,<>?«»“”‘’])"
   " let regex = '(https?://|www\d\{0,3}[.]|[a-z0-9.\-]+[.][a-z]{2,4}/).*'
   " let regex = '\(https\=:\).*'
   " let regex = '\<\c\(https\=://|www\d\{0,3}[.]|[a-z0-9.\-]+[.][a-z]\{2,4}/\).*\>'
   " this is hacky as fuck. there are drop in regex's but they aren't vim
   " regex which means i have to rewrite them which is a nightmare. so here's
   " a regex that basically pulls anything that even vaguely looks like a url.
   " it would be nice if we could just drop this in, but we can't.
   " also we drop a trailing )]>} character so I can (url here). it might
   " break urls with a real ) at the end. i don't know. i don't care. i'm
   " moving on.
   " https://daringfireball.net/2010/07/improved_regex_for_matching_urls
   let regex = ''
   let regex .= '\c'
   let regex .= '\s*'
   let regex .= '\('
   let regex .= '\(\(http\|https\)://\)\='
   let regex .= '\([a-z0-9.\-]*[.][a-z]\{2,4}\)[^ ]*'
   let regex .= '\)'
   let url = matchstr(line , regex)
   let url = trim(url)
   let matched = matchstr(url , '^\(http\|https\)://')
   " echo "url: '" . url . "'"
   " echo "matched: " . matched
   if matched == ''
      let url = "https://" . url
   endif
   echo "url[-1:]: '" . url[-1:] . "'"
   if url[-1:] == ')' || url[-1:] == "]" || url[-1:] == "}" || url[-1:] == ">"
      let url = url[:-2]
      " echo "url[:-2]: '" . url . "'"
   endif
   " echo "url: '" . url . "'"
   " echo "\n"
   return url
endfunction

function! OpenURI()
   let line = getline('.')
   let url = ExtractURI(line)

   if has("mac") == 1
     " exec "!open '" . url . "'"
     call jobstart(["open", url], {"detach": v:true})
     " call jobstart(["open", url])
   elseif has("unix") == 1
     " exec "!xdg-open '" . url . "'"
     call jobstart(["xdg-open", url], {"detach": v:true})
     " call jobstart(["xdg-open", url])
   else
     echoerr "Error: gx is not supported on this OS!"
   endif

   " if has("mac") == 1
   "   call jobstart(["open", expand("<cfile>")], {"detach": v:true})
   " elseif has("unix") == 1
   "   call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})
   " else
   "   echoerr "Error: gx is not supported on this OS!"
   " endif

endfunction

" call ExtractURI("aaaa www.google.com aaaa")
" call ExtractURI("aaaa http://www.google.com aaaa")
" call ExtractURI("aaaa https://www.google.com aaaa")
" call ExtractURI("aaaa https://google.com aaaa")
" call ExtractURI("aaaa google.com aaaa")
" call ExtractURI("aaaa qqq.asdf.google.com?asdfom&=askdfj=lkasjdf-i82734klvsad.com")
" call ExtractURI("aaaa qqq.asdf.google.com?asdfom&=askdfj=lkasjdf-i82734klvsad.comk")
" call ExtractURI("aaaa qqq.asdf.google.com?asdfom&=askdfj=lkasjdf-i82734klvsad.com\t")
" call ExtractURI("aaaa http://qqq.asdf.google.com?asdfom&=askdfj=lkasjdf-i82734klvsad.com\t")
" call ExtractURI("aaaa (http://qqq.asdf.google.com?asdfom&=askdfj=lkasjdf-i82734klvsad.com)")
" call ExtractURI("aaaa (HTTP://QQQ.ASDF.GOOGLE.COM/\\(asdf\\)?ASDFOM&=ASKDFJ=LKASJDF-I82734KLVSAD.COM)")
" call ExtractURI("aaaa <HTTP://QQQ.ASDF.GOOGLE.COM?ASDFOM&=ASKDFJ=LKASJDF-I82734KLVSAD.COM>")
" call ExtractURI("aaaa [HTTP://QQQ.ASDF.GOOGLE.COM?ASDFOM&=ASKDFJ=LKASJDF-I82734KLVSAD.COM]")
" call ExtractURI("aaaa {HTTP://QQQ.ASDF.GOOGLE.COM?ASDFOM&=ASKDFJ=LKASJDF-I82734KLVSAD.COM}")

