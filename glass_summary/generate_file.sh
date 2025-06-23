#!/bin/bash

# Where to put it
TARGET_DIR="${HOME}/.vim/custom/ai_summary/glass_summary"

# Create folders
mkdir -p "${TARGET_DIR}"

# 1. __init__.py
echo "" > "${TARGET_DIR}/__init__.py"

# 2. html_wrapper.py
cat <<'EOF' > "${TARGET_DIR}/html_wrapper.py"
HTML_WRAPPER = """\
<html>
    <head>
        <meta charset="utf-8">
        <style>
            body {{
                margin: 0;
                padding: 1em 2em;
                background: rgba(255, 255, 255, 0.08);
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                color: #eaeaea;
                font-family: 'Segoe UI', 'Fira Sans', 'Helvetica Neue', Arial, sans-serif;
                line-height: 1.6;
                font-size: 16px;
            }}

            h1 {{
                font-size: 1.8em;
                margin: 0.8em 0 0.4em;
                color: #00bfff;
                font-weight: bold;
            }}

            h2 {{
                font-size: 1.4em;
                margin: 0.7em 0 0.4em;
                color: #1e90ff;
                font-weight: bold;
            }}

            p {{
                margin: 0.5em 0;
                color: #f0f0f0;
            }}

            pre {{
                background: #1e1e1e;
                color: #dcdcdc;
                padding: 1em;
                border-radius: 8px;
                font-family: 'Fira Code', 'Menlo', 'Courier New', monospace;
                font-size: 14px;
                overflow-x: auto;
                line-height: 1.5;
                border: 1px solid rgba(255,255,255,0.1);
            }}

            code {{
                background: rgba(50, 50, 50, 0.7);
                color: #ffae57;
                font-family: 'Fira Code', 'Menlo', 'Courier New', monospace;
                padding: 0.2em 0.4em;
                border-radius: 4px;
                font-size: 0.95em;
            }}

            strong {{
                font-weight: bold;
                color: #ff6666;
            }}

            a {{
                color: #61dafb;
                text-decoration: none;
            }}

            a:hover {{
                text-decoration: underline;
            }}
        </style>
    </head>
    <body>
        {{content}}
    </body>
</html>
"""
EOF

# 3. parser.py
cat <<'EOF' > "${TARGET_DIR}/parser.py"
from pathlib import Path

def load_markdown(path):
    text = Path(path).read_text(encoding='utf-8')
    lines, in_code = [], False
    for ln in text.splitlines():
        if ln.startswith('```'):
            in_code = not in_code
            lines.append('<pre><code>' if in_code else '</code></pre>')
        elif in_code:
            lines.append(ln.replace('<','&lt;').replace('>','&gt;'))
        elif ln.startswith('## '):
            lines.append(f"<h2>{ln[3:].strip()}</h2>")
        elif ln.startswith('# '):
            lines.append(f"<h1>{ln[2:].strip()}</h1>")
        else:
            esc = ln.replace('&','&amp;').replace('<','&lt;').replace('>','&gt;')
            lines.append(f"<p>{esc}</p>")
    return "\n".join(lines)
EOF

# 4. ui.py
cat <<'EOF' > "${TARGET_DIR}/ui.py"
from PyQt5 import QtCore, QtGui, QtWidgets

class GlassWindow(QtWidgets.QWidget):
    def __init__(self, html_content, size=(900,600)):
        super().__init__()
        self._drag_pos = None

        self.setWindowFlags(
            QtCore.Qt.FramelessWindowHint |
            QtCore.Qt.WindowStaysOnTopHint
        )
        self.setAttribute(QtCore.Qt.WA_TranslucentBackground)
        self.resize(*size)

        shadow = QtWidgets.QGraphicsDropShadowEffect(blurRadius=20, xOffset=0, yOffset=0)
        shadow.setColor(QtGui.QColor(0,0,0,100))
        self.setGraphicsEffect(shadow)

        layout = QtWidgets.QVBoxLayout(self)
        layout.setContentsMargins(10,10,10,10)

        browser = QtWidgets.QTextBrowser()
        browser.setOpenLinks(False)
        browser.setStyleSheet("background: transparent;")
        browser.setFrameShape(QtWidgets.QFrame.NoFrame)
        browser.setHtml(html_content)

        layout.addWidget(browser)

    def mousePressEvent(self, event):
        if event.button() == QtCore.Qt.LeftButton:
            self._drag_pos = event.globalPos() - self.frameGeometry().topLeft()
            event.accept()

    def mouseMoveEvent(self, event):
        if self._drag_pos and event.buttons() & QtCore.Qt.LeftButton:
            self.move(event.globalPos() - self._drag_pos)
            event.accept()

    def mouseReleaseEvent(self, event):
        self._drag_pos = None
        event.accept()
EOF

# 5. main.py
cat <<'EOF' > "${TARGET_DIR}/main.py"
#!/usr/bin/env python3

import sys
from PyQt5 import QtWidgets
from glass_summary.html_wrapper import HTML_WRAPPER
from glass_summary.parser import load_markdown
from glass_summary.ui import GlassWindow

def main():
    if len(sys.argv) != 2:
        print("Usage: glass_summary/main.py <markdown-file>")
        sys.exit(1)

    app = QtWidgets.QApplication(sys.argv)

    content_html = HTML_WRAPPER.format(content=load_markdown(sys.argv[1]))
    win = GlassWindow(content_html)
    win.show()

    sys.exit(app.exec_())

if __name__ == "__main__":
    main()
EOF

# Mark main.py executable
chmod +x "${TARGET_DIR}/main.py"

echo "✅ All files created in: ${TARGET_DIR}"
echo "To run:"
echo "    python3 ${TARGET_DIR}/main.py /tmp/vim_ai_summary.log"

