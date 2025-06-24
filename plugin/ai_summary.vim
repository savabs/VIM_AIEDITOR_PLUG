call ai_summary#debug#DebugClear()
call ai_summary#debug#ErrorClear()
call ai_summary#debug#DebugLog("=== Vim started ===")

command! -nargs=1 CurrentFileSummary call ai_summary#core#CurrentFileSummary(<f-args>)

command! ShowErrorLog call ai_summary#error_file#ShowErrorLog()


command! ShowDebugLog call ai_summary#error_file#ShowDebugLog()

autocmd VimLeavePre * call ai_summary#debug#MyGlobalErrorFlush()

let g:ai_summary_glass = expand('<sfile>:p:h:h') . '/glass_summary/main.py'
let g:ai_summary_chat_glass = expand('<sfile>:p:h:h') . '/glass_summary/chat_main.py'


" Default path for conversation history file
if !exists('g:ai_summary_history_file')
  let g:ai_summary_history_file = '/tmp/ai_summary_history.json'
endif

" Load history from file if present
call ai_summary#core#LoadHistory()

" Command to reset conversation history and delete file
command! AISummaryResetHistory call ai_summary#core#ResetHistory()

" Command to display conversation history
command! AISummaryShowHistory call ai_summary#core#ShowHistory()

" Command to echo conversation history on the command line
command! AISummaryPrintContext call ai_summary#core#PrintHistory()

" Start interactive chat session

command! AISummaryChat call ai_summary#functions#ShowGlassChat()

command! AISummaryChat call ai_summary#chat#Start()


" Conversation history for providing context
let g:ai_summary_history = []

" Command to reset conversation history
command! AISummaryResetHistory let g:ai_summary_history = []


