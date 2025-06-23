#!/usr/bin/env python3

import sys
from PyQt5 import QtWidgets
from html_wrapper import HTML_WRAPPER
from parser import parse_markdown
from ui import GlassCodeEditor

def main():
    if len(sys.argv) != 2:
        print("Usage: glass_summary/main.py <markdown-file>")
        sys.exit(1)
    
    app = QtWidgets.QApplication(sys.argv)
    parsed_html = parse_markdown(sys.argv[1])
    
    content_html = HTML_WRAPPER.format(content=parse_markdown(sys.argv[1]))
    win = GlassCodeEditor(content_html)  # Changed from GlassWindow to GlassCodeEditor
    win.show()

    sys.exit(app.exec_())

if __name__ == "__main__":
    main()
