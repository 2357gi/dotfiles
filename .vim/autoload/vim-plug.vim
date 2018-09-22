call plug#begin(expand('~/.vim/plugged'))
	Plug 'scrooloose/nerdtree'
	Plug 'jistr/vim-nerdtree-tabs'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'w0rp/ale'
	Plug 'scrooloose/syntastic'
	" Plug 'davidhalter/jedi-vim'
	" Plug 'tpope/vim-commentary'
	" Plug 'reireias/vim-cheatsheet'
	" Plug 'thinca/vim-splash'
	" Plug 'Shougo/vimproc.vim'
	" Plug 'yuratomo/w3m.vim'
if v:version >= 703
	" Plug 'Shougo/vimshell.vim'
endif
call plug#end()

