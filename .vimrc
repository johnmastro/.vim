" Compatibility shim for versions < 7.4

if version < 704 && filereadable(expand("~/.vim/vimrc"))
    execute "source " . expand("~/.vim/vimrc")
endif
