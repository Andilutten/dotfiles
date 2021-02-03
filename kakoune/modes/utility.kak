provide-module utility-mode %{

declare-user-mode utilities

map global user u %{: enter-user-mode utilities<ret>} -docstring "Utilities"

define-command insert-date -docstring "
inserts a date using the date command using format YYYY-MM-DD.
If an argument is passed it will be expanded with the --date option.
Defaults to today
" -params 0..1 %{
	set-register d %sh{
		DATE=${1:-today}
		echo $(date --date="$DATE" +"%Y-%m-%d")
	}
	execute-keys i<c-r>d<esc>
	set-register d ''
}

define-command open-url -docstring "
Open a url in the current buffer with w3m using alacritty and skim
" %{
	evaluate-commands %sh{
		TMPFILE=$(mktemp)
		cat $kak_buffile | extract_urls > $TMPFILE
		echo "terminal bash -c 'sk --prompt \"Open in w3m: \" < $TMPFILE | xargs w3m'"
	}
}

map global utilities w %{: open-url<ret>} -docstring "Open url in w3m"

}
