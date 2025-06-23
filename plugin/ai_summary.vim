call ai_summary#debug#DebugClear()
call ai_summary#debug#ErrorClear()
call ai_summary#debug#DebugLog("=== Vim started ===")

command! -nargs=1 CurrentFileSummary call ai_summary#core#CurrentFileSummary(<f-args>)

command! ShowErrorLog call ai_summary#error_file#ShowErrorLog()


command! ShowDebugLog call ai_summary#error_file#ShowDebugLog()

autocmd VimLeavePre * call ai_summary#debug#MyGlobalErrorFlush()

let g:ai_summary_glass = expand('<sfile>:p:h:h') . '/glass_summary/main.py'

