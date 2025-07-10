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
