provide-module xclip-mode %{

declare-user-mode xclip

map global user x %{: enter-user-mode xclip<ret>} -docstring "Clipboard (xclip)"
map global xclip y %{$ xclip -selection clipboard<ret>} -docstring "Copy selection"
map global xclip p %{! xclip -selection clipboard -o<ret>} -docstring "Paste"

}
