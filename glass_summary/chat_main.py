#!/usr/bin/env python3
import sys
from PyQt5 import QtWidgets
from ui import GlassChatWindow

def main():
    file_content = None
    if len(sys.argv) > 1:
        path = sys.argv[1]
        try:
            with open(path, "r", encoding="utf-8") as f:
                file_content = f.read()
        except Exception:
            file_content = f"[could not read {path}]"

    app = QtWidgets.QApplication(sys.argv[:1])
    win = GlassChatWindow(file_content=file_content)
    win.show()
    sys.exit(app.exec_())

if __name__ == '__main__':
    main()
