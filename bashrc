# bashrc
# Author: Andreas Malmqvist

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

export PS1="\[\e[0m\](\[\e[0m\]\j\[\e[0m\]) \[\e[0;1;33m\]\u\[\e[0m\]@\[\e[0;1;34m\]\W \[\e[0m\]\$(git branch --show-current 2>/dev/null) \[\e[0m\]=\[\e[0m\]> \[\e[0m\]"

if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc
