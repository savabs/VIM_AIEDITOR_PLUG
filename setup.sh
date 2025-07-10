#!/usr/bin/env bash
set -euo pipefail

# Install system packages if apt-get is available
if command -v apt-get >/dev/null; then
    echo "Installing Vim and PyQt5 via apt-get..."
    sudo apt-get update
    sudo apt-get install -y vim python3-pyqt5 curl
else
    echo "Please install Vim, PyQt5, and curl using your system package manager."
fi

# Install Python dependencies
python3 -m pip install -r requirements-dev.txt

# Run tests
pytest -q

echo "Setup complete."
