#!/usr/bin/env python3
import sys
from PyQt5 import QtWidgets
from ui import GlassChatWindow

def main():
    app = QtWidgets.QApplication(sys.argv)
    win = GlassChatWindow()
    win.show()
    sys.exit(app.exec_())

if __name__ == '__main__':
    main()
