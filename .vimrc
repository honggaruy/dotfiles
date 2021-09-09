"""""""""""""""""
"  Environment  "
"""""""""""""""""
"" Indentify platform
silent function! OSX()
  return has('macunix')
endfunction
silent function! LINUX()
  return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
  return (has('win32') || has('win64')) 
endfunction

"" Basics
" For a paranoia.
" Normalyy `:set nocp` is not needed, because it is done automatically
" when .vimrc is found.
if &compatible
	" `:set nocp` has many side effects. Therefore this should be done 
	" only when 'compatible' is set.
	set nocompatible
endif
if !WINDOWS()
	set shell=/bin/sh
endif

"" Windows Compatible
" On Windows, also use '.vim' instead of 'vimfiles'; this makes  synchroonization
" across (heterogeneous) system easier.
if WINDOWS()
	set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    " set `.vim` directory as pack repo instead of `vimfiles`
    set packpath^=~/.vim
endif

""""""""""""""""""""""
"  General settings  "
""""""""""""""""""""""

filetype off
set encoding=utf-8
set langmenu=ko_kr.utf-8
set fileencodings=utf-8,cp949
let g:session_autoload = 'no'

""""""""""""""""""""""""""""""""
"  Python Enviroment Settings  "
""""""""""""""""""""""""""""""""
" Anaconda로 py37 enviromment를 만든것을 가정함.
" 아래 설정은 윈도우즈만 지원하는데 수정필요
let $PYTHONHOME = "D:\\App\\Anaconda3\\envs\\py37"
let $PATH.= ";".$PYTHONHOME
let $PYTHONPATH = $PYTHONHOME."\\Lib;"
let $PYTHONPATH.= $PYTHONHOME."\\DLLs;"
set pythonthreehome=$PYTHONHOME
set pythonthreedll=python37.dll
" 파이썬 연동을 테스트하기 위해 아랫줄을 명령줄에서 실행해 보세요.
" :py3 import sys; print(sys.version)
" ultisnips 플러그인이 동작하기위해 파이썬 연동이 필요함.

""""""""""""
"  minpac  "
""""""""""""
"" minpac begin

" in order to use ~/.vim/pythonx/snippet_helper.py
" Please check  http://vimcasts.org/episodes/ultisnips-python-interpolation/
" and :help pythonx-directory


function! PackInit() abort
	" minpac is loaded.

	packadd minpac
	call minpac#init()

	" let minpac manage minpac, required
	call minpac#add('k-takata/minpac', {'type': 'opt'})

	" utils
	call minpac#add('scrooloose/nerdtree')
	call minpac#add('vimwiki/vimwiki')
	call minpac#add('tyru/open-browser.vim')

	" session related
	call minpac#add('mhinz/vim-startify')
	call minpac#add('xolox/vim-misc')
	call minpac#add('xolox/vim-session')

	" UI Related
	call minpac#add('morhetz/gruvbox')
	call minpac#add('vim-airline/vim-airline')

	" File type plugin
	call minpac#add('mattn/emmet-vim')
	call minpac#add('chrisbra/csv.vim')

	" Tim Pope
	call minpac#add('tpope/vim-repeat')
	call minpac#add('tpope/vim-surround')
	call minpac#add('tpope/vim-unimpaired')
	call minpac#add('tpope/vim-scriptease', {'type': 'opt'})

	" Javascript, React, ES6 ... etc
	call minpac#add('pangloss/vim-javascript')
	call minpac#add('MaxMEllon/vim-jsx-pretty')

	" Pyhton & Snippet Related
	" 아래 두줄은 이 주소를 참조하세요. URL : https://github.com/SirVer/ultisnips 
	call minpac#add('SirVer/ultisnips')
	call minpac#add('honza/vim-snippets')
	call minpac#add('isRuslan/vim-es6')
	call minpac#add('cjrh/vim-conda')

	" Always load the vim-devicons as the very last one. - vim-devions
	call minpac#add('ryanoasis/vim-devicons')

endfunction

"" normal start
filetype plugin indent on

" 키워드 사이 이용하기, Practical Vim - Tip. 55 참조, :h matchit-install
packadd! matchit
runtime macros/matchit.vim

""""""""""""""""""
"  vimrc others  "
""""""""""""""""""
"" vimrc 컬러 적용 및 기타 여러가지
source $VIMRUNTIME/vimrc_example.vim
"source $VIMRUNTIME/mswin.vim
"behave mswin
set nobackup
set number
" https://github.com/johngrib/simple_vim_guide/blob/master/md/with_korean.md
set noimd  " ESC 입력시 자동으로 영문 변환 
" 'sessionoptions' == 'ssop', 디폴트에 'winpos' 옵션까지추가
" winpos 옵션에 대한 설명은 :help ssop 참조
" string 옵션에 기존 옵션에 추가로 설정시 방법 참조 :help set+=
set ssop+=winpos

"" Editor 초기 사이즈및 폰트
set lines=30 columns=200
"set guifont=DejaVu_Sans_Mono_for_Powerline:h13:cHANGEUL:qCLEARTYPE
set guifont=D2Coding:h12:qCLEARTYPE

"" 기본 tab , indent 설정
set tabstop=2
set shiftwidth=2

"" 플러그인 설정
""" colorscheme gruvbox 설정 
" 아래 변수 설정은 colorscheme gruvbox 를 호출하기 전에 해야함.
" colorscheme gruvbox는 설정은 완료한 이후 마지막에 호출한다.
let g:gruvbox_contrast_light = 'hard'
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italicize_comments=0	" 주석에 이탤릭체 사용안함.
"highlight StatusLine gui=none
let g:gruvbox_italic=0    " 코드폴딩 주석에 italic을 적용하지 않으려면 0
colorscheme gruvbox

""" airline configuration
" Automatically displays all buffers when there's only one tab open
let g:airline#extensions#tabline#buffer_nr_show = 1		" buffer number enabled in tab line
let g:airline#extensions#tabline#enabled = 1			" tab line enabled
let g:airline#extensions#tabline#formatter = 'unique_tail'	" tab line : no path, only file name
let g:airline_powerline_fonts=1

""" ultisnips Trigger configuration. 
" Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsSnippetsDir = $HOME."/.vim/mycoolsnippets"
let g:UltiSnipsSnippetDirectories = ["UltiSnips", $HOME."/.vim/mycoolsnippets"]
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<c-b>"
let g:UltiSnipsJumpBackwardTrigger = "<c-v>"
let g:snips_author = "honggaruy"

""" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

""" chrisbra/csv.vim configuration
" Autocommand on opening/closing files
" https://github.com/chrisbra/csv.vim#autocommand-on-openingclosing-files
"let g:csv_autocmd_arrange = 1
"let g:csv_autocmd_arrange_size = 1024*1024

""" vimwiki/vimwiki configuration
" 로컬 리더 키 설정은 취향대로 설정
let maplocalleader = "\\"
let g:vim_wiki_set_path = expand('<sfile>:p:h')
let g:vimwiki_list=[
    \{
    \   'path': 'd:/repository/honggaruy.github.io/_wiki/',
    \   'syntax' : 'markdown',
    \   'ext' : '.md',
    \   'diary_rel_path': '../posts/',
    \},
    \{
    \   'path': 'd:/repository/honggaruy.github.io/_posts/',
    \   'syntax' : 'markdown',
    \   'ext' : '.md',
    \   'diary_rel_path': '.',
    \},
    \]
let g:vimwiki_table_mappings=0  " vimwiki의 테이블 단축키를 사용하지 않도록 한다. (Ultisnip 충돌)
let g:vimwiki_conceallevel=0
let g:vimwiki_global_ext=0 " :help g:vimwik_global_ext 참조. markdown이 모두 vimwiki로 바뀜 해결 
" 자주 사용하는 vimwiki 명령어에 단축키를 취향대로 매핑
command! WikiIndex :VimwikiIndex
nmap <LocalLeader>ww <Plug>VimwikiIndex
nmap <LocalLeader>wi <Plug>VimwikiDiaryIndex
nmap <LocalLeader>w<LocalLeader>w <Plug>VimwikiMakeDiaryNote
nmap <LocalLeader>wt <Plug>VimwikiTable<CR>
" F4 키를 누르면 커서가 놓인 단어를 위키에서 검색한다.
nnoremap <F4> :execute "VWS /" . expand("<cword>") . "/" <Bar> :lopen<CR>
" Shift F4 키를 누르면 현재 문서를 링크한 모든 문서를 검색한다.
nnoremap <S-F4> :execute "VWB" <Bar> :lopen<CR>

""" mhinz/vim-startify Configuration
" The directory to save/load session to/from.
let g:startify_session_dir='~/.vim/sessions'
let g:startify_lists = [
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ { 'type': 'files',     'header': ['   MRU']            },
    \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \]
let g:startify_bookmarks = [ {'c': '~/.vimrc'}, 'd:/repository/' ]

""" vim-javascript Configuration
" github home: https://github.com/pangloss/vim-javascript
" Enables syntax highlighting for JSDocs.
let g:javascript_plugin_jsdoc = 1

""" mxw/vim-jsx configuration
" jsx 문법의 하이라이팅과 인덴트를 지원해주는 플러그인
" *.jsx 뿐만 아니라 *.js에도 적용하도록 하는 구문.
let g:jsx_ext_required = 0

""" vim-devicons 설정
" vim에서 다양한 icons을 사용할 수 있도록 해줌
let g:airline_powerline_fonts = 1
let g:wedevicons_enable_startify = 1
let g:wedevicons_enable_nerdtree = 1

"" 단축키 등록 
""" 설정파일 쉽게 열기 -- 시작 
" 관련링크 : http://blog.naver.com/PostView.nhn?blogId=nfwscho&logNo=220686121995&parentCategoryNo=&categoryNo=&viewDate=&isShowPopularPosts=false&from=postView
let mapleader=","
nnoremap <Leader>rc :rightbelow vnew $MYVIMRC<CR>
" 설정파일 쉽게 열기 -- 끝 

""" Code Folding -- 시작"
" 관련링크 : https://realpython.com/blog/python/vim-and-python-a-match-made-in-heaven/
"    set foldmethod=indent
"    set foldlevel=99
"    nnoremap <space> za

"let g:SimpylFold_docstring_preview = 1
"let g:SimpylFold_import = 0

""" 창이동 설정 - 시작
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
" 창이동 설정 - 끝

""" NerdTree 설정 
nnoremap <Leader>nn :NERDTreeToggle<CR>
nnoremap <Leader>nf :NERDTreeFind<CR>

""" minpac 패키지 콘트롤 명령 설정
" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()

function! PackList(...)
	call PackInit()
	return join(sort(keys(minpac#getpluglist()))), "\n")
endfunction

" usage - `:PackOpenDir minpac`
" it will open a terminal window at `~/.vim/pack/minpac/opt/minpac`
" (or the directory where minpac is installed).
command! -nargs=1 -complete=custom,PackList
		\ PackOpenDir call PackInit() | call term_start(&shell,
		\ 	{'cwd': minpac#getpluginfo(<q-args>).dir,
		\		 'term_finish': 'close'})

" open the repository of a plugin in a web browser. This uses `open-browser.vim`
" usage - `:PackOpenUrl minpac`
command! -nargs=1 -complete=custom,PackList
		\ PackOpenUrl call PackInit() | call openbrowser#open(
		\    minpac#getpluginfo(<q-args>).url)
