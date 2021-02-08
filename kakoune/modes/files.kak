provide-module file-mode %{

# Declare the user mode
declare-user-mode files

# Define commands
define-command alacritty-find-file %{
	edit %sh{ alacritty-find-file }
}
define-command alacritty-igrep %{
	edit %sh{ alacritty-igrep }
}
define-command edit-kak-config-file %{
	edit %sh{
		TMPFILE=$(mktemp)
		KAK_DIR=$HOME/.config/kak

		alacritty -e bash -c "find -L $KAK_DIR -type f | sk --prompt 'Edit config: ' > $TMPFILE"
		cat $TMPFILE
	}
}

# Define aliases
alias global igrep alacritty-igrep
alias global find-file alacritty-find-file

# Define keymappings
map global user f %{: enter-user-mode files<ret>} -docstring "Files"
map global files g %{: igrep<ret> } -docstring "Interactive grep"
map global files f %{: find-file<ret>} -docstring "Find file"
map global files k %{: edit-kak-config-file<ret>} -docstring "Edit kak config file"
map global files a %{: edit ~/.config/alacritty/alacritty.yml<ret>} -docstring "Edit alacritty.ylm"

}
