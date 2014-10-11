" .vimrc
" For multi-byte character support (CJK support, for example):
" set fileencodings=ucs-bom,utf-8,cp936,big5,euc-jp,euc-kr,gb18030,latin1
set visualbell
set wildmenu
" set cursorline
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set showcmd
set number
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase
set backspace=2
set autoindent
" set textwidth=79
set colorcolumn=81
execute "set colorcolumn=" . join(range(81,800), ',')
set formatoptions=c,q,r,t
set ruler
set background=light
" status bar info
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2
" set mouse=a
set viminfo='10,\"100,:20,%,n~/.viminfo
autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
set list
set listchars=eol:$
set cmdheight=2
set shortmess=a
set nocp
set list listchars=tab:→\ ,trail:·
" Pathogen load
filetype off
call pathogen#infect()
call pathogen#helptags()
filetype plugin indent on
syntax on
" Install of pathogen and python mode
" mkdir -p ~/.vim/autoload ~/.vim/bundle
" cd ~/.vim/bundle
" git clone git://github.com/klen/python-mode.git
" curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
