function! ai_summary#file#GetCurrentFileContent()
    let lines = readfile(expand('%:p'))
    return join(lines, "\n")
endfunction

