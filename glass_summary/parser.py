from pathlib import Path
import markdown


def parse_markdown_text(text: str) -> str:
    """Convert Markdown text to HTML."""
    return markdown.markdown(
        text,
        extensions=["fenced_code", "codehilite", "tables"],
        output_format="html5",
    )

def parse_markdown(path: str) -> str:
    """Read Markdown from *path* and return HTML."""
    text = Path(path).read_text(encoding="utf-8")
    return parse_markdown_text(text)



