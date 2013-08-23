" load up pathogen and all bundles
filetype off
call pathogen#infect()
call pathogen#helptags()
syntax on
filetype plugin indent on

" no vi support
set nocompatible

" set up default indent/tabbing behaviour
set autoindent
set copyindent
set ts=4
set sts=4
set shiftwidth=4
set expandtab

set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest,full
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set relativenumber
set mouse=a
set cursorline
set ttimeoutlen=100
set ruler
set nowrap
set backspace=indent,eol,start
set colorcolumn=
set hidden

" set leader key to comma
let mapleader = ","

" saner searching
set showmatch
set ignorecase
set hlsearch
set smartcase
set incsearch
set gdefault
nnoremap <tab> %
vnoremap <tab> %
map <leader><space> :nohl<cr>
" map Silver Searcher
map <leader>a :Ag!<space>

" put useful info in status bar
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [%l,%c]\ [%L,%p%%]

" invisible characer behvaiour
set list
set listchars=tab:▸\ ,eol:¬
map <leader>l :set list!<CR>
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" save all buffers on focus lost
au FocusLost * :wa

" set up some custom colors
highlight clear SignColumn
highlight VertSplit    ctermbg=236
highlight ColorColumn  ctermbg=237
highlight LineNr       ctermbg=236 ctermfg=240
highlight CursorLineNr ctermbg=236 ctermfg=240
highlight CursorLine   ctermbg=236
highlight StatusLineNC ctermbg=238 ctermfg=0
highlight StatusLine   ctermbg=240 ctermfg=12
highlight IncSearch    ctermbg=0   ctermfg=3
highlight Search       ctermbg=Yellow   ctermfg=LightGray
highlight Visual       ctermbg=3   ctermfg=0
highlight Pmenu        ctermbg=240 ctermfg=12
highlight PmenuSel     ctermbg=0   ctermfg=3
highlight SpellBad     ctermbg=0   ctermfg=1
highlight ColorColumn ctermbg=238

" theme for MacVim
if has("gui_running")
    colorscheme Tomorrow-Night
    set guifont=Bitstream\ Vera\ Sans\ Mono:h14
end

" highlight the status bar when in insert mode
if version >= 700
  au InsertEnter * hi StatusLine ctermfg=LightGreen ctermbg=Red
  au InsertLeave * hi StatusLine ctermbg=LightGray ctermfg=Black
endif

" map markdown preview
map <leader>m :!open -a Marked %<cr><cr>

" ctrlp config
let g:ctrlp_map = '<leader>f'
let g:ctrlp_max_height = 30
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 0

" navigate through buffers
map <C-J> :bnext<CR>
map <C-K> :bprev<CR>
map <C-L> <C-W>l
map <C-H> <C-W>h

" use /tmp for all swap files
set backupdir=/tmp


" delete all trailing whitespace in current file
map <leader>W :%s/\s\+$//gce \| w<cr>

" Run specs with ',t' via Gary Bernhardt
function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !clear
  if match(a:filename, '\.feature$') != -1
    exec ":!script/features " . a:filename
  elseif match(a:filename, '_test\.rb$') != -1
    exec ":!ruby -Itest " . a:filename
  else
    if filereadable("script/test")
      exec ":!script/test " . a:filename
    elseif filereadable("Gemfile")
      exec ":!bundle exec rspec --color " . a:filename
    else
      exec ":!rspec --color " . a:filename
    end
  end
endfunction

function! SetTestFile()
  " Set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " Run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number . " -b")
endfunction

" run test runner
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>

" auto-add the closing }
inoremap {<CR> {<CR>}<Esc>ko

" map cake test call to a hotkey
map <leader>ct :!../cake/console/cake testsuite<space>

" add hotkey map to paste model toggle
map <leader>p :set paste!<CR>

" hot key for method list
map <leader>r :TlistToggle<CR>
let Tlist_Use_Right_Window   = 1
let tlist_php_settings = 'php;c:class;f:function;d:constant'

let g:syntastic_php_checkers=['php'] ", 'phpmd', 'phpcs']

map <leader>n :NERDTree<space>

map <silent> <leader>zz !find . -name '*.php' -exec ctags {} +

" Quickly edit/reload the vimrc file
nmap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" map double j to esc to exit insert mode
inoremap jj <ESC>

" open a new buffer in a veritcal split and switch focus to it
nnoremap <leader>w <C-w>v<C-w>l

" quick git commit of current file
map <leader>co :!git commit %<cr>
