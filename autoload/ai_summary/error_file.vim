function! ai_summary#error_file#ShowErrorLog()
    new
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal filetype=log
    setlocal wrap
    setlocal linebreak
    setlocal foldmethod=manual
    silent! execute 'read /tmp/vim_ai_error.log'
    normal! gg
endfunction



" Shows Debug Log in buffer
function! ai_summary#error_file#ShowDebugLog()
    new
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal filetype=log
    setlocal wrap
    setlocal linebreak
    setlocal foldmethod=manual
    silent! execute 'read /tmp/debug_ai_summary.log'
    normal! gg
endfunction

