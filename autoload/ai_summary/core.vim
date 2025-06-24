function! ai_summary#core#CurrentFileSummary(user_prompt)
  try
    " Get file content
    let file_content = ai_summary#file#GetCurrentFileContent()

    call ai_summary#debug#DebugLog("DEBUG: Got file content length = " . strlen(file_content))

    " Build prompt
    let prompt = a:user_prompt . "\n\n" . file_content
    call ai_summary#debug#DebugLog("DEBUG: Built prompt length = " . strlen(prompt))

    " Ensure history list exists
    if !exists('g:ai_summary_history')
      let g:ai_summary_history = []
    endif

    " Append current user message to history
    call add(g:ai_summary_history, {'role': 'user', 'content': prompt})
    call ai_summary#core#SaveHistory()

    " Build JSON with full history
    let json_lines = ai_summary#api#BuildJSONRequest(g:ai_summary_history)
    call ai_summary#debug#DebugLog("DEBUG: json_lines length = " . len(json_lines))
    call ai_summary#debug#DebugLog("DEBUG: First line = " . json_lines[0])

    " Write to temp file
    let tmpfile = tempname()
    call ai_summary#debug#DebugLog("DEBUG: tmpfile = " . tmpfile)
    call writefile(json_lines, tmpfile)
    call ai_summary#debug#DebugLog("DEBUG: Wrote JSON to tmpfile")

    " Call API
    let api_response = ai_summary#api#CallOpenAIAPI(tmpfile) 
    call ai_summary#debug#DebugLog("DEBUG: API call done, response length = " . strlen(api_response))

    if strlen(api_response) > 0
      let summary_content = api_response
      " Store assistant response in history
      call add(g:ai_summary_history, {'role': 'assistant', 'content': api_response})
      call ai_summary#core#SaveHistory()
      call ai_summary#debug#DebugLog("DEBUG: Using API response as summary, length = " . strlen(summary_content))
      " Save summary to file
      let summary_file = '/tmp/ai_summary.txt'
      call writefile(split(api_response, "\n"), summary_file)

      " Show as glass window
      call ai_summary#functions#ShowGlassSummary(summary_file)

      call ai_summary#debug#FinalStatus('success')
    else
      call ai_summary#debug#DebugLog("ERROR: Empty API response")
      new
      setlocal buftype=nofile
      setlocal bufhidden=hide
      setlocal noswapfile
      call setline(1, ["ERROR: Empty API response"])
      call ai_summary#debug#FinalStatus('fail')
    endif

    " Cleanup
    call delete(tmpfile)
    call ai_summary#debug#DebugLog("DEBUG: tmpfile deleted")

  catch /.*/
    call ai_summary#debug#DebugLog("=== TOP LEVEL ERROR ===")
    call ai_summary#debug#ErrorLog(v:exception)
    call ai_summary#debug#FinalStatus('fail')
  endtry
endfunction

" Write conversation history to file
function! ai_summary#core#SaveHistory()
  if !exists('g:ai_summary_history_file')
    return
  endif
  try
    call writefile([json_encode(g:ai_summary_history)], g:ai_summary_history_file)
  catch
  endtry
endfunction

" Load conversation history from file
function! ai_summary#core#LoadHistory()
  if !exists('g:ai_summary_history_file')
    let g:ai_summary_history = []
    return
  endif
  if filereadable(g:ai_summary_history_file)
    try
      let g:ai_summary_history = json_decode(join(readfile(g:ai_summary_history_file), "\n"))
    catch
      let g:ai_summary_history = []
    endtry
  else
    let g:ai_summary_history = []
  endif
endfunction

" Reset history variable and delete file
function! ai_summary#core#ResetHistory()
  let g:ai_summary_history = []
  if exists('g:ai_summary_history_file') && filereadable(g:ai_summary_history_file)
    call delete(g:ai_summary_history_file)
  endif
endfunction

" Display the current conversation history in a scratch buffer
function! ai_summary#core#ShowHistory()
  if !exists('g:ai_summary_history') || empty(g:ai_summary_history)
    echo "No conversation history"
    return
  endif
  new
  setlocal buftype=nofile bufhidden=hide noswapfile
  call setline(1, split(json_encode(g:ai_summary_history), "\n"))
endfunction

