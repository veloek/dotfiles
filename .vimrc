" Pathogen packages
execute pathogen#infect()

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Color theme
colorscheme pablo


" Fast saving
nmap <leader>w :w!<cr>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W w !sudo tee % > /dev/null

" Set 5 lines to the cursor - when moving vertically using j/k
set so=5

" Turn on the WiLd menu
set wildmenu

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
    set wildignore+=.git\*,.hg\*,.svn\*
endif

"Always show current position
set ruler

" A buffer becomes hidden when it is abandoned
set hid

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" In many terminal emulators the mouse works just fine, thus enable it.
"if has('mouse')
"  set mouse=a
"endif

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Enable syntax highlighting
syntax enable

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type
set ffs=unix,dos,mac

" Use spaces instead of tabs
set expandtab

" Be smart when using tabs ;)
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4

" Linebreak on 500 characters
set lbr
set tw=500

set ai "Auto indent
"set si "Smart indent
set wrap "Wrap lines

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f', '')<CR>
vnoremap <silent> # :call VisualSelection('b', '')<CR>

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ack \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Treat long lines as break lines (useful when moving around in them)
nnoremap j gj
nnoremap k gk

" Clear highlighted search results
nmap <Leader><esc> :noh<cr>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>
endif

" Delete trailing white space on save
func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc
autocmd BufWrite * :call DeleteTrailingWS()

" Remove the Windows ^M - when rhe encodings gets messed up
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Add a bit extra margin to the left
" set foldcolumn=1

" Page up/down
"nmap <C-j> <C-f>
"nmap <C-k> <C-b>

" Previously edited buffer
nmap <leader>b :b#<cr>

" Close current buffer (and keep vsplit)
nmap <leader>c :bd<cr>:vsplit<cr>:wincmd l<cr>:bn<cr>

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" Set ruler color
highlight ColorColumn ctermbg=DarkGrey

" Dampen the color of line numbers
highlight LineNr ctermfg=LightGrey

" Do vertical split for new windows
set splitbelow

" Vim-go specific settings
let g:go_fmt_command="goimports"
let g:go_highlight_types=1
"let g:go_highlight_function_calls=1
let g:go_highlight_function_arguments=1
let g:go_highlight_functions=1
let g:go_imports_autosave=1
let g:go_imports_mode='goimports'

" Vim-OmniSharp specific settings
"let g:OmniSharp_server_use_mono=1
"let g:OmniSharp_server_use_net6=1

" Show line numbers
set number
set relativenumber

" Show filename in status bar
set laststatus=2

" Git commit settings
augroup git_settings
    autocmd!
    " Wrap text at 72 cols
    autocmd FileType gitcommit set textwidth=72
    " Show vertical ruler at textwidth+1
    autocmd FileType gitcommit set colorcolumn=51,73
augroup END

" Show ruler at 81 cols for selected file types
augroup ruler_settings
    autocmd!
    autocmd FileType c,go set colorcolumn=81
augroup END

" Disable automatic comment continuation on next line
autocmd FileType * set formatoptions-=cro

" Mark trailing spaces as errors
match IncSearch '\s\+$'

" Toggle on/off background to fix theme colors
set background=light
set background=dark

" FZF setup
let $FZF_DEFAULT_COMMAND='find . \( -name node_modules -o -name .git -o -name bin -o -name obj \) -prune -o -print'
set rtp+=/opt/homebrew/opt/fzf
nmap <leader><leader> :FZF<cr>

" Tabs
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt
noremap <leader>0 :tablast<cr>
