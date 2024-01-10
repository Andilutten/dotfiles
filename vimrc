" Vim configuration
" Author: Andreas Malmqvist
let g:vimwiki_list = [#{path: '~/vimwiki/',
			\ template_path: '~/vimwiki/templates/',
			\ template_default: 'default',
			\ template_ext: '.html'}]
let test#strategy = "dispatch"
let g:graphviz_output_format = 'svg'
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
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-dotenv'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-flagship'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-obsession'

Plug 'junegunn/vim-peekaboo'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/GV.vim'

Plug 'chriskempson/base16-vim'
Plug 'nicwest/vim-http'
Plug 'vim-vdebug/vdebug'
Plug 'liuchengxu/graphviz.vim'
Plug 'isobit/vim-caddyfile'
Plug 'sainnhe/everforest'
Plug 'NLKNguyen/papercolor-theme'
Plug 'mattn/emmet-vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'Andilutten/vim-laravel'
Plug 'itchyny/vim-qfedit'
Plug 'TysonAndre/php-vim-syntax'
Plug 'sheerun/vim-polyglot'
Plug 'vimwiki/vimwiki'
Plug 'fatih/vim-go'
Plug 'vim-test/vim-test'

if has('vim9script') && v:version >= 900
	Plug 'Donaldttt/fuzzyy'
	Plug 'yegappan/lsp'
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
set showtabline=2
set laststatus=2
set mouse=a
set number relativenumber signcolumn=number
set nowrap
set completeopt=menuone,noinsert
set shell=/bin/bash
set background=dark

nmap § `

function! s:base16_overrides() abort
	hi! link SpellLocal SignifySignChange
	hi! link SpellBad SignifySignDelete
endfunction

augroup base16
	autocmd!
	autocmd ColorScheme base16-* call <sid>base16_overrides()
augroup END

if !has('gui_running')
	if exists('$BASE16_THEME')
		let base16colorspace=256
		colorscheme base16-$BASE16_THEME
	else
		set termguicolors
		set background=light
		colors everforest
	endif
endif

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

nnoremap <leader>fg <cmd>FuzzyGitFiles<cr>
nnoremap <leader>fG <cmd>FuzzyGrep<cr>

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

if executable('vim-language-server')
	call add(lsp_servers, #{
				\ filetype: ["vim"],
				\ path: "vim-language-server",
				\ args: ["--stdio"]
				\ })
endif

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

let lsp_options = #{
			\ autoHighlightDiags: v:true,
			\ noNewlineInCompletion: v:true,
			\ autoComplete: v:true,
			\ autoPopulateDiags: v:true,
			\ omniComplete: v:true
			\}

if has('vim9script') && v:version >= 900
	autocmd VimEnter * call LspAddServer(lsp_servers)
	autocmd VimEnter * call LspOptionsSet(lsp_options)
	autocmd User LspAttached call <sid>buffer_on_lsp()
endif

" vim:ts=4:sw=4:noexpandtab
