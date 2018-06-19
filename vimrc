" ~/.vim/vimrc

" prelude ----------------------------------------------------------------- {{{

set runtimepath^=~/.vim

filetype off
call pathogen#infect()
filetype plugin indent on

set nocompatible

" }}}
" basic options ----------------------------------------------------------- {{{

set encoding=utf-8
setglobal fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1
set modelines=1
set scrolloff=3
set sidescrolloff=5
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest,full
set visualbell
set cursorline
if exists('&relativenumber')
   set relativenumber
else
   set number
endif
set ttyfast
set ruler
set laststatus=2
set splitbelow
set lazyredraw
set incsearch
set ignorecase
set smartcase
set showmatch
set hlsearch
set gdefault
set shortmess=atI
set completeopt=longest,menu,preview
set foldlevelstart=99  " all folds open
set cpo+=J  " stevelosh.com/blog/2012/10/why-i-two-space/ convinced me
set tabpagemax=50
set autoread
set fileformats+=mac
set sessionoptions-=options

" wildignore {{{

set wildignore+=*.py[co],*.DS_Store,*.orig,*.swp
set wildignore+=*.o,*.obj,*.exe,*.dll,*.jar
set wildignore+=.hg,.git,_darcs,.svn,.bzr
set wildignore+=*.png,*.jpg,*.jpeg,*.gif,*.bmp

" }}}
" cursorline {{{
augroup cursor_line
    autocmd!
    autocmd WinEnter * set cursorline
    autocmd WinLeave * set nocursorline
augroup END

" }}}

" }}}
" tabs, spacing, wrapping, etc -------------------------------------------- {{{

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
"set smartindent
set wrap
set textwidth=79
set formatoptions=qrn1
set backspace=indent,eol,start
set list
set listchars=tab:▸\ ,extends:»,precedes:«,trail:·

" }}}
" undo, backup, and swap -------------------------------------------------- {{{

for s:directory in ["swap", "backup", "undo"]
    let s:directory = expand("~/.tmp/vim/" . s:directory)
    if !isdirectory(s:directory)
        call mkdir(s:directory, "p")
    endif
endfor

set history=1000
set directory^=~/.tmp/vim/swap//
set backupdir^=~/.tmp/vim/backup//
set backupskip=/tmp/*,/private/tmp/* " For crontab files
set backup
if exists('&undodir')
    set undodir^=~/.tmp/vim/undo//
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

" }}}
" dictionary -------------------------------------------------------------- {{{

for s:file in ['/usr/share/dict/words', '~/Dropbox/dict/words']
    let s:file = expand(s:file)
    if filereadable(s:file)
        execute "set dictionary=" . s:file
        break
    endif
endfor

" words.utf-8.add is version controlled, .words-local.utf-8.add is not (useful
" for e.g. work stuff)
set spellfile=~/.vim/words.utf-8.add,~/.vim/.words-local.utf-8.add

" zg adds a word to the version controlled list, zG adds a word to the
" local-only list
nnoremap zG 2zg

" }}}
" interface --------------------------------------------------------------- {{{

syntax enable
set background=dark

" gvim / macvim {{{

if has('gui_running')
    set columns=90 lines=50
    set guioptions-=T
    set guioptions-=m
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
    let g:solarized_italic=0
    if has('gui_macvim')
        set guifont=menlo:h11
    elseif has('win32') || has('win64')
        set guifont=Consolas:h9
    else
        set guifont=Inconsolata\ 11
    endif
else
    set t_Co=256
    let g:solarized_termcolors=256
endif

" }}}

colorscheme solarized

" }}}
" key (re-)mapping -------------------------------------------------------- {{{

let mapleader=' '
let maplocalleader='\'

" un-shifted access to command-line mode
nnoremap ; :
vnoremap ; :

" move by screen (as opposed to file) lines
nnoremap j gj
nnoremap k gk

" more convenient beginning / end of line movements
noremap H ^
noremap L g_

" visually select the line, excluding indentation and newline
nnoremap vv ^vg_

" remember flags when repeating substitutions
nnoremap & :&&<cr>
xnoremap & :&&<cr>

" yank from the cursor to the end of the line
nnoremap Y y$

" maintain the selection when indenting/outdenting in visual mode
vnoremap > >gv
vnoremap < <gv

" more compatible regular expressions
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v

" don't outdent comments
inoremap # X<bs>#

" system clipboard interaction
noremap <leader>y "*y
noremap <f2> :call YankWholeBuffer()<cr>
vnoremap <leader>y "*ygv
vnoremap <f2> "+y

" clear search highlighting
nnoremap <silent> <leader>l :nohlsearch<cr>

" remove trailing whitespace
nnoremap <silent> <leader>w mz:%s/\s\+$//<cr>:let @/=''<cr>`z

" toggle whether trailing whitespace is shown
nnoremap <silent> <leader>T :call ToggleShowTrailing()<cr>

" create new splits
nnoremap <leader>v :vnew<cr>
nnoremap <leader>s :new<cr>

" move between splits
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

" close splits
nnoremap <leader>c <c-w>c
nnoremap <leader>o <c-w>o

" toggle folds
nnoremap <tab> za
vnoremap <tab> za

" recursively open a folded region
nnoremap zO zCzO

" }}}
" plugin settings / mappings ---------------------------------------------- {{{

" matchit {{{

if !exists('g:loaded_matchit')
    runtime! macros/matchit.vim
endif

" }}}
" fugitive {{{

map <leader>g :Gstatus <cr>

" }}}
" {{{ netrw --------------------------------------------------------------- {{{

let g:netrw_sort_by = "time"
let g:netrw_sort_direction = "reverse"
let g:netrw_sort_options = "i"  " case insensitive when by name
let g:netrw_special_syntax = 1
let g:netrw_liststyle = 1
let g:netrw_timefmt = "%Y-%m-%d %I:%M:%S %p"

if executable("ctags-exuberant")
    let g:netrw_ctags = "ctags-exuberant"
endif

"}}}
" nerdtree {{{

let NERDTreeIgnore=['\~$', '.*\.pyc$']
let NERDTreeMinimalUI = 1

map <leader>, :NERDTreeToggle ~/<cr>

" }}}
" syntastic {{{

let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['c'],
                           \ 'passive_filetypes': [] }

" }}}
" ack {{{

map <leader>a :Ack!<space>

" }}}
" ctrlp {{{

map <leader>f :CtrlP<cr>
map <leader>b :CtrlPBuffer<cr>
map <leader>r :CtrlPMRU<cr>
let g:ctrlp_working_path_mode = 'rc'
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_cache_dir = '~/.tmp/vim/ctrlp'

if has('unix')
    let g:ctrlp_user_command = [
                \ '.git/',
                \ 'git --git-dir=%s/.git ls-files -oc --exclude-standard'
                \ ]
endif

" }}}
" supertab {{{

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextDefaultCompletionType = '<c-n>'
let g:SuperTabLongestEnhanced = 1
let g:SuperTabLongestHighlight = 1
let g:SuperTabClosePreviewOnPopupClose = 1

autocmd FileType *
    \ if &omnifunc != '' |
    \     call SuperTabChain(&omnifunc, '<c-n>') |
    \     call SuperTabSetDefaultCompletionType('<c-x><c-u>') |
    \ endif

" }}}

" }}}
" file / language settings ------------------------------------------------ {{{

" colorcolumn {{{

augroup color_column
    autocmd!
    autocmd FileType clojure,lisp,python,javascript,sh,zsh,vim,rst,markdown
        \ if exists('&colorcolumn') |
        \     setlocal colorcolumn=+1 |
        \ endif
augroup END

" }}}
" vim {{{

augroup ft_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker foldlevel=0
augroup END

" }}}
" ruby {{{

augroup ft_ruby
    autocmd!
    autocmd FileType ruby setlocal et sw=2 ts=2 sts=2
augroup END

" }}}
" javascript {{{

augroup ft_javascript
    autocmd!
    autocmd FileType javascript setlocal et sw=2 ts=2 sts=2
augroup END

augroup ft_json
    autocmd!
    autocmd FileType json setlocal et sw=2 ts=2 sts=2
augroup END

" }}}
" git {{{

augroup ft_gitconfig
    autocmd!
    autocmd FileType gitconfig setlocal noexpandtab sts=0 ts=8 sw=8
augroup END

augroup ft_gitcommit
    autocmd!
    autocmd FileType gitcommit setlocal spell formatoptions+=t textwidth=72
augroup END

" }}}
" yaml {{{

augroup ft_yaml
    autocmd!
    autocmd FileType yaml setlocal et sw=2 ts=2 sts=2
augroup END

" }}}
" html {{{

augroup ft_html
    autocmd!
    autocmd FileType html setlocal et sw=2 ts=2 sts=2
    autocmd FileType html setlocal commentstring=<!--\ %s\ -->
augroup END

" }}}
" c {{{

augroup ft_c
    autocmd!
    autocmd FileType c setlocal noet sw=8 ts=8 sts=8
augroup END

" }}}
" make {{{

augroup ft_make
    autocmd!
    autocmd FileType make setlocal noet sw=8 ts=8 sts=8
augroup END

" }}}
" rst {{{

augroup ft_rst
    autocmd!
    autocmd FileType rst setlocal spell textwidth=72
augroup END

" }}}
" markdown {{{

augroup ft_markdown
    autocmd!
    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
    autocmd FileType markdown setlocal spell textwidth=72
augroup END

" }}}
" sql {{{

let g:sql_type_default = '_pgsql'

augroup ft_sql
    autocmd!
    autocmd FileType sql setlocal commentstring=--%s
augroup END

" }}}

" }}}
" status line ------------------------------------------------------------- {{{

set statusline=%f                             " path
set statusline+=%m                            " modified flag
set statusline+=%r                            " readonly flag
set statusline+=%w                            " preview window flag
set statusline+=\                             " space
set statusline+=%{fugitive#statusline()}      " git branch
set statusline+=\                             " space
set statusline+=%=                            " right align
set statusline+=(
set statusline+=%{&ff}                        " format (unix/DOS)
set statusline+=/
set statusline+=%{strlen(&fenc)?&fenc:&enc}   " encoding (utf-8)
set statusline+=/
set statusline+=%{&ft}                        " filetype
set statusline+=)
set statusline+=\ (line\ %l\/%L,\ col\ %03c)  " line & column info

" }}}
" custom function(s) ------------------------------------------------------ {{{

function! ToggleShowTrailing()
    if &list == 1
        if &listchars =~ 'trail:·'
            setlocal listchars-=trail:·
        else
            setlocal listchars+=trail:·
        endif
    else
        echom "Option '&list' not set"
    endif
endfunction

function! YankWholeBuffer()
    let saved = winsaveview()
    execute "normal! gg\"+yG"
    call winrestview(saved)
endfunction

" }}}
