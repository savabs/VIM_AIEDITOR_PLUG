
# Vim AI Summary Plugin

**Vim AI Summary** is a small plugin that sends the current buffer or a selected
markdown file to the OpenAI API and shows the result in a translucent "glass"
window. It can also maintain a conversation history, provide an interactive chat
bar, and display debug or error logs inside Vim.

## Features

- `:CurrentFileSummary {prompt}` – summarise the current buffer with the given
  prompt and display the response in a floating glass window.
- `:GlassSummary {markdown-file}` – render a markdown file in the glass viewer.
- `:AISummaryShowHistory` – open the stored conversation history in a scratch
  buffer.
- `:AISummaryPrintContext` – print the conversation history as JSON on the
  command line.
- `:AISummaryResetHistory` – clear the history list and delete the history file
  if it exists.
- `:ShowErrorLog` – open `/tmp/vim_ai_error.log` in a scratch buffer.
- `:ShowDebugLog` – open `/tmp/debug_ai_summary.log` in a scratch buffer.
- `:AISummaryChat` – start an interactive chat session. When PyQt5 is installed
  the chat opens in a glass window; otherwise a simple chat bar is used.

Conversation history is stored in the global variable `g:ai_summary_history`.
If `g:ai_summary_history_file` is defined (defaults to
`/tmp/ai_summary_history.json`), it is also written to that file for persistence
across sessions.

## Setup

### Quick start (Ubuntu/Debian)

Run the `setup.sh` helper which installs Vim, PyQt5 and the Python
dependencies, then executes the test suite:

```bash
./setup.sh
```

### Manual steps

1. Install Vim or Neovim with support for Vim script.
2. Copy the `plugin/` and `autoload/` directories into your runtime path or use a
   plugin manager such as vim-plug.
3. Set the `OPENAI_API_KEY` environment variable to your OpenAI key.
4. Optional: install PyQt5 if you want the graphical glass windows.
5. Optional: set `g:ai_summary_history_file` in your `vimrc` to change where the
   history is saved.

### Python and Tests

- Requires **Python 3.9+** for the Python scripts in `glass_summary/`.
- Install development dependencies with:

```bash
python3 -m pip install -r requirements-dev.txt
```

- Run the unit tests from the repository root:

```bash
pytest -q
```

## Privacy

Buffer contents and prompts are sent to the OpenAI API in order to generate
summaries or chat responses. The plugin does not send any additional telemetry
and the conversation history is stored only locally.


## Recommendation
- Add a short note to the setup section of the README describing how to modify ~/.vimrc (or init.vim) to include the plugin directory. Example text:

-If installing manually:
- add the below scirpt to the .vimrc
```bash
runtimepath+=/path/to/VIm_AIeditor  
```
-run 
```bash
source .vimrc
```

-Or, for Vim 8 package loading:

```bash
mkdir -p ~/.vim/pack/plugins/start
git clone https://github.com/yourname/VIm_AIeditor ~/.vim/pack/plugins/start/VIm_AIeditor
```
