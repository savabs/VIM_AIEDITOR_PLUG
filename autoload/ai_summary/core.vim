function! ai_summary#core#CurrentFileSummary(user_prompt)
  try
    " Get file content
    let file_content = ai_summary#file#GetCurrentFileContent()

    call ai_summary#debug#DebugLog("DEBUG: Got file content length = " . strlen(file_content))

    " Build prompt
    let prompt = a:user_prompt . "\n\n" . file_content
    call ai_summary#debug#DebugLog("DEBUG: Built prompt length = " . strlen(prompt))

    " Build JSON
    let json_lines = ai_summary#api#BuildJSONRequest(prompt)
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

