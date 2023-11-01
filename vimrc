" Vim configuration
" Author: Andreas Malmqvist

let g:tmuxline_powerline_separators = 0
let test#strategy = "dispatch"
let $MYTMUXRC = "~/.tmux.conf"
autocmd FileType tmux let b:dispatch = "tmux source %:p"

autocmd FileType vimwiki setl wrap linebreak textwidth=100

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:projectionist_heuristics = {
			\ "*": {
			\	".projections.json": {
			\		"type": "projections",
			\		"template": [
			\			"{open}",
			\			'	"*":{open}{close}',
			\			"{close}"
			\		]
			\	}
			\}}

call plug#begin()

Plug 'tpope/vim-sensible'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-scriptease'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-flagship'
Plug 'sainnhe/everforest'
Plug 'mattn/emmet-vim'
Plug 'jeffkreeftmeijer/vim-dim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'Andilutten/vim-laravel'
Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/GV.vim'
Plug 'tommcdo/vim-lion'
Plug 'itchyny/vim-qfedit'
Plug 'TysonAndre/php-vim-syntax'
Plug 'sheerun/vim-polyglot'
Plug 'vimwiki/vimwiki'
Plug 'fatih/vim-go'
Plug 'vim-test/vim-test'

if has('vim9script')
	Plug 'Donaldttt/fuzzyy'
	Plug 'yegappan/lsp'
	Plug 'Eliot00/auto-pairs'
endif

call plug#end()

let g:mapleader = " "

set magic
set hidden
set noswapfile
set backupdir=$HOME/.vim/backup
set splitright splitbelow
set path=**
set wildmenu
set showtabline=1
set laststatus=2
set mouse=a
set number relativenumber signcolumn=number
set nowrap
set completeopt=menuone,noinsert
set notermguicolors
set background=dark

nmap § `

autocmd ColorScheme * highlight EndOfBuffer ctermfg=0 guifg=background
colors dim

nnoremap <leader>fg <cmd>FuzzyGitFiles<cr>

function! s:buffer_on_lsp() abort
  setl formatexpr=lsp#lsp#FormatExpr()

  inoremap <buffer><expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
  nnoremap <buffer> gd <cmd>LspGotoDefinition<cr>
  nnoremap <buffer> gr <cmd>LspRename<cr>
  nnoremap <buffer> <leader>ca <cmd>LspCodeAction<cr>
  nnoremap <buffer> K <cmd>LspHover<cr>
  nnoremap <buffer> <leader>dk <cmd>LspDiagCurrent<cr>
  nnoremap <buffer> <leader>dd <cmd>LspDiagShow<cr>
endfunction

let lsp_servers = []

if executable('typescript-language-server')
	call add(lsp_servers, #{
				\ filetype: ['javascript', 'typescript', 'javascriptreact', 'typescriptreact'],
				\ path: "typescript-language-server",
				\ args: ['--stdio']
				\}) 
endif

if executable('intelephense')
	call add(lsp_servers, #{
				\ filetype: ['php'],
				\ path: "intelephense",
				\ args: ['--stdio']
				\}) 
endif

if executable('gopls')
	call add(lsp_servers, #{
				\ filetype: ['go'],
				\ path: 'gopls',
				\ args: ['serve']
				\})
endif

if executable('dart')
	call add(lsp_servers, #{
				\ filetype: ['dart'],
				\ path: 'dart',
				\ args: ['language-server', '--client-id', 'andilutten.vim']
				\})
endif


let lsp_options = #{
			\ autoHighlightDiags: v:true,
			\ noNewlineInCompletion: v:true,
			\ autoComplete: v:false,
			\ autoPopulateDiags: v:false,
			\}

if has('vim9script')
	autocmd VimEnter * call LspAddServer(lsp_servers)
	autocmd VimEnter * call LspOptionsSet(lsp_options)
	autocmd User LspAttached call <sid>buffer_on_lsp()
endif

" vim:ts=4:sw=4:noexpandtab
