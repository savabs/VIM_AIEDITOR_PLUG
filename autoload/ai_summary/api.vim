function! ai_summary#api#BuildJSONRequest(prompt) abort
    let json_body = '{' .
          \ '"model": "gpt-4o-2024-05-13", ' .
          \ '"max_tokens": 2048, ' .
          \ '"messages": [ { "role": "user", "content": "' .
          \ substitute(a:prompt, '"', '\\"', 'g') . '" } ]' .
          \ '}'
    return split(json_body, "\n")
endfunction

function! ai_summary#api#CallOpenAIAPI(tmpfile) abort
    let api_key = $OPENAI_API_KEY
    if empty(api_key)
        " Log the error to the dedicated error log file
        call ai_summary#debug#ErrorLog("OPENAI_API_KEY is empty!")
        echom "ERROR: OPENAI_API_KEY is empty!"
        return ""
    endif

    call ai_summary#debug#DebugLog("API key first 10 chars: " . strpart(api_key, 0, 10))

    let curl_cmd = "curl -s https://api.openai.com/v1/chat/completions " .
          \ "-H 'Content-Type: application/json' " .
          \ "-H 'Authorization: Bearer " . api_key . "' " .
          \ "-d @" . a:tmpfile . " | jq -r '.choices[0].message.content'"

    call ai_summary#debug#DebugLog("Curl command: " . curl_cmd)

    let result = system(curl_cmd)
    call ai_summary#debug#DebugLog("API response length: " . strlen(result))

    return result
endfunction



