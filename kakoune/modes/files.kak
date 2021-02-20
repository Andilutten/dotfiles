provide-module file-mode %{

# Declare the user mode
declare-user-mode files

# Declare options
declare-option str altclient 'alternate'

# Define commands
define-command st-find-file %{
	edit %sh{ st-find-file }
}
define-command st-find-file-alt %{
	evaluate-commands -try-client %opt{altclient} %sh{
		echo "edit $(st-find-file)"
	}
}
define-command st-igrep %{
	evaluate-commands %sh{
		printf %s\\n "edit $(st-igrep)"
	}
}
define-command edit-kak-config-file %{
	edit %sh{
		TMPFILE=$(mktemp)
		KAK_DIR=$HOME/.config/kak

		st bash -c "find -L $KAK_DIR -type f | sk --prompt 'Edit config: ' > $TMPFILE"
		cat $TMPFILE
	}
}

# Define aliases
alias global igrep st-igrep
alias global find-file st-find-file
alias global find-file-alt st-find-file-alt

# Define keymappings
map global user f %{: enter-user-mode files<ret>} -docstring "Files"
map global files g %{: igrep<ret> } -docstring "Interactive grep"
map global files f %{: find-file<ret>} -docstring "Find file"
map global files a %{: find-file-alt<ret>} -docstring "Find file (alternate)"
map global files k %{: edit-kak-config-file<ret>} -docstring "Edit kak config file"

}
