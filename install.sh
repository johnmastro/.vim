#!/usr/bin/env bash

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mklink () {
    local src="$1"
    local dst="$2"

    if [ -L "$dst" ]; then
        rm "$dst"
    elif [ -e "$dst" ]; then
        mv -f "$dst" "$dst.bak"
    fi

    ln -s "$src" "$dst"
}

mklink "$here/.vimrc" "$HOME/.vimrc"
