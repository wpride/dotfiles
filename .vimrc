" Inspired by:
" https://github.com/edgecase/vim-config/
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc

"""""""""""""""""""""""""""""""""""""""
" General setup
"""""""""""""""""""""""""""""""""""""""
" Kill compatibility
set nocompatible

" For plugins
filetype off

" Kick on Vundle
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Bundle 'gmarik/vundle'

colorscheme desertink
set background=dark
" Fix console vim colors
set t_Co=256

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
    set guifont=Monaco:h15
endif

" Status line
:set laststatus=2
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
:hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red

" Highlight column 80
set colorcolumn=80

" Always show line numbers
set number

" Tabs settings
set sw=2 sts=2 et
augroup filetypes
    autocmd!
    autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber,slim set ai sw=2 sts=2 et
    autocmd FileType python,c,cpp,tex,htmldjango set sw=4 sts=4 et
augroup END

" Enable mouse
set mouse=a

" Store temp files elsewhere
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Searches not case-sensitive unless caps are used
set ignorecase
set smartcase

" Long history
set history=1000
set undolevels=1000

" Allow unwritten background buffers
set hidden

" Use Q for formatting instead of Ex mode
map Q gq

" Show first match as search is typed
set incsearch
" Highlight all search matches
set hlsearch

" Show trailing whitespace
set list listchars=tab:»·,trail:·
"
" Always show cursor
set ruler

" Show matching paren
set showmatch

if has("autocmd")
  " Filetype detection
  filetype plugin indent on

  " Set textwidth in text files only
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif
endif

if has("gui_running")
  " Hide the toolbar
  set go-=T

  " Don't show scrollbars
  set guioptions-=L
  set guioptions-=r
endif


"""""""""""""""""""""""""""""""""""""""
" General key mappings
"""""""""""""""""""""""""""""""""""""""
" Clear highlight searches
nnoremap <leader><space> :nohlsearch<CR>

" Select last paste or modified set of lines
nnoremap vv `[V`]

" Hide trailing whitespace annotations
nmap <silent> <leader>s :set nolist!<CR>

" Kill trailing whitespace
map <leader>c :%s/\s\+$<cr>

" Make Y consistent with C and D
nnoremap Y y$

" Hash rocket insertion
imap <C-l> <Space>=><Space>

" Insert blank lines without going into insert mode
nmap go o<esc>
nmap gO O<esc>

" Jump to previous buffer with g-enter
nmap g<CR> <C-^>

" delete all buffers
map <leader>B :bufdo bd<cr>

" Better switch split bindings
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

"""""""""""""""""""""""""""""""""""""""
" Text expands
"""""""""""""""""""""""""""""""""""""""
" Lazy rubyist
iabbrev ppry require 'pry'; binding.pry
iabbrev rdebug require 'ruby-debug'; Debugger.start; Debugger.settings[:autoeval] = 1; Debugger.settings[:autolist] = 1; debugger; 0;

" Lazy pythonista
iabbrev ppdb import ipdb; ipdb.set_trace()
iabbrev rrdb from celery.contrib import rdb; rdb.set_trace()

"""""""""""""""""""""""""""""""""""""""
" Plugins and their setup
"""""""""""""""""""""""""""""""""""""""
" Handlebars, Mustache, and Friends
Bundle 'mustache/vim-mustache-handlebars'
au BufNewFile,BufRead *.mustache,*.handlebars,*.hbs,*.hb set filetype=mustache syntax=mustache | runtime! ftplugin/mustache.vim ftplugin/mustache*.vim ftplugin/mustache/*.vim

" Coffee
Bundle 'kchmck/vim-coffee-script'
au! BufRead,BufNewFile *.coffee set filetype=coffee

" Clojure
Bundle 'vim-scripts/VimClojure'
au BufNewFile,BufRead *.clj set filetype=clojure

" The tpope shrine
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rake'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-vinegar'
Bundle 'tpope/vim-sleuth'

" ZoomWin to temporarily maximize a split
Bundle 'vim-scripts/ZoomWin'
map <leader>z :ZoomWin<CR>

" Text object selection for ruby blocks
Bundle 'nelstrom/vim-textobj-rubyblock'
" Required for rubyblock text objects
Bundle 'kana/vim-textobj-user'

" % matching for html and several other languages
Bundle 'edsono/vim-matchit'

" Colorschemes
Bundle 'toupeira/vim-desertink'
Bundle 'altercation/vim-colors-solarized'

Bundle 'scrooloose/nerdtree'
let NERDTreeIgnore = ['\.pyc$']

" Easy commenting
Bundle 'scrooloose/nerdcommenter'

" Syntax checking
" This requires associated syntax checkers to be
" installed (such as flake8 for Python)
Bundle 'scrooloose/syntastic'

" Buffer exploring
Bundle 'vim-scripts/bufexplorer.zip'
noremap <leader>e :BufExplorerHorizontalSplit<CR>

" Install tabular and set up common tabulated shortcuts
Bundle 'godlygeek/tabular'
function! CustomTabularPatterns()
    if exists('g:tabular_loaded')
        AddTabularPattern! symbols         / :/l0
        AddTabularPattern! hash            /^[^>]*\zs=>/
        AddTabularPattern! chunks          / \S\+/l0
        AddTabularPattern! assignment      / = /l0
        AddTabularPattern! comma           /^[^,]*,/l1
        AddTabularPattern! colon           /:\zs /l0
        AddTabularPattern! options_hashes  /:\w\+ =>/
    endif
endfunction
autocmd VimEnter * call CustomTabularPatterns()

Bundle 'kien/ctrlp.vim'
nnoremap <leader>b :<C-U>CtrlPBuffer<CR>
nnoremap <leader>t :<C-U>CtrlP<CR>
nnoremap <leader>T :<C-U>CtrlPTag<CR>
" Toggle working path mode (important for submodules)
map <leader>p :let g:ctrlp_working_path_mode = 'a'<cr>
map <leader>P :let g:ctrlp_working_path_mode = 'ra'<cr>
" Respect the .gitignore
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others']

" Undo tree
Bundle "git://github.com/sjl/gundo.vim.git"
map <leader>h :GundoToggle<CR>

" AG for search
Bundle 'git://github.com/rking/ag.vim.git'
nmap g/ :Ag!<space>
nmap g* :Ag! -w <C-R><C-W><space>
nmap ga :AgAdd!<space>
nmap gn :cnext<CR>
nmap gp :cprev<CR>
nmap gq :ccl<CR>
nmap gl :cwindow<CR>
" Install ack as well due to --type being helpful
Bundle 'mileszs/ack.vim'

" Parse coverage reports
Bundle 'alfredodeza/coveragepy.vim'

" Tagbar for navigation by tags using CTags
Bundle "git://github.com/majutsushi/tagbar.git"
let g:tagbar_autofocus = 1
map <leader>rt :!ctags --extra=+f -R *<CR><CR>
map <leader>. :TagbarToggle<CR>
