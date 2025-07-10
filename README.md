
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

## Security Checklist

- [x] No API keys or secrets are stored in the repository
- [x] No telemetry or analytics are collected
- [x] Safe to publish this plugin on GitHub

Contributions and suggestions are welcome. Feel free to open issues or pull
requests to improve the plugin.
=======
# Local Semantic Search Engine

An AI-powered filesystem search tool that indexes documents on your machine and returns files by semantic meaning. It supports PDFs, Word documents, text files and source code. The search runs entirely locally, so no file contents leave your computer.

## How it Works

1. **Indexing** – `index_files.py` scans a directory, extracts raw text from supported formats and generates vector embeddings with [sentence-transformers](https://www.sbert.net/).
2. **Vector storage** – Embeddings are saved in a lightweight database such as [Chroma](https://github.com/chroma-core/chroma) or [FAISS](https://github.com/facebookresearch/faiss). The database files stay on disk for quick searches.
3. **Querying** – Run `query.py` with a natural language question. The script embeds the query and retrieves the top *N* most similar documents using cosine similarity.

## Setup

### Requirements

- Python 3.9 or higher
- [sentence-transformers](https://pypi.org/project/sentence-transformers/)
- [Chroma](https://github.com/chroma-core/chroma) or [FAISS](https://github.com/facebookresearch/faiss)
- `pdfminer.six`, `python-docx` and other optional extractors for different file types

Install everything with:

```bash
pip install -r requirements.txt
```

### Index Files

```bash
python index_files.py /path/to/directory
```

This creates a local vector database (for example `chroma.db/`). Run the command again to update the index when files change.

### Search

```bash
python query.py "how do I set up virtual environments?" -n 5
```

The tool prints the five most relevant file paths.

## Privacy

All indexing and queries happen locally. No documents or embeddings are sent to any external service, so your data remains private.

## Security Checklist

- [x] No API keys or secrets are hard coded in the repository
- [x] No telemetry or analytics are collected
- [x] Safe to upload publicly to GitHub

## Contributing

Feel free to open issues or pull requests with improvements. This project is intentionally simple to allow easy customization for personal workflows.

