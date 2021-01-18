" Vim runtime configuration
" Author: Andreas Malmqvist

let $MYVIMRC="$HOME/.vimrc"
let $MYTMUXRC="$HOME/.tmux.conf"

syntax on
filetype plugin on

" plugins {{{

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Obligatory stuff
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-rsi'
Plug 'wincent/terminus'

" Integration plugins
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'lambdalisue/vim-manpager'

" Theming
Plug 'chriskempson/base16-vim'
Plug 'jeffkreeftmeijer/vim-dim'

" IDE features
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Task/Note managment
Plug 'vimwiki/vimwiki'

" Extra syntax
Plug 'sheerun/vim-polyglot'

" Zen mode
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

call plug#end()

" }}}

" variables {{{ 
let mapleader=' '
let maplocalleader='`'
let g:vimwiki_list = [#{path: '~/Documents/'}]
let g:coc_global_extensions = [
			\ 'coc-marketplace', 
			\ 'coc-lists'
			\ ]
"}}}

" compatibility {{{

set nocompatible

if &term =~ '^screen'
    " tmux will send xterm-style keys when its xterm-keys option is on
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xRight>=\e[1;*C"
    execute "set <xLeft>=\e[1;*D"
endif

" }}}

" {{{ options


set encoding=utf8
set hidden magic
set tabstop=4 shiftwidth=4
set hlsearch incsearch
set noexpandtab
set signcolumn=number
set path=**
set ignorecase smartcase
set number relativenumber
set foldmethod=marker
set foldmarker={{{,}}}
set wildmenu
set mouse=a
set clipboard=unnamedplus
set completeopt-=preview
set completeopt+=noselect
set splitbelow splitright
set smartindent
set nowrap
set autoread
set background=dark
set t_Co=16

"}}}

" mappings {{{

nnoremap <leader>l :CocList<cr>
nnoremap <leader>g :Git

" }}}

" functions {{{

function! s:get_visual_selection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! s:default_colorscheme_overrides() abort
	highlight Folded ctermbg=8 ctermfg=none
	highlight Pmenu ctermbg=8
	highlight Visual term=none ctermbg=8
	highlight Todo ctermbg=none ctermfg=3 cterm=bold,underline
endfunction

function! s:coc_setup() abort "{{{
  " This configuration is taken from coc github page
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> <leader>r <Plug>(coc-rename)
  nnoremap <silent> gh :call <SID>show_documentation()<CR>
  nnoremap <silent> <leader>l :CocList<cr>
  nnoremap <silent> <leader>. :CocAction<cr>
  vnoremap <silent> <leader>. :CocAction<cr>
  inoremap <silent><expr> <c-@> coc#refresh()

  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)

  if exists('*complete_info')
    inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
  else
    inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
  endif

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    else
      call CocAction('doHover')
    endif
  endfunction

  command! -nargs=0 Format :call CocAction('format')
  command! -nargs=? Fold :call CocAction('fold', <f-args>)
  command! -nargs=0 OR   :call CocAction('runCommand', 'editor.action.organizeImport')
endfunction "}}}

" }}}

" common augroups {{{

augroup theming " {{{
	autocmd!
	autocmd ColorScheme * highlight EndOfBuffer ctermfg=0 guifg=bg
	autocmd ColorScheme default call <SID>default_colorscheme_overrides()
	" if filereadable(expand("~/.vimrc_background"))
	"   let base16colorspace=256
	"   source ~/.vimrc_background
	" endif
	colors dim
augroup END " }}}

augroup generic "{{{
	autocmd!
	autocmd FocusGained * checktime
augroup END "}}}

augroup terminal "{{{
	autocmd!
	if has('nvim')
		autocmd TermOpen * setl nonumber norelativenumber
	endif
augroup END "}}}

augroup zenmode " {{{
	autocmd!
	autocmd User GoyoEnter nested Limelight
	autocmd User GoyoLeave nested Limelight!
augroup END " }}}

"}}}

" language augroups {{{

augroup documenttypes "{{{
	"" This augroup is used to set up rules
	"" for 'document' filetypes like markdown
	"" and wiki files.
	autocmd!
	let filetypes = ['markdown', 'vimwiki', 'vim']
	execute("autocmd FileType " . filetypes->join(',') . " setl nonumber norelativenumber")
augroup END "}}}

augroup cfamily "{{{
	autocmd!
	autocmd FileType c,cpp packadd termdebug
	autocmd FileType c,cpp compiler gcc
    autocmd FileType c,cpp call <SID>coc_setup()

	if executable('devhelp')
		command! DevHelp call job_start('devhelp --search=' . expand('<cword>'))
	endif
augroup END "}}}

augroup golang "{{{
	autocmd!
    autocmd FileType go call <SID>coc_setup()
	autocmd FileType go compiler go
	autocmd FileType go setlocal tabstop=8 shiftwidth=8 noexpandtab
augroup END "}}}

augroup typescript "{{{
	autocmd!
	highlight! link typescriptImport Keyword
	highlight! link typescriptExport Keyword
    autocmd FileType typescript,typescriptreact,javascript,javascriptreact call <SID>coc_setup()
	autocmd FileType typescript,typescriptreact,javascript,javascriptreact setlocal 
				\ tabstop=2 
				\ shiftwidth=2 
				\ expandtab
				\ foldmarker=#region,#endregion
augroup END "}}}

augroup gdscript "{{{
	autocmd!
	autocmd FileType gdscript3,gd call <SID>coc_setup()
augroup END "}}}

augroup python "{{{
  autocmd!
  autocmd FileType python call <SID>coc_setup()
augroup END "}}}

augroup dotnet "{{{
  autocmd!
  autocmd FileType cs call <SID>coc_setup()
augroup END "}}}

" }}}
