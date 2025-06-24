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

