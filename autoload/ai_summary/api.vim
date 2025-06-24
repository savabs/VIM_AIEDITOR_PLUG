" Build the JSON payload from a list of messages
function! ai_summary#api#BuildJSONRequest(messages) abort
    let l:request = {
                \ 'model': 'gpt-4o-2024-05-13',
                \ 'max_tokens': 2048,
                \ 'messages': a:messages
                \ }
    let l:json_body = json_encode(l:request)
    return split(l:json_body, "\n")
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
          \ "-d @" . a:tmpfile

    call ai_summary#debug#DebugLog("Curl command: " . curl_cmd)

    let result_json = system(curl_cmd)
    call ai_summary#debug#DebugLog("Raw API response length: " . strlen(result_json))

    try
        let parsed = json_decode(result_json)
    catch
        call ai_summary#debug#ErrorLog("Failed to decode JSON: " . v:exception)
        return ""
    endtry

    if has_key(parsed, 'choices') && len(parsed.choices) > 0
        return parsed.choices[0].message.content
    elseif has_key(parsed, 'error')
        let msg = '[API error] ' . parsed.error.message
        call ai_summary#debug#ErrorLog('API error: ' . parsed.error.message)
        return msg
    else
        return ''
    endif
endfunction



