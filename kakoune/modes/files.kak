echo -debug "This comes from the files module"
provide-module file-mode %{

declare-user-mode files

map global user f %{: enter-user-mode files<ret>} -docstring "Files"
define-command -docstring "Find files using skim through tmux" tmux-find-file %{
	edit %sh{ tmux-find-file }
}
define-command -docstring "Find files using skim through alacritty" alacritty-find-file %{
	edit %sh{ alacritty-find-file }
}
define-command -docstring "Interactive grep using skim through alacritty" alacritty-igrep %{
	edit %sh{ alacritty-igrep }
}
alias global igrep alacritty-igrep
evaluate-commands %sh{
	test -z "$TMUX" \
       	&& echo "alias global find-file alacritty-find-file" \
       	|| echo "alias global find-file tmux-find-file"
}
map global files g %{: igrep<ret> } -docstring "Interactive grep"
map global files f %{: find-file<ret>} -docstring "Find file"
map global files k %{: edit ~/.config/kak/kakrc<ret>} -docstring "Edit kakrc"
map global files a %{: edit ~/.config/alacritty/alacritty.yml<ret>} -docstring "Edit alacritty.ylm"
}
