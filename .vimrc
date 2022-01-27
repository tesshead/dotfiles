set ai
set ruler
set history=1000
set title
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set number
set hidden
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set signcolumn=yes
set laststatus=2

syntax enable
colorscheme vividchalk
hi Normal guibg=none

map <C-a> <ESC>^
imap <C-a> <ESC>I
map <C-e> <ESC>$
imap <C-e> <ESC>A

let mapleader = "."
nnoremap <leader>lf :FZF<CR>
nnoremap <leader><Tab> <C-W><C-W>
nnoremap <Tab> :bnext<cr>
nnoremap <S-Tab> :bprevious<cr>
nnoremap <leader>d :BD<cr>
nnoremap <Leader>gb :<C-u>call gitblame#echo()<CR>

fun! TrimWhitespace()
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfun

augroup TESSHEAD
  autocmd!
  autocmd BufWritePre * :call TrimWhitespace()
augroup END

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'rking/ag.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'lincheney/fzf-tab-completion'
Plug 'zivyangll/git-blame.vim'
call plug#end()
