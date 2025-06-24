" Chat interface for interactive conversation

" Open or create the chat buffer at the bottom of the window
function! ai_summary#chat#OpenChatBar()
  if exists('t:ai_summary_chat_buf') && bufexists(t:ai_summary_chat_buf)
    return
  endif
  botright split
  resize 10
  enew
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal filetype=markdown
  let t:ai_summary_chat_buf = bufnr('%')
  call setline(1, ['# AI Chat', ''])
endfunction

" Append lines to the chat buffer
function! ai_summary#chat#AppendToChat(lines)
  if exists('t:ai_summary_chat_buf') && bufexists(t:ai_summary_chat_buf)
    call appendbufline(t:ai_summary_chat_buf, '$', a:lines)
  endif
endfunction

" Send one message to the API and append the response
function! ai_summary#chat#SendMessage(prompt)
  call ai_summary#chat#OpenChatBar()
  call ai_summary#chat#AppendToChat(['You: ' . a:prompt])

  " Ensure history exists
  if !exists('g:ai_summary_history')
    let g:ai_summary_history = []
  endif

  " Store user message
  call add(g:ai_summary_history, {'role': 'user', 'content': a:prompt})
  call ai_summary#core#SaveHistory()

  " Build request
  let json_lines = ai_summary#api#BuildJSONRequest(g:ai_summary_history)
  let tmpfile = tempname()
  call writefile(json_lines, tmpfile)
  let api_response = ai_summary#api#CallOpenAIAPI(tmpfile)
  call delete(tmpfile)

  if !empty(api_response)
    call add(g:ai_summary_history, {'role': 'assistant', 'content': api_response})
    call ai_summary#core#SaveHistory()
    for l in split(api_response, "\n")
      call ai_summary#chat#AppendToChat(['AI: ' . l])
    endfor
  else
    call ai_summary#chat#AppendToChat(['AI: [error: empty response]'])
  endif

  " Keep cursor at bottom of chat buffer
  if bufwinnr(t:ai_summary_chat_buf) != -1
    execute bufwinnr(t:ai_summary_chat_buf) . 'wincmd w'
    normal! G
  endif
endfunction

" Start an interactive session using input()
function! ai_summary#chat#Start()
  call ai_summary#chat#OpenChatBar()
  while 1
    let l:prompt = input('AI> ')
    if empty(l:prompt)
      break
    endif
    call ai_summary#chat#SendMessage(l:prompt)
  endwhile
endfunction

