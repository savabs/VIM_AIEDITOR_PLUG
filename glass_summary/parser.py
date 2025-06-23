from pathlib import Path
import re
import markdown

def parse_markdown(path):
    text = Path(path).read_text(encoding='utf-8')
    html = markdown.markdown(
            text,
            extensions=['fenced_code', 'codehilite', 'tables'],
            output_format='html5'
            )
    return html 


