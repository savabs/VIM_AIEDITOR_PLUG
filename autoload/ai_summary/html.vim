function! ai_summary#html#WriteSummaryHTML(summary)
"  echom "DEBUG: Entered WriteSummaryHTML()"
"  echom "SUMMARY LENGTH: " . len(a:summary)
  call ai_summary#debug#DebugLog("DEBUG: Entered WriteSummaryHTML()" )
  call ai_summary#debug#DebugLog("SUMMARY LENGTH: " . len(a:summary)  )
  let summary_lines = split(a:summary, '\n')

  let html_template = [
        \ "<html>",
        \ "<head><title>AI Summary</title></head>",
        \ "<body style='font-family: sans-serif; padding: 20px;'>",
        \ "<h2>Summary:</h2>",
        \ "<div style='white-space: pre-wrap;'>"
        \ ] + summary_lines + [
        \ "</div>",
        \ "</body>",
        \ "</html>"
  ]

  call writefile(html_template, "/tmp/ai_summary.html")
  "  echom "DEBUG: Wrote /tmp/ai_summary.html"
  call ai_summary#debug#DebugLog("Wrote /tmp/ai_summary.html" )

  silent! execute '!gio open /tmp/ai_summary.html'
endfunction

