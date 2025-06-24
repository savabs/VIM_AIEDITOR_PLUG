import sys
from pathlib import Path

sys.path.append(str(Path(__file__).resolve().parents[1]))

from glass_summary.parser import parse_markdown


def test_parse_markdown(tmp_path):
    md_text = "# Title\n\n## Subtitle\n\n```\ncode\n```\n"
    md_file = tmp_path / "sample.md"
    md_file.write_text(md_text, encoding="utf-8")
    html = parse_markdown(str(md_file))
    assert "<h1>Title</h1>" in html
    assert "<h2>Subtitle</h2>" in html
    assert "<pre" in html and "<code" in html
