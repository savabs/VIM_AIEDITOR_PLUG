" debug.vim

" Path for error log
let g:vim_ai_error_logfile = "/tmp/vim_ai_error.log"

" Logs a single line message
function! ai_summary#debug#DebugLog(msg)
    call writefile([a:msg], "/tmp/debug_ai_summary.log", "a")
endfunction

" Logs multiple lines (list of lines)
function! ai_summary#debug#DebugLogLines(lines)
    call writefile(a:lines, "/tmp/debug_ai_summary.log", "a")
endfunction

" Logs JSON string as pretty lines
function! ai_summary#debug#DebugLogJSON(json_string)
    let lines = split(a:json_string, '\n\|\r\|\r\n')
    call ai_summary#debug#DebugLog("----- JSON -----")
    call ai_summary#debug#DebugLogLines(lines)
    call ai_summary#debug#DebugLog("----------------")
endfunction

" Clear debug log
function! ai_summary#debug#DebugClear()
    call writefile([], expand('/tmp/debug_ai_summary.log'))
endfunction

" Clear error log
function! ai_summary#debug#ErrorClear()
    call writefile([], g:vim_ai_error_logfile)
endfunction

" Error log message 
function! ai_summary#debug#ErrorLog(msg)
    " Get the calling script name and line number
    let l:file = expand('<sfile>')
    let l:line = expand('<slnum>')

    " Build log entry with context
    let l:log_entry = printf("[%s:%s] %s", l:file, l:line, a:msg)

    " Append to error log file
    call writefile([l:log_entry], '/tmp/vim_ai_error.log', 'a')

    " Optional: show on command line
    echom l:log_entry
endfunction




" Final status tag
function! ai_summary#debug#FinalStatus(status)
    call ai_summary#debug#DebugLog("=== FINAL STATUS: " . a:status . " ===")
endfunction

" Global error catcher
function! ai_summary#debug#MyGlobalErrorFlush()
    if v:errmsg != ''
        call ai_summary#debug#DebugLog("=== GLOBAL VIM ERROR ===")
        call ai_summary#debug#ErrorLog(v:errmsg)
        call ai_summary#debug#FinalStatus('fail')
    endif
endfunction

