import subprocess
from pathlib import Path


def run_vim_script(script_path):
    subprocess.run(["vim", "-Nu", "NONE", "-Es", "-S", str(script_path)], check=True)


def test_open_chat_bar(tmp_path):
    script = tmp_path / "script.vim"
    out_file = tmp_path / "out.txt"
    script.write_text(f"""
source autoload/ai_summary/chat.vim
call ai_summary#chat#OpenChatBar()
let res = bufexists(t:ai_summary_chat_buf) ? 'yes' : 'no'
call writefile([res], '{out_file}')
qa!
""")
    run_vim_script(script)
    assert out_file.read_text().strip() == 'yes'


def test_send_message_accumulates_history(tmp_path):
    script = tmp_path / "script.vim"
    len_file = tmp_path / "len.txt"
    script.write_text(f"""
source autoload/ai_summary/chat.vim
source autoload/ai_summary/core.vim
source autoload/ai_summary/api.vim
function! ai_summary#api#CallOpenAIAPI(tmp) abort
  return 'reply'
endfunction
call ai_summary#chat#SendMessage('hello')
call writefile([string(len(g:ai_summary_history))], '{len_file}')
qa!
""")
    run_vim_script(script)
    assert len_file.read_text().strip() == '2'
