" 출처: https://johngrib.github.io/wiki/vimwiki/
" 템플릿에서 updated의 시간을 자동으로 현재 시간으로 수정해주는 함수
" If buffer modified, update any 'Last modified: ' in the first 20 lines.
" 'Last modified: ' can have up to 10 characters before (they are retained).
" Restores cursor and window position using save_cursor variable.
function! LastModified()
    if g:md_modify_disabled
        return
    endif
    if &modified
        " echo('markdown updated time modified')
        let save_cursor = getpos(".")
        let n = min([10, line("$")])
        exe 'keepjumps 1,' . n . 's#^\(.\{,10}updated\s*: \).*#\1' .
            \ strftime('%Y-%m-%d %H:%M:%S +0900') . '#e'
        call histdel('search', -1)
        call setpos('.', save_cursor)
    endif
endfunction

" g:vimwiki_list 배열의 path 경로를 확인하여, 현재 파일이 Vimwiki의 하위
" 경로에 있고, 내용이 한줄 밖에 없다면 메타 데이터 기본 값을 넣어주는 함수
function! NewTemplate()
    let l:wiki_directory = v:false
    for wiki in g:vimwiki_list
        if expand('%:p:h') . '\'  == expand(wiki.path)
            let l:wiki_directory = v:true
            break
        endif
    endfor
    if !l:wiki_directory
        return
    endif
    if line("$") > 1
        return
    endif
    let l:template = []
    call add(l:template, '---')
    call add(l:template, 'layout  : wiki')
    call add(l:template, 'title   : ')
    call add(l:template, 'summary : ')
    call add(l:template, 'date    : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'updated : ' . strftime('%Y-%m-%d %H:%M:%S +0900'))
    call add(l:template, 'tag     : ')
    call add(l:template, 'toc     : true')
    call add(l:template, 'public  : true')
    call add(l:template, 'parent  : ')
    call add(l:template, 'latex   : false')
    call add(l:template, '---')
    call add(l:template, '* TOC')
    call add(l:template, '{:toc}')
    call add(l:template, '')
    call add(l:template, '# ')
    call setline(1, l:template)
    execute 'normal! G'
    execute 'normal! $'
    echo 'new wiki page has created'
endfunction

" 위 함수가 자동으로 호출되도록 autocmd로 등록해준다.
augroup vimwikiauto
    autocmd BufWritePre *wiki/*.md call LastModified()
    autocmd BufRead,BufNewFile *wiki/*.md call NewTemplate()
augroup END

let g:md_modify_disabled = 0
