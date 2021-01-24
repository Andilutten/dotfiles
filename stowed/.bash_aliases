[ -x "$(which exa)" ] && alias ls="exa"
[ -x "$(which trash)" ] && alias rm="trash"

[ ! -z "$TMUX" ] && alias vimp="vim --servername $(tmux display-message -p '#S')"
