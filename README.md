# VIm AIeditor

This repository contains a small helper library used by the Vim AI plugin.

## Running Tests

1. Install dependencies::

    pip install -r requirements-dev.txt

2. Run `pytest` from the repository root::

    pytest

## Viewing the conversation context

The plugin stores chat history in the global Vim variable `g:ai_summary_history`.
If the variable `g:ai_summary_history_file` is defined (it defaults to
`/tmp/ai_summary_history.json`), the history is also written to that file so that
it persists across Vim sessions.

You can inspect the current context directly from Vim using:

```
:AISummaryPrintContext
```

to echo the JSON representation of the stored messages.  Alternatively, use

```
:AISummaryShowHistory
```

to open the history in a scratch buffer.

## Vim Commands

The plugin provides several commands that can be run directly from Vim.  Each
one performs a specific action to help drive the summarizer.

- `:CurrentFileSummary {prompt}` – summarises the current buffer using the
  supplied text and shows the result in a floating "glass" window.
- `:GlassSummary {markdown-file}` – opens the given Markdown file in the glass
  viewer.
- `:AISummaryShowHistory` – opens the stored conversation history in a scratch
  buffer.
- `:AISummaryPrintContext` – prints the same history as JSON on the command
  line.
- `:AISummaryResetHistory` – clears the history variable and removes the
  history file.
- `:ShowErrorLog` – displays the error log located at `/tmp/vim_ai_error.log`.
- `:ShowDebugLog` – displays the debug log located at `/tmp/debug_ai_summary.log`.
- `:AISummaryChat` – opens a glass window with an integrated chat bar for
  continuous conversation with the AI (requires the `python3-pyqt5` package).
  The current buffer is sent as the initial context so you can ask
  questions about the file you were editing.


