" for *.tex
" sourced by ~/.vim/ftplugin/tex.vim

set ts=4
set sts=4
set textwidth=128
set iskeyword+=_
set formatoptions+=2mM

" let g:tex_stylish=1 into your <.vimrc> will make <syntax/tex.vim>
" always accept such use of @
let b:tex_stylish = 1
" Controlling iskeyword '_'
let g:tex_stylish = 1

" user defined function
" allow calling without argument
function! <SID>Tex_todo_rt(...)

	let s:opts = ''
	if a:0 > 0
		for x in a:000
			let s:opts .= " ".x
		endfor
	endif

	if a:0 > 0 && a:1 == 'view'
		exec ':silent! !make' .s:opts
		exec ':redraw!'
	else
		" if write, same as 'make force', pay attention to the space
		" exec 'write!'
		exec ':!make' .s:opts
	endif
endfunction

" map method: /usr/share/vim/vimfiles/ftplugin/latex-suite/main.vim

" args: view + make_opts
command! -complete=customlist,Dort_opts -nargs=* Dxrt :call <SID>Tex_todo_rt(<f-args>)
command! Dx  :Dxrt
command! Dxv :Dxrt view
command! Dxr :Dxrt refresh
command! Dxc :Dxrt clean
command! DxC :Dxrt clobber
command! Dxb :Dxrt backup
" or more complicated options like `make circle=1 BIBTEX=biber' and etc..

" completion
function! Dort_opts(ArgLead, CmdLine, CursorPos)
	return split("view refresh quiet clean clobber latexmk backup backup_more"," ")
endfunction

" '.' is used as a delimeter, especialy in `let' expr, space is ignored
" let s:var, refer to: `help let'

" vim: set sts=4 ts=4 :
