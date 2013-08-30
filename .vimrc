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

" Context-dependent cursor in the terminal
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7""

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
map <leader>a :Ag!<space>

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

" [[ Theming/Colors

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

" theme for MacVim/GVim
if has("gui_running")
    colorscheme solarized
    set background=light
    set guifont=Bitstream\ Vera\ Sans\ Mono:h14
end

" ]]

" [[ Misc Settings

" auto-add the closing }
inoremap {<CR> {<CR>}<Esc>ko

" syntastic PHP config
let g:syntastic_php_checkers=['php'] ", 'phpmd', 'phpcs']

" ]]

" [[ Keybindings

" NerdTree config
map <leader>n :NERDTreeToggle<cr>

" Quickly edit/reload the vimrc file
nmap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" map double j to esc to exit insert mode
inoremap jj <ESC>

" open a new buffer in a veritcal split and switch focus to it
nnoremap <leader>w <C-w>v<C-w>l

" map cake test call to a hotkey
map <leader>ct :!../cake/console/cake testsuite<space>

" add hotkey map to paste model toggle
map <leader>p :set paste!<CR>

" TagList configuration
map <leader>r :TagbarToggle<CR>

" ruby test runners
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>

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

" traverse windows
map <C-L> <C-W>l
map <C-H> <C-W>h

" delete all trailing whitespace in current file
map <leader>W :%s/\s\+$//gce \| w<cr>

" ]]

" [[ Specific File Type Settings

" Thorfile, Rakefile, Vagrantfile and Gemfile are Ruby
au BufRead,BufNewFile {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru}    set ft=ruby

" Map *.coffee to coffee type
au BufRead,BufNewFile *.coffee  set ft=coffee

" Highlight JSON like Javascript
au BufNewFile,BufRead *.json set ft=javascript

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
