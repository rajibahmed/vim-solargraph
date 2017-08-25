
if exists("g:loaded_vim_solargraph")
  finish
endif
let g:loaded_vim_solargraph = 1


let s:plugindir = expand('<sfile>:p:h') . "/main.rb"
execute 'rubyfile ' . s:plugindir 

function! RubySolar()
  "echom "Hello, world!"
  ruby << EOF
  ko = VimSolargraph.new
  VIM::command("return #{ko.suggest.inspect}")
EOF
endfunction



function! solargraph#CompleteSolar(findstart, base)
    if a:findstart
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\a' 
            let start -= 1
        endwhile
        return start
    else
        " find classes matching "a:base"
        let res = []
				let matches=RubySolar()
        for m in matches
            if m =~ '^' . a:base
                call add(res, m)
            endif
        endfor
        return res
    endif
endfun


"" https://github.com/ctrlpvim/ctrlp.vim/issues/59
"" Or else use https://github.com/dbakker/vim-projectroot
function! s:setcwd()
  if exists("g:SessionLoad") | retu | en
  let cph = expand('%:p:h', 1)
  if cph =~ '^.\+://' | retu | en
  for mkr in ['.git/', '.hg/', '.svn/', '.bzr/', '_darcs/', '.vimprojects']
    let wd = call('find'.(mkr =~ '/$' ? 'dir' : 'file'), [mkr, cph.';'])
    if wd != '' | let &acd = 0 | brea | en
  endfo
  exe 'lc!' fnameescape(wd == '' ? cph : substitute(wd, mkr.'$', '.', ''))
endfunction

autocmd BufEnter * call s:setcwd()