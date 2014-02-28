" load up pathogen and all bundles
filetype off
call pathogen#infect()
call pathogen#helptags()
syntax on
filetype plugin indent on

" no vi support
set nocompatible

" include system copy buffer
set clipboard+=unnamed

" enable mouse support
set mouse=a

" set up default indent/tabbing behaviour
set autoindent
set copyindent
set ts=4
set sts=4
set shiftwidth=4
set expandtab

" Code folding
set fdm=indent
set foldlevelstart=20

" Context-dependent cursor in the terminal
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Swap files. Generally things are in version control
" don't use backupfiles either.
set noswapfile
set nobackup
set nowritebackup

set encoding=utf-8
set scrolloff=3
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest,full
set wildignore+=*.o,*.obj,.git,*.rbc,*.class,.svn,vendor/gems/*,*.pyc,node_modules/*
set visualbell
set cursorline
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2
set relativenumber
set cursorline
set ttimeoutlen=100
set ruler
set nowrap
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
map <C-f> :Ag!<space>

" put useful info in status bar
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [%l,%c]\ [%L,%p%%]

" invisible character behvaiour
set list
set listchars=tab:▸\ ,eol:¬,trail:·
map <leader>l :set list!<CR>
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" save all buffers on focus lost
au FocusLost * :wa

" [[ THEMES / STYLES
" airline themeing
let g:airline_powerline_fonts=1
let g:airline_theme='base16'
" different bg colour from 101 char onwards
"let &colorcolumn=join(range(101,999),",")
" prevent text background differing from vim/term bg
highlight Normal ctermbg=NONE
highlight nonText ctermbg=NONE
" main font and colorscheme
set t_Co=256
set guifont=Source\ Code\ Pro\ for\ Powerline:h14
set background=dark
colorscheme base16-ocean
" set up some custom colors
highlight clear SignColumn
highlight Visual       ctermbg=3   ctermfg=0
highlight SpellBad     ctermbg=0   ctermfg=1
" remove/hide the border between splits
set fillchars+=vert:\ 
highlight VertSplit guifg=fg guibg=bg
" ]]

" [[ Misc Settings

" auto-add the closing }
inoremap {<CR> {<CR>}<Esc>ko

" syntastic PHP config
let g:syntastic_php_checkers=['php', 'phpmd', 'phpcs']

" user ctrp like textmate/sublime ctrl/cmd-T
let g:ctrlp_map = '<C-t>'
let g:ctrlp_max_height = 30
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 0

map <C-m> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1

" NERDTree settings
map <leader>n :NERDTreeToggle<cr>
" let g:NERDTreeWinPos = 'right'
" set guioptions-=T " remove top toolbar
set guioptions-=r " remove right scroll
set guioptions-=L " remove left scroll
" ]]


nmap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
inoremap jj <ESC>
map <leader>p :set paste!<CR>
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
nnoremap <leader>w <C-w>v<C-w>l
map <leader>W :%s/\s\+$//gce \| w<cr>
map <C-J> :bnext<CR>
map <C-K> :bprev<CR>
map <C-L> <C-W>l
map <C-H> <C-W>h

" [[ Specific File Type Settings

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" Map *.coffee to coffee type
au BufRead,BufNewFile *.coffee  set ft=coffee

" Highlight JSON like Javascript
au BufNewFile,BufRead *.json set ft=javascript

au FileType ruby set sts=2 sw=2 ts=2 expandtab
" cucumber settings
au FileType cucumber setl softtabstop=2 shiftwidth=2 tabstop=2 expandtab

" make python
au FileType python setl softtabstop=4 shiftwidth=4 tabstop=4 expandtab

" Make ruby use 2 spaces for indentation.
au FileType ruby setl softtabstop=2 tabstop=2 expandtab

" php settings
au BufRead,BufNewFile *.ctp set ft=php " cakephp view files
au filetype php setl softtabstop=4 shiftwidth=4 tabstop=4 expandtab

" Javascript settings
au FileType javascript setl softtabstop=4 shiftwidth=4 tabstop=4 expandtab

" Coffeescript uses 2 spaces too.
au FileType coffee setl softtabstop=2 shiftwidth=2 tabstop=2 expandtab

" ]]

" [[ Helper Functions

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

" ]]

" [[ xmpfilter for ruby

map <buffer> <F4> <Plug>(xmpfilter-run)
map <buffer> <F5> <Plug>(xmpfilter-mark)

" ]]

" [[ neocomplete settings
" https://github.com/Shougo/neocomplete.vim
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplete#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif

" ]]

" PHP Refactoring bundle https://github.com/vim-php/vim-php-refactoring
" needs the PHAR from
" https://github.com/QafooLabs/php-refactoring-browser/releases
let g:php_refactor_command='php /Users/david/Dropbox/Code/refactor.phar'


" BAD HABIT BREAKER (vimcasts.org)
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

