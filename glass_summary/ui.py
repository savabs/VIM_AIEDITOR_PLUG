from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtGui import QFont
import sys
import os
import json
import html
import urllib.request

class GlassCodeEditor(QtWidgets.QWidget):
    def __init__(self, html_content, size=(1200, 800)):
        super().__init__()
        self._drag_pos = None

        # Validate size
        if not isinstance(size, tuple) or len(size) != 2 or not all(isinstance(x, int) for x in size):
            raise ValueError("size must be a tuple of two integers (width, height)")

        # Window flags: frameless, on top
        self.setWindowFlags(QtCore.Qt.FramelessWindowHint | QtCore.Qt.WindowStaysOnTopHint)
        self.setAttribute(QtCore.Qt.WA_TranslucentBackground)
        self.resize(*size)

        # Main layout
        main_layout = QtWidgets.QVBoxLayout(self)
        main_layout.setContentsMargins(0, 0, 0, 0)
        main_layout.setSpacing(0)

        # Glass background
        self.background = QtWidgets.QFrame()
        self.background.setStyleSheet("""
            QFrame {
                background: rgba(0, 0, 0, 0.5); /* Dark glass */
                border-radius: 15px;
            }
        """)
        self.background_layout = QtWidgets.QVBoxLayout(self.background)
        self.background_layout.setContentsMargins(15, 15, 15, 15)
        self.background_layout.setSpacing(8)

        # Toolbar with close button
        toolbar_layout = QtWidgets.QHBoxLayout()
        toolbar_layout.addStretch()

        # Close button
        close_btn = QtWidgets.QPushButton("✕")
        close_btn.setFixedSize(32, 32)
        close_btn.setStyleSheet("""
            QPushButton {
                border: none;
                border-radius: 16px;
                background: rgba(255, 80, 80, 0.8);
                color: white;
                font-size: 16px;
            }
            QPushButton:hover {
                background: rgba(255, 50, 50, 1.0);
            }
        """)
        close_btn.clicked.connect(self.close)
        toolbar_layout.addWidget(close_btn)

        # Content browser
        self.browser = QtWidgets.QTextBrowser()
        self.browser.setOpenLinks(False)
        self.browser.setFont(QFont("JetBrains Mono", 14))
        self.browser.setStyleSheet("""
            QTextBrowser {
                background: transparent;
                color: #ffffff;
                border: none;
                padding: 10px;
                font-family: 'JetBrains Mono', 'Fira Sans', 'Helvetica Neue', Arial, sans-serif;
            }
            QScrollBar:vertical {
                width: 8px;
                background: rgba(255, 255, 255, 0.1);
            }
            QScrollBar::handle:vertical {
                background: rgba(255, 255, 255, 0.3);
                border-radius: 4px;
            }
        """)
        self.browser.setHtml(html_content)

        # Assemble
        self.background_layout.addLayout(toolbar_layout)
        self.background_layout.addWidget(self.browser)
        main_layout.addWidget(self.background)

        # Dynamic theme adjustment
        QtCore.QTimer.singleShot(200, self.adjust_theme)

    def adjust_theme(self):
        screen = QtWidgets.QApplication.primaryScreen()
        screenshot = screen.grabWindow(0)
        geom = self.frameGeometry()
        center = geom.center()
        pixel_color = screenshot.toImage().pixelColor(center.x(), center.y())
        brightness = 0.2126 * pixel_color.red() + 0.7152 * pixel_color.green() + 0.0722 * pixel_color.blue()
        text_color = "#000000" if brightness > 128 else "#ffffff"
        self.browser.setStyleSheet(f"""
            QTextBrowser {{
                background: transparent;
                color: {text_color};
                border: none;
                padding: 10px;
                font-family: 'JetBrains Mono', 'Fira Sans', 'Helvetica Neue', Arial, sans-serif;
                font-size: 14px;
            }}
            QScrollBar:vertical {{
                width: 8px;
                background: rgba(255, 255, 255, 0.1);
            }}
            QScrollBar::handle:vertical {{
                background: rgba(255, 255, 255, 0.3);
                border-radius: 4px;
            }}
        """)

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


class GlassChatWindow(GlassCodeEditor):
    """Glass window with a chat input at the bottom."""

    def __init__(self, size=(1200, 800)):
        super().__init__("<h2>AI Chat</h2>", size=size)
        self.history = []

        self.input = QtWidgets.QLineEdit()
        self.input.setPlaceholderText("Type a message and press Enter")
        self.input.returnPressed.connect(self.handle_send)

        self.background_layout.addWidget(self.input)

    def append_message(self, role, text):
        safe = html.escape(text)
        self.browser.append(f"<b>{role}:</b> {safe}")

    def call_openai(self, message):
        api_key = os.environ.get("OPENAI_API_KEY", "")
        if not api_key:
            return "[OPENAI_API_KEY not set]"

        self.history.append({"role": "user", "content": message})
        req_body = json.dumps({
            "model": "gpt-4o-2024-05-13",
            "max_tokens": 2048,
            "messages": self.history,
        }).encode("utf-8")

        req = urllib.request.Request(
            "https://api.openai.com/v1/chat/completions",
            data=req_body,
            headers={
                "Content-Type": "application/json",
                "Authorization": f"Bearer {api_key}",
            },
        )

        try:
            with urllib.request.urlopen(req) as resp:
                data = json.loads(resp.read().decode("utf-8"))
                reply = data["choices"][0]["message"]["content"]
        except Exception as e:
            reply = f"[error] {e}"

        self.history.append({"role": "assistant", "content": reply})
        return reply

    def handle_send(self):
        text = self.input.text().strip()
        if not text:
            return
        self.input.clear()
        self.append_message('You', text)
        reply = self.call_openai(text)
        self.append_message('AI', reply)

if __name__ == "__main__":
    app = QtWidgets.QApplication(sys.argv)
    editor = GlassCodeEditor("<h1>Test Content</h1><p>This is a test.</p>")
    editor.show()
    sys.exit(app.exec_())
