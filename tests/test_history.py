import json
import subprocess
from pathlib import Path


def run_vim_script(script_path):
    subprocess.run(["vim", "-Nu", "NONE", "-Es", "-S", str(script_path)], check=True)


def test_build_json(tmp_path):
    script = tmp_path / "script.vim"
    out_file = tmp_path / "out.txt"
    script.write_text(
        f"""
source autoload/ai_summary/api.vim
let msgs=[{{'role':'user','content':'hi'}},{{'role':'assistant','content':'yo'}}]
let res = join(ai_summary#api#BuildJSONRequest(msgs), '\\n')
call writefile([res], '{out_file}')
qa!
"""
    )
    run_vim_script(script)
    data = json.loads(out_file.read_text())
    assert data['messages'][0]['content'] == 'hi'
    assert data['messages'][1]['role'] == 'assistant'


def test_history_accumulation(tmp_path):
    script = tmp_path / "script.vim"
    out_file = tmp_path / "out.txt"
    len_file = tmp_path / "len.txt"
    script.write_text(
        f"""
source autoload/ai_summary/api.vim
let g:ai_summary_history = []
call add(g:ai_summary_history, {{'role':'user','content':'one'}})
call add(g:ai_summary_history, {{'role':'assistant','content':'two'}})
let res = join(ai_summary#api#BuildJSONRequest(g:ai_summary_history), '\\n')
call writefile([res], '{out_file}')
call writefile([string(len(g:ai_summary_history))], '{len_file}')
qa!
"""
    )
    run_vim_script(script)
    assert len_file.read_text().strip() == '2'
    data = json.loads(out_file.read_text())
    assert len(data['messages']) == 2

