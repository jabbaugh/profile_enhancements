set number

syntax on
filetype plugin indent on
set history=1000      " remember more commands/searches
set undolevels=1000   " remember more undo

" Show white space characters
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
set tabstop=2 softtabstop=0 expandtab shiftwidth=2 smarttab

" Removes trailing spaces
function TrimWhiteSpace()
  %s/\s*$//e
endfunction

autocmd FileType c,cpp,php,python,java,javascript,perl autocmd FileWritePre    * :call TrimWhiteSpace()
autocmd FileType c,cpp,php,python,java,javascript,perl autocmd FileAppendPre   * :call TrimWhiteSpace()
autocmd FileType c,cpp,php,python,java,javascript,perl autocmd FilterWritePre  * :call TrimWhiteSpace()
autocmd FileType c,cpp,php,python,java,javascript,perl autocmd BufWritePre     * :call TrimWhiteSpace()

