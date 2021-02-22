evaluate-commands %sh{kak-lsp --kakoune -s $kak_session}
hook global WinSetOption filetype=(go|javascript|typescript|c|sh) %{
	lsp-enable-window
	lsp-auto-hover-enable
	lsp-auto-signature-help-enable
}
map global user l %{: enter-user-mode lsp<ret>} -docstring "LSP mode"
