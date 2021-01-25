[ -x "$(which exa)" ] && alias ls="exa"
[ -x "$(which trash)" ] && alias rm="trash"

[ ! -z "$TMUX" ] && export NVIM_LISTEN_ADDRESS="/tmp/$(tmux display -p '#S')"
