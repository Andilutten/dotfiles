#!/bin/bash

[ -x "$(which exa)" ] && alias ls="exa"
[ -x "$(which trash)" ] && alias rm="trash"

[ -x "$(which sk)" ] && alias project="cd \$(find $PROJECTS -maxdepth 1 -type d | sk)"

