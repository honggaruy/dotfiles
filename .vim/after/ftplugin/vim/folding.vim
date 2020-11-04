""""""""""""""""""""""""""""""""
"  This Is A Example Category  "
""""""""""""""""""""""""""""""""
" 이 파일은 아래 링크를 참조하여 작성되었다.
" 현재 SirVer/ultisnips이 적용되어 있으므로 
" 위 카테고리 작성시에는 insert mode에서 box<tab>을 눌러 작성한다 
" https://vi.stackexchange.com/a/6608
"" This is A Example Subfolder
""" This is A Example SubSubFolder

""""""""""""""""""""""""
"  AutoFolding .vimrc  "
""""""""""""""""""""""""
" see http://vimcasts.org/episodes/writing-a-custom-fold-expression/
"" defines a foldlevel for each line of code
function! VimFolds(lnum)
    let s:thisline = getline(a:lnum)
    if match(s:thisline, '^"" ') >= 0
	    return '>2'
    endif
    if match(s:thisline, '^""" ') >= 0
        return '>3'
    endif
    let s:two_following_lines = 0
    if line(a:lnum) + 2 <= line('$')
        let s:line_1_after = getline(a:lnum+1)
        let s:line_2_after = getline(a:lnum+2)
        let s:two_following_lines = 1
    endif
    if !s:two_following_lines
        return '='
    else
        if (match(s:thisline, '^"""""') >= 0) &&
            \ (match(s:line_1_after, '^"  ') >= 0) &&
            \ (match(s:line_2_after, '^""""') >= 0)
            return '>1'
        else
            return '='
        endif
    endif
endfunction

"" defines a foldtext
" 특수문자 입력 방법 : 
" step1. : ':digraphs' 명령으로 어떤 문자 적용할지 확인
" step2. : insert mode에서 ctrl + k 누른후 위에서 찾아낸 문자코드 두자리 입력
function! VimFoldText()
    " handle special case of normal comment first
    let s:info = '('.string(v:foldend-v:foldstart).' l)'
    if v:foldlevel == 1
        let s:line = ' ◊ '.getline(v:foldstart+1)[3:-2]
    elseif v:foldlevel == 2
        let s:line = '   ●  '.getline(v:foldstart)[3:]
    elseif v:foldlevel == 3
        let s:line = '     ▪ '.getline(v:foldstart)[4:]
    endif
    if strwidth(s:line) > 80 - len(s:info) - 3
        return s:line[:79-len(s:info)-3+len(s:line)-strwidth(s:line)].'∙∙∙'.s:info
    else
        return s:line.repeat(' ', 80 - strwidth(s:line) - len(s:info)).s:info
    endif
endfunction
    

"" set foldsettings automatically for vim files
" 참조 링크 답변대로하면 적용되지 않아서 일단 풀어서 적용함
setlocal foldmethod=expr
setlocal foldexpr=VimFolds(v:lnum)
setlocal foldtext=VimFoldText()
"set foldcolumn=2 foldminlines=2
