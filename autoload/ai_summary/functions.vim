function! ai_summary#functions#ShowSummaryInBuffer(summary)
    " Create new scratch buffer
    new
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal noswapfile
    setlocal nobuflisted
    setlocal filetype=markdown

    " Insert content
    call setline(1, split(a:summary, "\n"))

    " Move cursor to top
    normal! gg
endfunction


function! ai_summary#functions#ShowSummaryInFloatingWindow(summary_file)
    let cmd = "yad --text-info " .
          \ "--title='AI Summary' " .
          \ "--width=800 --height=600 " .
          \ "--fontname='monospace 12' " .
          \ "--center " .
          \ "--undecorated " .
          \ "--skip-taskbar " .
          \ "--opacity=80 " .
          \ "--filename=" . a:summary_file

    call ai_summary#debug#DebugLog("Launching YAD window: " . cmd)
    call system(cmd)
endfunction

function! ai_summary#functions#ShowGlassSummary(summary_file)
    if !filereadable(a:summary_file)
        echom "AI summary file not found: " . a:summary_file
        return
    endif
    let script = shellescape(g:ai_summary_glass)
    let file   = shellescape(a:summary_file)
    " Launch in background so Vim doesn’t block
    call system('python3 ' . script . ' ' . file . ' &')
endfunction

command! -nargs=1 GlassSummary call ai_summary#functions#ShowGlassSummary(<f-args>)

function! ai_summary#functions#ShowGlassChat()
    " Ensure PyQt5 is available before launching the UI
    silent! call system('python3 -c "import PyQt5"')
    if v:shell_error
        echoerr 'PyQt5 not found. Install python3-pyqt5 to use :AISummaryChat'
        return
    endif

    " Write current buffer to a temporary file to use as context
    let tmpfile = tempname()
    call writefile(getline(1, '$'), tmpfile)

    let script = shellescape(g:ai_summary_chat_glass)
    let filearg = shellescape(tmpfile)
    call system('python3 ' . script . ' ' . filearg . ' &')
endfunction

